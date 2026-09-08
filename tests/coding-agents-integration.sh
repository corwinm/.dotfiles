#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

cat >"$tmp_dir/coding-agents-tmux" <<'EOF'
#!/usr/bin/env bash
[[ "${FAKE_CLI_FAIL:-0}" == 0 ]] || exit 1
printf '%s\n' "$FAKE_STATUS_JSON"
EOF
chmod +x "$tmp_dir/coding-agents-tmux"

cat >"$tmp_dir/sketchybar" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$@" >"$SKETCHYBAR_TEST_LOG"
EOF
chmod +x "$tmp_dir/sketchybar"

cat >"$tmp_dir/defaults" <<'EOF'
#!/usr/bin/env bash
exit 1
EOF
chmod +x "$tmp_dir/defaults"

SKETCHYBAR_TEST_LOG="$tmp_dir/sketchybar.log" \
  PATH="$tmp_dir:$PATH" \
  FAKE_STATUS_JSON='{"mode":"summary","total":2,"busy":0,"waiting":1,"running":0,"idle":1,"new":0,"unknown":0,"tone":"waiting","summary":"agents waiting"}' \
  CODING_AGENTS_TMUX_BIN="$tmp_dir/coding-agents-tmux" \
  SKETCHYBAR_BIN="$tmp_dir/sketchybar" \
  NAME=coding-agents \
  "$repo_root/sketchybar/.config/sketchybar/plugins/coding_agents.sh"

grep -Fxq -- '--set' "$tmp_dir/sketchybar.log"
grep -Fxq -- 'coding-agents' "$tmp_dir/sketchybar.log"
grep -Fxq -- 'label=agents waiting' "$tmp_dir/sketchybar.log"
grep -Fxq -- 'label.color=0xfffe640b' "$tmp_dir/sketchybar.log"
grep -Fxq -- 'background.border_color=0xfffe640b' "$tmp_dir/sketchybar.log"

SKETCHYBAR_TEST_LOG="$tmp_dir/sketchybar.log" \
  FAKE_CLI_FAIL=1 \
  CODING_AGENTS_TMUX_BIN="$tmp_dir/coding-agents-tmux" \
  SKETCHYBAR_BIN="$tmp_dir/sketchybar" \
  NAME=coding-agents \
  "$repo_root/sketchybar/.config/sketchybar/plugins/coding_agents.sh"
grep -Fxq -- 'drawing=off' "$tmp_dir/sketchybar.log"

grep -Fq -- '@coding-agents-tmux-notify-command' "$repo_root/tmux/.tmux.conf"
grep -Fq -- 'coding_agents_changed' "$repo_root/tmux/.tmux.conf"
grep -Fq -- 'cmd-alt-ctrl-shift-g' "$repo_root/aerospace/.config/aerospace/aerospace.toml"
grep -Fq -- 'focus-and-popup.sh' "$repo_root/aerospace/.config/aerospace/aerospace.toml"
grep -Fq -- '--waiting' "$repo_root/aerospace/.config/aerospace/aerospace.toml"
grep -Fq -- 'coding_agents_changed' "$repo_root/sketchybar/.config/sketchybar/sketchybarrc"
