#!/usr/bin/env bash
set -euo pipefail

app="$HOME/Applications/Neovim (Terminal).app"
repo_root=$(cd "$(dirname "$0")/.." && pwd)
source_file=$(mktemp -t neovim-opener.XXXXXX.applescript)
trap 'rm -f "$source_file"' EXIT

mkdir -p "$HOME/Applications"
cat >"$source_file" <<'APPLESCRIPT'
on open selectedFiles
  set launcher to POSIX path of (path to me) & "Contents/Resources/open-in-neovim"
  set command to quoted form of launcher
  repeat with selectedFile in selectedFiles
    set command to command & " " & quoted form of POSIX path of selectedFile
  end repeat
  do shell script command & " >/tmp/open-in-neovim.log 2>&1 &"
end open
APPLESCRIPT

rm -rf "$app"
osacompile -o "$app" "$source_file"
cp "$repo_root/scripts/open-in-neovim.sh" "$app/Contents/Resources/open-in-neovim"
chmod +x "$app/Contents/Resources/open-in-neovim"

plutil -replace CFBundleIdentifier -string local.corwin.neovim-terminal "$app/Contents/Info.plist"
plutil -replace CFBundleName -string "Neovim (Terminal)" "$app/Contents/Info.plist"
plutil -replace CFBundleDocumentTypes -json '[{"CFBundleTypeName":"Files","CFBundleTypeRole":"Editor","LSHandlerRank":"Alternate","LSItemContentTypes":["public.data"]}]' "$app/Contents/Info.plist"

codesign --force --deep --sign - "$app" >/dev/null
lsregister="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"
"$lsregister" -f "$app"

echo "Installed $app"
echo "Use Finder → Get Info → Open with → Neovim (Terminal) → Change All."
