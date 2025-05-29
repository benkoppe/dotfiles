#!/bin/bash

# small power menu using rofi, i3, systemd and pm-utils
# (last 3 dependencies are adjustable below)
# obtained from https://github.com/tostiheld/dotfiles/blob/master/bin/power-menu.sh

poweroff_command="systemctl poweroff"
reboot_command="systemctl reboot"
logout_command="i3-msg exit"

# customize the rofi command here, because the essential options are added below
rofi_command="rofi -width 10 -hide-scrollbar -bg #586e75 -opacity 100 -padding 5"

options=$'poweroff\nreboot\nlogout\nhibernate\nsuspend'

eval \$"$(echo "$options" | $rofi_command -dmenu -p "")_command"
