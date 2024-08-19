#!/bin/sh
echo -ne '\033c\033]0;Isg\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/isg-prototype.x86_64" "$@"
