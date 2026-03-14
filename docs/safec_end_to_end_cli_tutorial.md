# SafeC End-to-End CLI Tutorial

This is a small host-local walkthrough for testing the current `safec`
compiler end to end after it has already been built.

It is intentionally practical rather than portable:

- it assumes you are running from this repository checkout
- it assumes the Ada toolchain is available through Alire on this host
- it uses the current macOS SDK discovery path for the final native link step

The flow below does four things:

1. writes a small Safe program
2. checks it with `safec check`
3. emits JSON plus Ada/SPARK with `safec emit --ada-out-dir`
4. compiles and runs a tiny Ada driver against the emitted package

## 1. Start From the Repo Root

```bash
cd /Users/agentc1/src/github.com/agentc1/safe
```

The compiler binary should already exist at:

```bash
compiler_impl/bin/safec
```

If you need to rebuild it first:

```bash
cd compiler_impl
$HOME/bin/alr build
cd ..
```

## 2. Create a Temporary Work Area

```bash
WORK="$(mktemp -d "${TMPDIR:-/tmp}/safec-e2e.XXXXXX")"
mkdir -p "$WORK/out" "$WORK/iface" "$WORK/ada"
```

## 3. Write an Interesting Safe Sample

This sample uses two functions:

- `Signum`, which returns `-1`, `0`, or `1`
- `Bounded_Add`, which adds two small values and returns a wider bounded result

Save it as `"$WORK/safe_return.safe"`:

```bash
cat > "$WORK/safe_return.safe" <<'EOF'
package Safe_Return is

   type Bounded is range -500 .. 500;
   type Small is range -10 .. 10;

   function Signum (V : Bounded) return Small is
   begin
      if V > 0 then
         return 1;
      elsif V < 0 then
         return -1;
      else
         return 0;
      end if;
   end Signum;

   function Bounded_Add (A, B : Small) return Bounded is
   begin
      return Bounded (A) + Bounded (B);
   end Bounded_Add;

end Safe_Return;
EOF
```

## 4. Run the Compiler Frontend

First run the normal frontend check:

```bash
compiler_impl/bin/safec check "$WORK/safe_return.safe"
```

Then emit all artifacts, including Ada/SPARK:

```bash
compiler_impl/bin/safec emit \
  "$WORK/safe_return.safe" \
  --out-dir "$WORK/out" \
  --interface-dir "$WORK/iface" \
  --ada-out-dir "$WORK/ada"
```

You should now have:

```text
$WORK/out/safe_return.ast.json
$WORK/out/safe_return.typed.json
$WORK/out/safe_return.mir.json
$WORK/iface/safe_return.safei.json
$WORK/ada/safe_return.ads
$WORK/ada/safe_return.adb
$WORK/ada/safe_runtime.ads
```

You can also validate the emitted MIR directly:

```bash
compiler_impl/bin/safec validate-mir "$WORK/out/safe_return.mir.json"
compiler_impl/bin/safec analyze-mir "$WORK/out/safe_return.mir.json"
```

## 5. Write a Tiny Ada Driver

The emitted Safe package is a normal Ada package, so the easiest way to execute
it is to compile a small Ada `main.adb` that calls into it.

Save this as `"$WORK/main.adb"`:

```bash
cat > "$WORK/main.adb" <<'EOF'
with Ada.Text_IO; use Ada.Text_IO;
with Safe_Return;
use type Safe_Return.Small;
use type Safe_Return.Bounded;

procedure Main is
   S1 : Safe_Return.Small;
   S2 : Safe_Return.Bounded;
begin
   S1 := Safe_Return.Signum (-42);
   S2 := Safe_Return.Bounded_Add (-3, 7);

   Put_Line ("Signum(-42) =" & Integer'Image (Integer (S1)));
   Put_Line ("Bounded_Add(-3, 7) =" & Integer'Image (Integer (S2)));
end Main;
EOF
```

Create a minimal project file:

```bash
cat > "$WORK/build.gpr" <<'EOF'
project Build is
   for Source_Dirs use (".", "ada");
   for Object_Dir use "obj";
end Build;
EOF
```

## 6. Compile and Run the Emitted Ada

On this macOS host, the final native link step needs `SDKROOT` and an explicit
`-syslibroot` linker argument.

```bash
export SDKROOT="$(xcrun --show-sdk-path)"

cd compiler_impl
$HOME/bin/alr exec -- \
  gprbuild \
  -P "$WORK/build.gpr" \
  main.adb \
  -largs "-Wl,-syslibroot,$SDKROOT"
cd ..
```

The executable is written to:

```text
$WORK/obj/main
```

Run it:

```bash
"$WORK/obj/main"
```

Expected output:

```text
Signum(-42) =-1
Bounded_Add(-3, 7) = 4
```

## 7. What This Proves

If all of the steps above pass, you have exercised the current compiler stack
end to end on this host:

- Safe source parsing and semantic checking
- MIR emission and validation
- `safei-v1` interface emission
- PR09 Ada/SPARK emission
- host-local Ada compilation of the emitted package
- execution of a native binary linked against the emitted code

## Notes

- This is a host-local smoke path, not a replacement for the repo gates.
- The PR09 CI gates are intentionally compile-only; the explicit native link and
  execution step here goes beyond what CI currently enforces.
- If you want a minimal emission-only sample instead, use
  `tests/positive/emitter_surface_proc.safe`.
