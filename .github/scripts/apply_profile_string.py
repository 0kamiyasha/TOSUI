#!/usr/bin/env python3
"""Apply a GitHub Issue form submission to TOSUI_Data profile Lua files."""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
DATA = ROOT / "TOSUI_Data"

RESOLUTION_SUFFIX = {
    "1440p": "",
    "1080p": "1080p",
    "4K": "4k",
    "Ultrawide": "uw",
}

ELLESMERE_ROLE_SUFFIX = {
    "Default": "",
    "DPS": "dps",
    "Healer": "healer",
    "Tank": "tank",
}

# Non-Ellesmere profiles that use resolution keys.
RESOLUTION_PROFILES = {
    "BigWigs": ("AddOns/BigWigs.lua", "bigwigs", "table_two"),
    "Edit Mode": ("AddOns/Blizzard_EditMode.lua", "blizzardeditmode", "string"),
    "MRT": ("AddOns/MRT.lua", "mrt", "string"),
}

CLASS_FILES = {
    "DeathKnight": "DeathKnight.lua",
    "DemonHunter": "DemonHunter.lua",
    "Druid": "Druid.lua",
    "Evoker": "Evoker.lua",
    "Hunter": "Hunter.lua",
    "Mage": "Mage.lua",
    "Monk": "Monk.lua",
    "Paladin": "Paladin.lua",
    "Priest": "Priest.lua",
    "Rogue": "Rogue.lua",
    "Shaman": "Shaman.lua",
    "Warlock": "Warlock.lua",
    "Warrior": "Warrior.lua",
}


def normalize_form_value(value: str) -> str:
    """Strip issue-form fences and GitHub's empty-optional placeholder."""
    value = value.strip()
    if value.startswith("```") and value.endswith("```"):
        lines = value.splitlines()
        if len(lines) >= 2:
            value = "\n".join(lines[1:-1]).strip()
    if value.lower() in {"_no response_", "no response"}:
        return ""
    return value


def parse_issue_body(body: str) -> dict[str, str]:
    """Parse GitHub issue-form markdown into a field dict."""
    fields: dict[str, str] = {}
    current: str | None = None
    chunks: list[str] = []

    def flush() -> None:
        nonlocal current, chunks
        if current is None:
            return
        fields[current] = normalize_form_value("\n".join(chunks))
        current = None
        chunks = []

    for line in body.splitlines():
        if line.startswith("### "):
            flush()
            current = line[4:].strip()
            chunks = []
            continue
        if current is not None:
            chunks.append(line)
    flush()
    return fields


def lua_quote(value: str) -> str:
    return json.dumps(value, ensure_ascii=False)


def extract_existing_scale(block: str) -> str | None:
    match = re.search(r"\n\s*([0-9]+(?:\.[0-9]+)?)\s*\n\}", block)
    return match.group(1) if match else None


def extract_table_strings(block: str) -> list[str]:
    return re.findall(r'"((?:\\.|[^"\\])*)"', block, flags=re.S)


def upsert_assignment(content: str, key: str, replacement: str) -> str:
    pattern = re.compile(
        r"(D\." + re.escape(key) + r"\s*=\s*)(\{.*?\}|\"(?:\\.|[^\"\\])*\"\s*)",
        flags=re.S,
    )
    new_content, count = pattern.subn(r"\g<1>" + replacement, content, count=1)
    if count == 1:
        return new_content
    if count > 1:
        raise RuntimeError(f"Found multiple assignments for D.{key}")

    # First-time variant: append a new key at end of file.
    trimmed = content.rstrip()
    if trimmed and not trimmed.endswith("\n"):
        trimmed += "\n"
    return trimmed + f"\nD.{key} = {replacement}"


def ellesmere_key(role: str, resolution: str) -> str:
    if role not in ELLESMERE_ROLE_SUFFIX:
        raise RuntimeError(f"EllesmereUI requires a role (got {role!r}).")
    if resolution not in RESOLUTION_SUFFIX:
        raise RuntimeError(f"EllesmereUI requires a resolution (got {resolution!r}).")
    return "ellesmereui" + ELLESMERE_ROLE_SUFFIX[role] + RESOLUTION_SUFFIX[resolution]


