#!/usr/bin/env python3
"""Run the local Renode-based embedded smoke lane."""

from __future__ import annotations

import argparse
import os
import re
import shutil
import socket
import subprocess
import sys
import tempfile
import textwrap
import time
from dataclasses import dataclass
from pathlib import Path

from _lib.harness_common import COMPILER_ROOT, REPO_ROOT, require
from _lib.pr111_language_eval import emitted_primary_unit


ALR_FALLBACK = Path.home() / "bin" / "alr"
RENODE_ASSETS_ROOT = REPO_ROOT / "tools" / "embedded" / "renode"
EMBEDDED_TESTS_ROOT = REPO_ROOT / "tests" / "embedded"
DEFAULT_TIMEOUT_SECONDS = 30.0
MONITOR_CONNECT_TIMEOUT_SECONDS = 10.0
MONITOR_COMMAND_TIMEOUT_SECONDS = 5.0
MONITOR_POLL_INTERVAL_SECONDS = 0.1
STATUS_POLL_DELAY_SECONDS = 0.01
STATUS_PASS = 1
STATUS_FAIL = 2
VALUE_RE = re.compile(r"0x[0-9a-fA-F]+|\b\d+\b")
ANSI_ESCAPE_RE = re.compile(r"\x1b\[[0-9;]*[A-Za-z]")


@dataclass(frozen=True)
class TargetConfig:
    name: str
    runtime: str
    platform: Path


@dataclass(frozen=True)
class EmbeddedCase:
    name: str
    source: Path
    expected_result: int


TARGETS = {
    "stm32f4": TargetConfig(
        name="stm32f4",
        runtime="light-tasking-stm32f4",
        platform=RENODE_ASSETS_ROOT / "stm32f4_discovery.repl",
    ),
}

CASES = {
    "entry_integer_result": EmbeddedCase(
        name="entry_integer_result",
        source=EMBEDDED_TESTS_ROOT / "entry_integer_result.safe",
        expected_result=42,
    ),
    "package_integer_result": EmbeddedCase(
        name="package_integer_result",
        source=EMBEDDED_TESTS_ROOT / "package_integer_result.safe",
        expected_result=42,
    ),
    "binary_shift_result": EmbeddedCase(
        name="binary_shift_result",
        source=EMBEDDED_TESTS_ROOT / "binary_shift_result.safe",
        expected_result=32,
    ),
    "scoped_receive_result": EmbeddedCase(
        name="scoped_receive_result",
        source=EMBEDDED_TESTS_ROOT / "scoped_receive_result.safe",
        expected_result=4,
    ),
    "producer_consumer_result": EmbeddedCase(
        name="producer_consumer_result",
        source=EMBEDDED_TESTS_ROOT / "producer_consumer_result.safe",
        expected_result=42,
    ),
    "delay_scope_result": EmbeddedCase(
        name="delay_scope_result",
        source=EMBEDDED_TESTS_ROOT / "delay_scope_result.safe",
        expected_result=2,
    ),
}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Run the local Renode-based embedded Safe smoke lane."
    )
    parser.add_argument(
        "--target",
        choices=("stm32f4", "all"),
        default="all",
        help="Embedded target to exercise.",
    )
    parser.add_argument(
        "--case",
        action="append",
        choices=sorted(CASES),
        help="Limit the run to one or more named cases.",
    )
    parser.add_argument(
        "--timeout",
        type=float,
        default=DEFAULT_TIMEOUT_SECONDS,
        help=f"Per-case timeout in seconds (default: {DEFAULT_TIMEOUT_SECONDS:g}).",
    )
    parser.add_argument(
        "--keep-temp",
        action="store_true",
        help="Preserve successful temp roots instead of deleting them.",
    )
    parser.add_argument(
        "--list-cases",
        action="store_true",
        help="Print the available embedded smoke cases and exit.",
    )
    return parser.parse_args()


def find_command(name: str, fallback: Path | None = None) -> str:
    found = shutil.which(name)
    if found:
        return found
    if fallback is not None and fallback.exists():
        return str(fallback)
    raise FileNotFoundError(f"required command not found: {name}")


