#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
repo_root="$(cd -- "$script_dir/.." && pwd -P)"
skill_source="$repo_root/.agents/skills/research-to-repo"
codex_home="${CODEX_HOME:-$HOME/.codex}"
skill_target="$codex_home/skills/research-to-repo"
skill_parent="$(dirname -- "$skill_target")"

if [[ ! -d "$skill_source" ]]; then
  printf 'Skill source does not exist: %s\n' "$skill_source" >&2
  exit 1
fi

mkdir -p "$skill_parent"

if [[ -L "$skill_target" ]]; then
  if [[ -d "$skill_target" ]] && [[ "$(cd -- "$skill_target" && pwd -P)" == "$skill_source" ]]; then
    printf 'Skill link already points to: %s\n' "$skill_source"
    exit 0
  fi

  printf 'Replacing stale skill link: %s\n' "$skill_target"
  rm "$skill_target"
elif [[ -e "$skill_target" ]]; then
  printf 'Refusing to overwrite non-symlink: %s\n' "$skill_target" >&2
  exit 1
fi

ln -s "$skill_source" "$skill_target"
printf 'Installed skill link: %s -> %s\n' "$skill_target" "$skill_source"
