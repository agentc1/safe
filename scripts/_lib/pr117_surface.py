"""Shared corpus and readability examples for the PR11.7 reference-surface gate."""

from __future__ import annotations

from pathlib import Path
from typing import Any

from .pr09_emit import REPO_ROOT


PR117_TECHNICAL_CASES: tuple[dict[str, Any], ...] = (
    {
        "source": REPO_ROOT / "tests" / "positive" / "ownership_move.safe",
        "coverage_note": "Owned reference locals and dereference-heavy mutation.",
    },
    {
        "source": REPO_ROOT / "tests" / "positive" / "ownership_borrow.safe",
        "coverage_note": "Anonymous access parameters plus repeated dereference through a borrower and owner.",
    },
    {
        "source": REPO_ROOT / "tests" / "positive" / "ownership_observe_access.safe",
        "coverage_note": "Local observe path through `.Access` and `access constant` bindings.",
    },
    {
        "source": REPO_ROOT / "tests" / "positive" / "ownership_return.safe",
        "coverage_note": "Owned access result flow through returns and assignment targets.",
    },
    {
        "source": REPO_ROOT / "tests" / "positive" / "rule4_deref.safe",
        "coverage_note": "Not-null access parameters with explicit `.all` reads and writes.",
    },
    {
        "source": REPO_ROOT / "tests" / "positive" / "rule4_linked_list.safe",
        "coverage_note": "Reference-heavy traversal with access-typed fields and observer progression.",
    },
)

PR117_NEGATIVE_CASES: tuple[dict[str, Any], ...] = (
    {
        "source": REPO_ROOT / "tests" / "negative" / "neg_pr117_lowercase_access_binding.safe",
        "reason": "source_frontend_error",
        "message": "reference-signal experiment requires local binding `owner` to start with a uppercase letter",
        "default_mode_expected_success": True,
    },
    {
        "source": REPO_ROOT / "tests" / "negative" / "neg_pr117_uppercase_value_binding.safe",
        "reason": "source_frontend_error",
        "message": "reference-signal experiment requires local binding `Total` to start with a lowercase letter",
        "default_mode_expected_success": True,
    },
    {
        "source": REPO_ROOT / "tests" / "negative" / "neg_pr117_lowercase_access_field.safe",
        "reason": "source_frontend_error",
        "message": "reference-signal experiment requires record field `next` to start with a uppercase letter",
        "default_mode_expected_success": True,
    },
    {
        "source": REPO_ROOT / "tests" / "negative" / "neg_pr117_casefold_collision.safe",
        "reason": "source_frontend_error",
        "message": "reference-signal experiment rejects local binding `source` because it collides by case-folding with `Source`",
    },
)

PR117_MIGRATION_EXAMPLES: tuple[dict[str, Any], ...] = (
    {
        "name": "reference_signal_binding_and_field_case",
        "mode": "reference-signal",
        "source": """package Demo

   type payload is record
      value : Integer;
      next  : payload_ptr;

   type payload_ptr is access payload;

   function transfer
      source : payload_ptr = new ((value = 42, next = null) as payload);
      target : payload_ptr = null;

      target = source;
      target.all.value = 100;
""",
        "required_fragments": (
            "value : Integer;",
            "Next  : payload_ptr;",
            "Source : payload_ptr = new ((value = 42, Next = null) as payload);",
            "Target : payload_ptr = null;",
        ),
    },
    {
        "name": "combined_reference_signal_and_implicit_deref",
        "mode": "combined",
        "source": """package Demo

   type node is record
      value : Integer;
      next  : node_ptr;

   type node_ptr is access node;

   function sum (head : node_ptr) returns Integer
      total : Integer = 0;

      if head != null
         total = total + head.all.value;
         if head.all.next != null
            total = total + head.all.next.all.value;
      return total;
""",
        "required_fragments": (
            "value : Integer;",
            "Next  : node_ptr;",
            "Head : node_ptr",
            "total = total + Head.value;",
            "if Head.Next != null",
            "total = total + Head.Next.value;",
        ),
        "forbidden_fragments": (
            ".all",
        ),
    },
)

PR117_READABILITY_EXAMPLES: tuple[dict[str, Any], ...] = (
    {
        "name": "ownership_transfer",
        "description": "Owned reference transfer and post-move mutation at the use site.",
        "source": """package Ownership_Transfer

   type payload is record
      value : Integer;

   type payload_ptr is access payload;

   function transfer
      source : payload_ptr = new ((value = 42) as payload);
      target : payload_ptr = null;

      target = source;
      target.all.value = 100;
""",
    },
    {
        "name": "linked_traversal",
        "description": "Null-guarded linked traversal with an access-typed field chain.",
        "source": """package Linked_Traversal

   type node;
   type node_ptr is access node;

   type node is record
      value : Integer;
      next  : node_ptr;

   function sum_values (head : node_ptr) returns Integer
      total : Integer = 0;

      if head != null
         total = total + head.all.value;
         if head.all.next != null
            total = total + head.all.next.all.value;
      return total;
""",
    },
    {
        "name": "local_observer",
        "description": "Local observer bound through `.Access` and then dereferenced for reads.",
        "source": """package Local_Observer

   type config is record
      rate : Natural;

   type config_ptr is access config;

   function read
      owner    : config_ptr = new ((rate = 100) as config);
      observer : access constant config = owner.Access;
      rate     : Natural;

      rate = observer.all.rate;
""",
    },
)


def technical_cases() -> list[dict[str, Any]]:
    return [dict(item) for item in PR117_TECHNICAL_CASES]


def technical_paths() -> list[str]:
    return [str(item["source"].relative_to(REPO_ROOT)) for item in PR117_TECHNICAL_CASES]


def negative_cases() -> list[dict[str, Any]]:
    return [dict(item) for item in PR117_NEGATIVE_CASES]


def negative_paths() -> list[str]:
    return [str(item["source"].relative_to(REPO_ROOT)) for item in PR117_NEGATIVE_CASES]


def migration_examples() -> list[dict[str, Any]]:
    return [dict(item) for item in PR117_MIGRATION_EXAMPLES]


def readability_examples() -> list[dict[str, Any]]:
    return [dict(item) for item in PR117_READABILITY_EXAMPLES]