def first_message(completed: subprocess.CompletedProcess[str]) -> str:
    for stream in (completed.stderr, completed.stdout):
        for line in stream.splitlines():
            stripped = line.strip()
            if stripped:
                return stripped
    return f"exit code {completed.returncode}"


def run_capture(
    argv: list[str],
    *,
    cwd: Path,
    env: dict[str, str] | None = None,
    timeout: float | None = None,
) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        argv,
        cwd=cwd,
        env=env,
        text=True,
        capture_output=True,
        check=False,
        timeout=timeout,
    )


def run_logged(
    argv: list[str],
    *,
    cwd: Path,
    stdout_path: Path,
    stderr_path: Path,
    env: dict[str, str] | None = None,
) -> subprocess.CompletedProcess[str]:
    stdout_path.parent.mkdir(parents=True, exist_ok=True)
    stderr_path.parent.mkdir(parents=True, exist_ok=True)
    with stdout_path.open("w", encoding="utf-8") as stdout_handle:
        with stderr_path.open("w", encoding="utf-8") as stderr_handle:
            return subprocess.run(
                argv,
                cwd=cwd,
                env=env,
                text=True,
                stdout=stdout_handle,
                stderr=stderr_handle,
                check=False,
            )


def build_compiler() -> Path:
    alr = find_command("alr", ALR_FALLBACK)
    completed = run_capture([alr, "build"], cwd=COMPILER_ROOT, env=os.environ.copy())
    if completed.returncode != 0:
        raise RuntimeError(first_message(completed))
    safec = COMPILER_ROOT / "bin" / "safec"
    require(safec.exists(), f"missing safec binary at {safec}")
    return safec


def selected_targets(name: str) -> list[TargetConfig]:
    if name == "all":
        return [TARGETS["stm32f4"]]
    return [TARGETS[name]]


def selected_cases(names: list[str] | None) -> list[EmbeddedCase]:
    if not names:
        return [CASES[name] for name in sorted(CASES)]
    return [CASES[name] for name in names]


def detect_arm_triplet() -> tuple[str, str]:
    for triplet in ("arm-elf", "arm-eabi"):
        gnatls = shutil.which(f"{triplet}-gnatls")
        if gnatls:
            return triplet, gnatls
    raise FileNotFoundError(
        "required cross tool not found: arm-elf-gnatls or arm-eabi-gnatls"
    )


def require_prerequisites(*, triplet: str) -> dict[str, str]:
    renode = find_command("renode")
    gprbuild = find_command("gprbuild")
    gnatls = find_command(f"{triplet}-gnatls")
    nm = find_command(f"{triplet}-nm")
    for target in TARGETS.values():
        require(target.platform.exists(), f"missing Renode platform asset {target.platform}")
    return {
        "renode": renode,
        "gprbuild": gprbuild,
        "gnatls": gnatls,
        "nm": nm,
    }


def case_root(label: str) -> Path:
    return Path(tempfile.mkdtemp(prefix=f"safe-embedded-{label}-"))


def remove_tree(path: Path) -> None:
    shutil.rmtree(path, ignore_errors=True)


def write_case_source(path: Path, contents: str) -> None:
    path.write_text(textwrap.dedent(contents).lstrip(), encoding="utf-8")


def case_paths(root: Path) -> dict[str, Path]:
    return {
        "root": root,
        "out": root / "out",
        "iface": root / "iface",
        "ada": root / "ada",
        "obj": root / "obj",
        "logs": root / "logs",
        "status_spec": root / "safe_embedded_status.ads",
        "driver": root / "embedded_main.adb",
        "gpr": root / "build.gpr",
        "resc": root / "run.resc",
        "exe": root / "embedded_main",
        "emit_stdout": root / "logs" / "emit.stdout.log",
        "emit_stderr": root / "logs" / "emit.stderr.log",
        "build_stdout": root / "logs" / "build.stdout.log",
        "build_stderr": root / "logs" / "build.stderr.log",
        "renode_stdout": root / "logs" / "renode.stdout.log",
        "renode_stderr": root / "logs" / "renode.stderr.log",
    }


def ensure_case_dirs(paths: dict[str, Path]) -> None:
    paths["out"].mkdir(parents=True, exist_ok=True)
    paths["iface"].mkdir(parents=True, exist_ok=True)
    paths["ada"].mkdir(parents=True, exist_ok=True)
    paths["obj"].mkdir(parents=True, exist_ok=True)
    paths["logs"].mkdir(parents=True, exist_ok=True)