def resolve_target(fields: dict[str, str]) -> tuple[Path, str, str]:
    profile = fields.get("Profile", "").strip()
    role = fields.get("Ellesmere role", "N/A").strip()
    resolution = fields.get("Resolution", "").strip()
    class_name = fields.get("Class", "N/A").strip()

    if profile == "Class Layout":
        if class_name in ("", "N/A"):
            raise RuntimeError("Class Layout submissions require a Class selection.")
        if class_name not in CLASS_FILES:
            raise RuntimeError(f"Unsupported class: {class_name}")
        return DATA / "Classes" / CLASS_FILES[class_name], class_name.lower(), "string"

    if profile == "EllesmereUI":
        if role in ("", "N/A"):
            raise RuntimeError("EllesmereUI submissions require an Ellesmere role.")
        key = ellesmere_key(role, resolution)
        return DATA / "AddOns" / "EllesmereUI.lua", key, "table_scale"

    if profile not in RESOLUTION_PROFILES:
        raise RuntimeError(f"Unsupported profile: {profile}")
    if resolution not in RESOLUTION_SUFFIX:
        raise RuntimeError(f"Profile {profile} requires a resolution (got {resolution!r}).")

    rel, base_key, kind = RESOLUTION_PROFILES[profile]
    key = base_key + RESOLUTION_SUFFIX[resolution]
    return DATA / rel, key, kind


def build_replacement(kind: str, key: str, old_content: str, fields: dict[str, str]) -> str:
    primary = fields.get("Primary import string", "").strip()
    if not primary:
        raise RuntimeError("Primary import string is empty.")

    secondary = fields.get("Secondary string (BigWigs boss options)", "").strip()
    scale_field = fields.get("EllesmereUI UI scale (optional)", "").strip()

    if kind == "string":
        return f"{lua_quote(primary)}\n"

    match = re.search(
        rf"D\.{re.escape(key)}\s*=\s*(\{{.*?\}})",
        old_content,
        flags=re.S,
    )
    old_block = match.group(1) if match else ""

    if kind == "table_scale":
        scale = scale_field or extract_existing_scale(old_block) or "0.5333333333"
        try:
            float(scale)
        except ValueError as exc:
            raise RuntimeError(f"Invalid scale value: {scale}") from exc
        return "{\n    %s,\n    %s\n}\n" % (lua_quote(primary), scale)

    if kind == "table_two":
        existing = extract_table_strings(old_block)
        second = secondary or (existing[1] if len(existing) > 1 else "")
        if not second:
            raise RuntimeError(
                "BigWigs updates need a secondary boss-options string "
                "(or an existing secondary value in the file)."
            )
        return "{\n    %s,\n    %s\n}\n" % (lua_quote(primary), lua_quote(second))

    raise RuntimeError(f"Unknown assignment kind: {kind}")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--body-file", required=True)
    parser.add_argument("--summary-file", required=True)
    args = parser.parse_args()

    body = Path(args.body_file).read_text(encoding="utf-8")
    fields = parse_issue_body(body)
    path, key, kind = resolve_target(fields)

    if not path.is_file():
        raise RuntimeError(f"Target file does not exist: {path}")

    old = path.read_text(encoding="utf-8")
    replacement = build_replacement(kind, key, old, fields)
    new = upsert_assignment(old, key, replacement)
    path.write_text(new, encoding="utf-8", newline="\n")

    summary = {
        "profile": fields.get("Profile", ""),
        "role": fields.get("Ellesmere role", ""),
        "resolution": fields.get("Resolution", ""),
        "class": fields.get("Class", ""),
        "file": str(path.relative_to(ROOT)).replace("\\", "/"),
        "key": key,
        "notes": fields.get("Notes", ""),
    }
    Path(args.summary_file).write_text(json.dumps(summary, indent=2), encoding="utf-8")
    print(json.dumps(summary))
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as exc:  # noqa: BLE001
        print(f"ERROR: {exc}", file=sys.stderr)
        raise SystemExit(1)
