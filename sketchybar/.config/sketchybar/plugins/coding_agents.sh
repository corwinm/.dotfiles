#!/usr/bin/env bash

set -euo pipefail

# SketchyBar may start without a locale. Match the upstream integration so tmux
# preserves the CLI's tab-delimited machine output.
export LANG="${LANG:-en_US.UTF-8}"
export LC_CTYPE="${LC_CTYPE:-en_US.UTF-8}"

CLI="${CODING_AGENTS_TMUX_BIN:-$HOME/.tmux/plugins/coding-agents-tmux/bin/coding-agents-tmux}"
SKETCHYBAR="${SKETCHYBAR_BIN:-sketchybar}"
ITEM_NAME="${NAME:-coding-agents}"
PROVIDER="${CODING_AGENTS_TMUX_PROVIDER:-plugin}"
NODE="${CODING_AGENTS_TMUX_NODE_BIN:-}"
TMUX_BIN="${CODING_AGENTS_TMUX_TMUX_BIN:-}"

if [[ -z "$NODE" ]]; then
  for candidate in \
    /opt/homebrew/bin/node \
    /usr/local/bin/node \
    "$HOME/.vite-plus/bin/node" \
    "$HOME"/.nvm/versions/node/*/bin/node; do
    if [[ -x "$candidate" ]]; then
      NODE="$candidate"
      break
    fi
  done
fi

if [[ -z "$NODE" ]]; then
  "$SKETCHYBAR" --set "$ITEM_NAME" drawing=off
  exit 0
fi

# The coding-agents-tmux launcher resolves Node through PATH. Homebrew services
# do not inherit an interactive shell's nvm PATH, so make the selected runtime
# available to both the launcher and the JSON parser.
PATH="$(dirname "$NODE"):$PATH"

if [[ -z "$TMUX_BIN" ]]; then
  for candidate in \
    "$(command -v tmux 2>/dev/null || true)" \
    /opt/homebrew/bin/tmux \
    /usr/local/bin/tmux; do
    if [[ -n "$candidate" && -x "$candidate" ]]; then
      TMUX_BIN="$candidate"
      PATH="$(dirname "$TMUX_BIN"):$PATH"
      break
    fi
  done
fi
export PATH

if ! status_json="$("$CLI" status --summary --json --provider "$PROVIDER" 2>/dev/null)"; then
  "$SKETCHYBAR" --set "$ITEM_NAME" drawing=off
  exit 0
fi

# Find the pane selected by the most recently active attached client. The
# summary remains in stable target order; only that pane's glyph becomes its
# circled one-based index.
current_target=""
panes_json="$("$CLI" list --json --provider "$PROVIDER" 2>/dev/null || printf '[]')"
if [[ -n "$TMUX_BIN" ]]; then
  client_format='#{client_activity}	#{session_name}:#{window_index}.#{pane_index}'
  client_line="$("$TMUX_BIN" list-clients -F "$client_format" 2>/dev/null | sort -rn | head -n 1 || true)"
  if [[ "$client_line" == *$'\t'* ]]; then
    current_target="${client_line#*$'\t'}"
  fi
fi

if ! parsed="$({ STATUS_JSON="$status_json" PANES_JSON="$panes_json" CURRENT_TARGET="$current_target" "$NODE" -e '
const status = JSON.parse(process.env.STATUS_JSON ?? "{}");
if (typeof status.tone !== "string" || typeof status.summary !== "string" || status.summary.length === 0) {
  process.exit(2);
}

let summary = status.summary;
let panes = [];
try {
  panes = JSON.parse(process.env.PANES_JSON ?? "[]");
} catch {}

const currentIndex = Array.isArray(panes)
  ? panes.findIndex((entry) => entry?.pane?.target === process.env.CURRENT_TARGET)
  : -1;
const separatorIndex = summary.indexOf(" | ");
if (currentIndex >= 0 && currentIndex < 9 && separatorIndex >= 0) {
  const prefix = summary.slice(0, separatorIndex);
  const symbols = Array.from(summary.slice(separatorIndex + 3).replace(/\s+/g, ""));
  if (symbols.length === panes.length) {
    const circledIndexes = ["󰲠", "󰲢", "󰲤", "󰲦", "󰲨", "󰲪", "󰲬", "󰲮", "󰲰"];
    symbols[currentIndex] = circledIndexes[currentIndex];
    summary = prefix + " | " + symbols.join(panes.length > 8 ? "" : " ");
  }
}

process.stdout.write(status.tone + "\t" + summary);
'; })"; then
  "$SKETCHYBAR" --set "$ITEM_NAME" drawing=off
  exit 0
fi
tone="${parsed%%$'\t'*}"
summary="${parsed#*$'\t'}"

# Split the summary prefix into SketchyBar's icon slot so the robot and status
# glyphs can be centered and padded independently instead of sharing one label.
icon_drawing=off
icon=""
label="$summary"
label_padding_left=10
if [[ "$summary" == *" | "* ]]; then
  icon_drawing=on
  icon="${summary%% | *}"
  label="${summary#* | }"
  label_padding_left=0
fi

if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q '^Dark$'; then
  BLUE=0xff1e6e77
  ORANGE=0xffcc7b6e
  GREEN=0xff638989
  PINK=0xffd7448a
  CREAM=0xffd3cdc5
else
  BLUE=0xff1e66f5
  ORANGE=0xfffe640b
  GREEN=0xff40a02b
  PINK=0xffea76cb
  CREAM=0xff5c5f77
fi

case "$tone" in
waiting) color="$ORANGE" ;;
busy) color="$BLUE" ;;
idle) color="$GREEN" ;;
*) color="$CREAM" ;;
esac

"$SKETCHYBAR" --set "$ITEM_NAME" \
  drawing=on \
  icon.drawing="$icon_drawing" \
  icon="$icon" \
  label="$label" \
  label.padding_left="$label_padding_left" \
  label.color="$color" \
  background.border_color="$color" \
  popup.background.border_color="$color"

popup_args=()
for index in {1..9}; do
  popup_args+=(--set "coding-agent.$index" drawing=off)
done

while IFS=$'\t' read -r index glyph row_tone row_label focused; do
  [[ "$index" =~ ^[1-9]$ ]] || continue
  case "$row_tone" in
    waiting) row_color="$ORANGE" ;;
    busy) row_color="$BLUE" ;;
    idle) row_color="$GREEN" ;;
    *) row_color="$CREAM" ;;
  esac
  icon_color="$row_color"
  [[ "$focused" == "true" ]] && icon_color="$PINK"
  popup_args+=(
    --set "coding-agent.$index"
      drawing=on
      icon="$glyph"
      icon.color="$icon_color"
      label="$row_label"
      label.color="$row_color"
  )
done < <({ PANES_JSON="$panes_json" CURRENT_TARGET="$current_target" "$NODE" -e '
const path = require("node:path");
let panes = [];
try {
  panes = JSON.parse(process.env.PANES_JSON ?? "[]");
} catch {}
if (!Array.isArray(panes)) process.exit(0);

const glyphs = ["󰲠", "󰲢", "󰲤", "󰲦", "󰲨", "󰲪", "󰲬", "󰲮", "󰲰"];
const clean = (value) => String(value ?? "").replace(/[\t\r\n]+/g, " ").trim();
for (const [offset, entry] of panes.slice(0, 9).entries()) {
  const status = entry?.runtime?.status ?? "unknown";
  const activity = entry?.runtime?.activity ?? "unknown";
  const tone = status === "waiting-question" || status === "waiting-input"
    ? "waiting"
    : status === "running" || activity === "busy"
      ? "busy"
      : status === "idle" || activity === "idle"
        ? "idle"
        : "neutral";
  const statusLabel = status === "waiting-question" || status === "waiting-input"
    ? "waiting"
    : status === "running" ? "busy" : status;
  const agent = clean(entry?.detection?.agent || "agent");
  const project = clean(
    entry?.runtime?.session?.title ||
    path.basename(entry?.pane?.currentPath || "") ||
    entry?.pane?.sessionName ||
    entry?.pane?.target ||
    "unknown"
  );
  const focused = entry?.pane?.target === process.env.CURRENT_TARGET;
  const label = agent.charAt(0).toUpperCase() + agent.slice(1) + " · " + project + " · " + statusLabel + (focused ? " · focused" : "");
  process.stdout.write([offset + 1, glyphs[offset], tone, label, focused].join("\t") + "\n");
}
'; })

((${#popup_args[@]} > 0)) && "$SKETCHYBAR" "${popup_args[@]}"