def emit_case(
    *,
    safec: Path,
    source: Path,
    paths: dict[str, Path],
) -> tuple[bool, str]:
    completed = run_logged(
        [
            str(safec),
            "emit",
            str(source),
            "--out-dir",
            str(paths["out"]),
            "--interface-dir",
            str(paths["iface"]),
            "--ada-out-dir",
            str(paths["ada"]),
        ],
        cwd=REPO_ROOT,
        stdout_path=paths["emit_stdout"],
        stderr_path=paths["emit_stderr"],
        env=os.environ.copy(),
    )
    if completed.returncode != 0:
        return False, f"emit failed: {paths['emit_stderr'].read_text(encoding='utf-8').strip() or paths['emit_stdout'].read_text(encoding='utf-8').strip() or f'exit code {completed.returncode}'}"
    return True, ""


def status_spec_text() -> str:
    return (
        "with Interfaces;\n"
        "\n"
        "package Safe_Embedded_Status is\n"
        "   Value : Interfaces.Unsigned_32 := 0\n"
        "     with Export,\n"
        "          Convention => C,\n"
        "          External_Name => \"safe_embedded_status\",\n"
        "          Volatile;\n"
        "end Safe_Embedded_Status;\n"
    )


def driver_text(unit_name: str, expected_result: int) -> str:
    return (
        "with Interfaces;\n"
        "with Safe_Embedded_Status;\n"
        f"with {unit_name};\n"
        "\n"
        "procedure Embedded_Main is\n"
        f"   Expected_Result : constant Long_Long_Integer := {expected_result};\n"
        "   Pass_Status : constant Interfaces.Unsigned_32 := 1;\n"
        "   Fail_Status : constant Interfaces.Unsigned_32 := 2;\n"
        "begin\n"
        "   loop\n"
        "      declare\n"
        f"         Current : constant Long_Long_Integer := Long_Long_Integer ({unit_name}.result);\n"
        "      begin\n"
        "         if Current = Expected_Result then\n"
        "            Safe_Embedded_Status.Value := Pass_Status;\n"
        "         elsif Current > Expected_Result then\n"
        "            Safe_Embedded_Status.Value := Fail_Status;\n"
        "         end if;\n"
        "      end;\n"
        f"      delay {STATUS_POLL_DELAY_SECONDS:.2f};\n"
        "   end loop;\n"
        "end Embedded_Main;\n"
    )


def project_text(
    *,
    has_gnat_adc: bool,
    gnat_adc_path: Path,
) -> str:
    ada_switches = '("-gnatws")'
    if has_gnat_adc:
        ada_switches = ada_switches + f' & ("-gnatec={gnat_adc_path.as_posix()}")'
    lines = [
        "project Build is",
        '   for Source_Dirs use (".", "ada");',
        '   for Object_Dir use "obj";',
        '   for Exec_Dir use ".";',
        '   for Main use ("embedded_main.adb");',
        "   package Compiler is",
        f'      for Default_Switches ("Ada") use {ada_switches};',
        "   end Compiler;",
    ]
    lines.append("end Build;")
    return "\n".join(lines) + "\n"


def wrapper_resc_text(*, machine_name: str, platform_path: Path, elf_path: Path) -> str:
    return (
        "using sysbus\n"
        f"mach create \"{machine_name}\"\n"
        f"machine LoadPlatformDescription @{platform_path}\n"
        f"sysbus LoadELF @{elf_path}\n"
        "mach set 0\n"
        "start\n"
    )


def find_free_port() -> int:
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as handle:
        handle.bind(("127.0.0.1", 0))
        return int(handle.getsockname()[1])


