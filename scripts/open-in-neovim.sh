#!/usr/bin/env bash
set -euo pipefail

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"
files=("$@")
((${#files[@]})) || exit 0

working_dir=$(dirname "${files[0]}")
command="$(printf '%q' "$(command -v nvim)") --"
for file in "${files[@]}"; do
  command+=" $(printf '%q' "$file")"
done

# Use a new window in the most recently active attached tmux session.
client=$(tmux list-clients -F '#{client_activity}|#{client_session}' 2>/dev/null | sort -rn | head -n 1 || true)
if [[ -n $client ]]; then
  session=${client#*|}
  tmux new-window -t "$session:" -c "$working_dir" -n "$(basename "${files[0]}")" "$command"
  open -a Ghostty
else
  # Without an attached tmux client, a fresh Ghostty window is less surprising.
  open -na Ghostty.app --args -e "$(command -v nvim)" -- "${files[@]}"
fi
