#!/usr/bin/env bash
# Installs 20 finance, accounting, HR and operations skills for Claude Code.
# Each skill is downloaded from its original GitHub repo at a pinned, reviewed commit.
# Nothing from those repos is executed. Existing skill folders are never overwritten.
#
# Usage:  bash install.sh
# Target: ~/.claude/skills (override with SKILLS_DIR=/some/path bash install.sh)
set -euo pipefail

SKILLS_DIR="${SKILLS_DIR:-$HOME/.claude/skills}"
command -v git >/dev/null || { echo "git is required (on a Mac: xcode-select --install)"; exit 1; }
mkdir -p "$SKILLS_DIR"

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

installed=()
skipped=()

# fetch <repo> <commit> <folder>...  -> blobless sparse clone at the pinned commit
fetch() {
  local repo="$1" commit="$2"; shift 2
  local dir="$WORK/${repo//\//__}"
  echo "Downloading from $repo ..."
  git clone --quiet --filter=blob:none --no-checkout "https://github.com/$repo.git" "$dir"
  git -C "$dir" sparse-checkout set --no-cone "$@" >/dev/null
  git -C "$dir" -c advice.detachedHead=false checkout --quiet "$commit"
}

# add <repo> <folder-in-repo>  -> copy one skill folder into SKILLS_DIR
add() {
  local src="$WORK/${1//\//__}/$2" name="${2##*/}"
  [ -f "$src/SKILL.md" ] || { echo "ERROR: $2 not found in $1"; exit 1; }
  if [ -e "$SKILLS_DIR/$name" ]; then
    skipped+=("$name"); return
  fi
  cp -R "$src" "$SKILLS_DIR/$name"
  installed+=("$name")
}

just_installed() { local n; for n in "${installed[@]:-}"; do [ "$n" = "$1" ] && return 0; done; return 1; }

# 1. Anthropic small-business skills (Apache-2.0)
R=anthropics/knowledge-work-plugins
fetch $R 5e504ae11498f2b8daa30d86b7dab97b2ecd8092 /small-business/skills/ /small-business/shared/
SB="cash-flow-snapshot hiring-screener job-post-builder business-pulse inventory-planner report-builder"
for s in $SB; do add $R small-business/skills/$s; done
for s in $SB; do
  if just_installed "$s"; then
    mkdir -p "$SKILLS_DIR/$s/shared"
    cp "$WORK/${R//\//__}/small-business/shared/"*.md "$SKILLS_DIR/$s/shared/"
    find "$SKILLS_DIR/$s" -name '*.md' -exec perl -pi -e 's#\.\./\.\./shared/#shared/#g' {} +
  fi
done

# 2. alirezarezvani/claude-skills (MIT)
R=alirezarezvani/claude-skills
A_SKILLS="finance/skills/financial-analyst
finance/skills/saas-metrics-coach
finance/business-investment-advisor/skills/business-investment-advisor
c-level-advisor/skills/culture-architect
business-operations/skills/procurement-optimizer
c-level-advisor/executive-mentor/skills/hard-call
c-level-advisor/executive-mentor/skills/stress-test
c-level-advisor/executive-mentor/skills/postmortem
project-management/skills/meeting-analyzer"
HT=c-level-advisor/executive-mentor/skills/executive-mentor/references/hard_things.md
# shellcheck disable=SC2086
fetch $R ea7b5ab8da93bbba8880152d9ccb8c9979f12252 $(for p in $A_SKILLS; do printf '/%s/ ' "$p"; done) "/$HT"
for p in $A_SKILLS; do add $R "$p"; done
if just_installed hard-call; then
  mkdir -p "$SKILLS_DIR/hard-call/references"
  cp "$WORK/${R//\//__}/$HT" "$SKILLS_DIR/hard-call/references/"
  perl -pi -e 's#\.\./executive-mentor/references/hard_things\.md#references/hard_things.md#g' "$SKILLS_DIR/hard-call/SKILL.md"
fi

# 3. borghei/Claude-Skills
R=borghei/Claude-Skills
fetch $R 25bf86b89c6c1e63f433a5b65e8cfcb6cf0b7ad3 /finance/launch-economics/ /project-management/discovery/pre-mortem/ /project-management/execution/brainstorm-okrs/
for p in finance/launch-economics project-management/discovery/pre-mortem project-management/execution/brainstorm-okrs; do add $R "$p"; done

# 4. ComposioHQ/awesome-claude-skills
R=ComposioHQ/awesome-claude-skills
fetch $R be2a406907dbc61b73e6827ded415c96139d13a2 /invoice-organizer/
add $R invoice-organizer

# 5. sickn33/agentic-awesome-skills (MIT)
R=sickn33/agentic-awesome-skills
P=plugins/agentic-awesome-skills-claude/skills/petty-cash-management
fetch $R a99b3d3bb6db184e75020f26714bce1951629356 "/$P/"
add $R $P

# Safety check: the bundled helper scripts should make no network or shell calls.
flagged=""
for n in "${installed[@]:-}"; do
  [ -n "$n" ] || continue
  hits="$(grep -rnE --include='*.py' --include='*.sh' --include='*.js' \
    'import (requests|urllib|socket|http)|from (requests|urllib|socket|http)|subprocess|os\.system|os\.popen|\beval\(|\bexec\(|\bcurl |\bwget ' \
    "$SKILLS_DIR/$n" 2>/dev/null || true)"
  [ -z "$hits" ] || flagged="$flagged$hits"$'\n'
done

echo
echo "Installed (${#installed[@]}): ${installed[*]:-none}"
echo "Skipped, already there (${#skipped[@]}): ${skipped[*]:-none}"
if [ -n "$flagged" ]; then
  echo "SAFETY CHECK: review these lines before using the skills:"
  printf '%s' "$flagged"
else
  echo "Safety check: no network or shell calls in the skills' scripts."
fi
echo "Skills folder: $SKILLS_DIR"
echo "Restart Claude Code (or open a new session) to load the new skills."