class RenodeMonitor:
    def __init__(self, sock: socket.socket):
        self.sock = sock

    @classmethod
    def connect(cls, *, port: int, timeout: float) -> "RenodeMonitor":
        deadline = time.monotonic() + timeout
        last_error: OSError | None = None
        while time.monotonic() < deadline:
            try:
                sock = socket.create_connection(("127.0.0.1", port), timeout=0.5)
                sock.settimeout(0.5)
                monitor = cls(sock)
                monitor._read_until_idle(timeout=0.5)
                return monitor
            except OSError as exc:
                last_error = exc
                time.sleep(0.1)
        raise RuntimeError(f"Renode monitor not ready on port {port}: {last_error}")

    def close(self) -> None:
        self.sock.close()

    def _read_until_idle(self, *, timeout: float) -> str:
        deadline = time.monotonic() + timeout
        idle_deadline: float | None = None
        chunks = bytearray()
        while time.monotonic() < deadline:
            try:
                chunk = self.sock.recv(4096)
            except socket.timeout:
                if chunks:
                    return chunks.decode("utf-8", errors="replace")
                continue
            if not chunk:
                break
            chunks.extend(chunk)
            idle_deadline = time.monotonic() + 0.2
            while idle_deadline is not None and time.monotonic() < idle_deadline:
                try:
                    chunk = self.sock.recv(4096)
                except socket.timeout:
                    break
                if not chunk:
                    return chunks.decode("utf-8", errors="replace")
                chunks.extend(chunk)
                idle_deadline = time.monotonic() + 0.2
            return chunks.decode("utf-8", errors="replace")
        if chunks:
            return chunks.decode("utf-8", errors="replace")
        raise RuntimeError("timed out waiting for Renode monitor response")

    def command(self, text: str, *, timeout: float = MONITOR_COMMAND_TIMEOUT_SECONDS) -> str:
        self.sock.sendall((text + "\n").encode("utf-8"))
        return self._read_until_idle(timeout=timeout)


def parse_monitor_value(text: str) -> int:
    cleaned = ANSI_ESCAPE_RE.sub("", text).replace("\r", "")
    hex_matches = re.findall(r"0x[0-9a-fA-F]+", cleaned)
    if hex_matches:
        token = hex_matches[-1]
        return int(token, 16)
    matches = re.findall(r"\b\d+\b", cleaned)
    if not matches:
        raise RuntimeError(f"unable to parse numeric monitor response: {cleaned.strip()!r}")
    token = matches[-1]
    if token.startswith("0x"):
        return int(token, 16)
    return int(token, 10)


def renode_command(renode: str, *, port: int, script_path: Path) -> list[str]:
    return [
        renode,
        "--disable-gui",
        "-P",
        str(port),
        "-e",
        f"i @{script_path}",
    ]


def stop_process(process: subprocess.Popen[str]) -> None:
    if process.poll() is not None:
        return
    process.terminate()
    try:
        process.wait(timeout=5)
    except subprocess.TimeoutExpired:
        process.kill()
        process.wait(timeout=5)


def build_embedded_case(
    *,
    gprbuild: str,
    triplet: str,
    runtime: str,
    paths: dict[str, Path],
) -> tuple[bool, str]:
    completed = run_logged(
        [
            gprbuild,
            f"--target={triplet}",
            f"--RTS={runtime}",
            "-P",
            str(paths["gpr"]),
            "-cargs:Ada",
            "-gnatws",
        ],
        cwd=paths["root"],
        stdout_path=paths["build_stdout"],
        stderr_path=paths["build_stderr"],
        env=os.environ.copy(),
    )
    if completed.returncode != 0:
        stderr = paths["build_stderr"].read_text(encoding="utf-8").strip()
        stdout = paths["build_stdout"].read_text(encoding="utf-8").strip()
        return False, f"build failed: {stderr or stdout or f'exit code {completed.returncode}'}"
    if not paths["exe"].exists():
        return False, f"build failed: missing executable {paths['exe']}"
    return True, ""


def resolve_status_address(*, nm: str, exe_path: Path) -> int:
    completed = run_capture([nm, str(exe_path)], cwd=exe_path.parent, env=os.environ.copy())
    if completed.returncode != 0:
        raise RuntimeError(first_message(completed))
    for line in completed.stdout.splitlines():
        parts = line.strip().split()
        if len(parts) >= 3 and parts[-1] == "safe_embedded_status":
            return int(parts[0], 16)
    raise RuntimeError(f"unable to resolve safe_embedded_status in {exe_path}")


