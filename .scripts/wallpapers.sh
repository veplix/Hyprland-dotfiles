
#!/usr/bin/env bash
set -euo pipefail

WALL_DIR="$HOME/.wallpapers"
HYPRPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf"
HYPRLOCK_CONF="$HOME/.config/hypr/hyprlock.conf"
SDDM_THEME_DIR="/usr/share/sddm/themes/blueleaf/"
SDDM_THEME_CONF="/usr/share/sddm/themes/blueleaf/theme.conf"

ROFI_BIN="$(command -v rofi || true)"
CHAFa_BIN="$(command -v chafa || true)"
CONVERT_BIN="$(command -v convert || true)"
NOTIFY="$(command -v notify-send || true)"
MKDIR="$(command -v mkdir)"

if [ ! -d "$WALL_DIR" ]; then
  exit 1
fi

mapfile -t IMAGES < <(find "$WALL_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | sort)
if [ ${#IMAGES[@]} -eq 0 ]; then
  exit 0
fi

THUMB_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/rofi-wallthumbs"
$MKDIR -p "$THUMB_DIR"

generate_thumb() {
  local src="$1"
  local dst="$THUMB_DIR/$(sha1sum <<< "$src" | awk '{print $1}').png"
  if [ ! -f "$dst" ]; then
    "$CONVERT_BIN" "$src" -auto-orient -resize 400x250^ -gravity center -extent 400x250 "$dst" 2>/dev/null || cp "$src" "$dst"
  fi
  echo "$dst"
}

INPUT=""
for img in "${IMAGES[@]}"; do
  name="$(basename "$img")"
  thumb="$(generate_thumb "$img")"
  INPUT+="$name\0icon\x1f$thumb\n"
done

ROFI_OPTS=( -dmenu -i -p "Select wallpaper" -theme-str 'window {width: 25%;}' --no-custom )

ROFI_OPTS+=(--show-icons)

SELECTED_NAME=$(printf "%b" "$INPUT" | "$ROFI_BIN" "${ROFI_OPTS[@]}")

if [ -z "$SELECTED_NAME" ]; then
  exit 0
fi

SELECTED_PATH=""
for img in "${IMAGES[@]}"; do
  if [ "$(basename "$img")" = "$SELECTED_NAME" ]; then
    SELECTED_PATH="$img"
    break
  fi
done

if [ -z "$SELECTED_PATH" ]; then
  exit 1
fi

if [ -n "$CHAFa_BIN" ]; then
  chafa "$(generate_thumb "$SELECTED_PATH")" --format symbols --symbols vhalf --size 80x40 --color-space full --dither ordered || true
fi

ext="${SELECTED_PATH##*.}"
DEST_SDDM="$SDDM_THEME_DIR/background.$ext"

if [ -d "$SDDM_THEME_DIR" ]; then
  sudo cp "$SELECTED_PATH" "$DEST_SDDM"
  if [ -n "$SDDM_THEME_CONF" ] && [ -f "$SDDM_THEME_CONF" ]; then
    sudo sed -E -i "s|Background[[:space:]]*=[[:space:]]*\"?[^\"]+\"?|Background=\"background.$ext\"|g" "$SDDM_THEME_CONF" || true
  fi
else
  $NOTIFY "SDDM theme is not found" "$SDDM_THEME_DIR"
fi

if [ -f "$HYPRPAPER_CONF" ]; then
  escpath=$(printf '%s\n' "$SELECTED_PATH" | sed 's:[][\/.^$*]:\\&:g')
  sed -i -E "s|^preload = .*|preload = $escpath|" "$HYPRPAPER_CONF" || true
  sed -i -E "s|^wallpaper =.*,.*|wallpaper = , $escpath|" "$HYPRPAPER_CONF" || true
  pkill hyprpaper 2>/dev/null || true
  hyprpaper & disown || true
else
  $NOTIFY "Hyprpaper conf not found" "$HYPRPAPER_CONF"
fi

if [ -f "$HYPRLOCK_CONF" ]; then
  escpath=$(printf '%s\n' "$SELECTED_PATH" | sed 's:[][\/.^$*]:\\&:g')
  sed -i -E "s|path = .*|path = $escpath|" "$HYPRLOCK_CONF" || true
else
  $NOTIFY "Hyprlock conf not found" "$HYPRLOCK_CONF"
fi


exit 0
