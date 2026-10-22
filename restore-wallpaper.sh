#!/usr/bin/env bash
set -euo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
video=Pictures/Wallpapers/Live/eerie-moon-outlast-2-moewalls-com.mp4
cat -- "$video".part[0-9][0-9] > "$video"
printf '%s  %s\n' 'f2c729cddd5bb9dda51f6d3f5adc36354682e7083a7b90d5032dee5a7d20486b' "$video" | sha256sum --check --status