def run_under_renode(
    *,
    renode: str,
    nm: str,
    paths: dict[str, Path],
    timeout_seconds: float,
) -> tuple[bool, str]:
    port = find_free_port()
    with paths["renode_stdout"].open("w", encoding="utf-8") as stdout_handle:
        with paths["renode_stderr"].open("w", encoding="utf-8") as stderr_handle:
            process = subprocess.Popen(
                renode_command(renode, port=port, script_path=paths["resc"]),
                cwd=paths["root"],
                stdout=stdout_handle,
                stderr=stderr_handle,
                text=True,
            )
    try:
        bootstrap_monitor = RenodeMonitor.connect(
            port=port, timeout=MONITOR_CONNECT_TIMEOUT_SECONDS
        )
        bootstrap_monitor.close()
        address = resolve_status_address(nm=nm, exe_path=paths["exe"])
        deadline = time.monotonic() + timeout_seconds
        while time.monotonic() < deadline:
            monitor = RenodeMonitor.connect(
                port=port, timeout=MONITOR_CONNECT_TIMEOUT_SECONDS
            )
            try:
                status_output = monitor.command(f"sysbus ReadDoubleWord {hex(address)}")
            finally:
                monitor.close()
            status = parse_monitor_value(status_output)
            if status == STATUS_PASS:
                return True, ""
            if status == STATUS_FAIL:
                return False, "simulation reported failure status"
            time.sleep(MONITOR_POLL_INTERVAL_SECONDS)
        return False, f"timed out after {timeout_seconds:g}s"
    finally:
        stop_process(process)


def create_support_files(
    *,
    paths: dict[str, Path],
    unit_name: str,
    expected_result: int,
    target: TargetConfig,
) -> None:
    paths["status_spec"].write_text(status_spec_text(), encoding="utf-8")
    paths["driver"].write_text(driver_text(unit_name, expected_result), encoding="utf-8")
    paths["gpr"].write_text(
        project_text(
            has_gnat_adc=(paths["ada"] / "gnat.adc").exists(),
            gnat_adc_path=paths["ada"] / "gnat.adc",
        ),
        encoding="utf-8",
    )
    paths["resc"].write_text(
        wrapper_resc_text(
            machine_name=f"safe_{target.name}",
            platform_path=target.platform,
            elf_path=paths["exe"],
        ),
        encoding="utf-8",
    )


def preserve_or_cleanup(root: Path, *, keep_temp: bool, success: bool) -> Path | None:
    if keep_temp or not success:
        return root
    remove_tree(root)
    return None


def run_case(
    *,
    safec: Path,
    gprbuild: str,
    renode: str,
    nm: str,
    triplet: str,
    target: TargetConfig,
    case: EmbeddedCase,
    timeout_seconds: float,
    keep_temp: bool,
) -> tuple[bool, str, Path | None]:
    root = case_root(f"{target.name}-{case.name}")
    paths = case_paths(root)
    ensure_case_dirs(paths)

    ok, detail = emit_case(safec=safec, source=case.source, paths=paths)
    if not ok:
        preserved = preserve_or_cleanup(root, keep_temp=keep_temp, success=False)
        return False, detail, preserved

    unit_name = emitted_primary_unit(paths["ada"])
    create_support_files(
        paths=paths,
        unit_name=unit_name,
        expected_result=case.expected_result,
        target=target,
    )

    ok, detail = build_embedded_case(
        gprbuild=gprbuild,
        triplet=triplet,
        runtime=target.runtime,
        paths=paths,
    )
    if not ok:
        preserved = preserve_or_cleanup(root, keep_temp=keep_temp, success=False)
        return False, detail, preserved

    ok, detail = run_under_renode(
        renode=renode,
        nm=nm,
        paths=paths,
        timeout_seconds=timeout_seconds,
    )
    preserved = preserve_or_cleanup(root, keep_temp=keep_temp, success=ok)
    return ok, detail, preserved


def write_jorvik_probe_source(path: Path) -> None:
    write_case_source(
        path,
        """
        package embedded_jorvik_probe

           result : integer (0 to 1) = 0;

           task worker with priority = 10
              loop
                 result = 1
                 delay 0.05
        """,
    )


def run_jorvik_probe(
    *,
    safec: Path,
    gprbuild: str,
    renode: str,
    nm: str,
    triplet: str,
    target: TargetConfig,
    timeout_seconds: float,
    keep_temp: bool,
) -> tuple[bool, str, Path | None]:
    root = case_root(f"{target.name}-jorvik-probe")
    source = root / "embedded_jorvik_probe.safe"
    paths = case_paths(root)
    ensure_case_dirs(paths)
    write_jorvik_probe_source(source)

    ok, detail = emit_case(safec=safec, source=source, paths=paths)
    if not ok:
        preserved = preserve_or_cleanup(root, keep_temp=keep_temp, success=False)
        return False, detail, preserved

    unit_name = emitted_primary_unit(paths["ada"])
    create_support_files(
        paths=paths,
        unit_name=unit_name,
        expected_result=1,
        target=target,
    )

    ok, detail = build_embedded_case(
        gprbuild=gprbuild,
        triplet=triplet,
        runtime=target.runtime,
        paths=paths,
    )
    if not ok:
        preserved = preserve_or_cleanup(root, keep_temp=keep_temp, success=False)
        return False, detail, preserved

    ok, detail = run_under_renode(
        renode=renode,
        nm=nm,
        paths=paths,
        timeout_seconds=timeout_seconds,
    )
    preserved = preserve_or_cleanup(root, keep_temp=keep_temp, success=ok)
    return ok, detail, preserved


def print_case_list() -> int:
    for name in sorted(CASES):
        print(name)
    return 0


def print_summary(*, target_name: str, passed: int, total: int) -> None:
    print(f"{target_name}: {passed} passed, {total - passed} failed")


def main() -> int:
    args = parse_args()
    if args.list_cases:
        return print_case_list()

    cases = selected_cases(args.case)

    try:
        safec = build_compiler()
        triplet, _ = detect_arm_triplet()
        commands = require_prerequisites(triplet=triplet)
    except (FileNotFoundError, RuntimeError) as exc:
        print(f"run_embedded_smoke: ERROR: {exc}", file=sys.stderr)
        return 1

    total_passed = 0
    failures: list[tuple[str, str, Path | None]] = []

    for target in selected_targets(args.target):
        try:
            runtime_probe = run_capture(
                [commands["gnatls"], f"--RTS={target.runtime}", "-v"],
                cwd=REPO_ROOT,
                env=os.environ.copy(),
            )
            if runtime_probe.returncode != 0:
                raise RuntimeError(
                    f"required runtime {target.runtime!r} is not available for {triplet}: "
                    f"{first_message(runtime_probe)}"
                )
        except RuntimeError as exc:
            failures.append((target.name, str(exc), None))
            print_summary(target_name=target.name, passed=0, total=len(cases))
            continue

        probe_ok, probe_detail, probe_root = run_jorvik_probe(
            safec=safec,
            gprbuild=commands["gprbuild"],
            renode=commands["renode"],
            nm=commands["nm"],
            triplet=triplet,
            target=target,
            timeout_seconds=args.timeout,
            keep_temp=args.keep_temp,
        )
        if not probe_ok:
            failures.append(
                (
                    target.name,
                    f"Jorvik runtime probe failed: {probe_detail}",
                    probe_root,
                )
            )
            print_summary(target_name=target.name, passed=0, total=len(cases))
            continue

        passed = 0
        for case in cases:
            ok, detail, preserved = run_case(
                safec=safec,
                gprbuild=commands["gprbuild"],
                renode=commands["renode"],
                nm=commands["nm"],
                triplet=triplet,
                target=target,
                case=case,
                timeout_seconds=args.timeout,
                keep_temp=args.keep_temp,
            )
            label = f"{target.name}:{case.name}"
            if ok:
                passed += 1
                total_passed += 1
            else:
                failures.append((label, detail, preserved))
        print_summary(target_name=target.name, passed=passed, total=len(cases))

    print(f"{total_passed} passed, {len(failures)} failed")
    if failures:
        print("Failures:")
        for label, detail, preserved in failures:
            suffix = f" (artifacts: {preserved})" if preserved is not None else ""
            print(f" - {label}: {detail}{suffix}")
    return 0 if not failures else 1


if __name__ == "__main__":
    raise SystemExit(main())
