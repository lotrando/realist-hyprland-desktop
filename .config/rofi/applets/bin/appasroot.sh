#!/usr/bin/env bash

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
#
## Applets : Run Applications as Root

# Import Current Theme
source "$HOME"/.config/rofi/applets/shared/theme.bash
theme="$type/$style"

list_col='1'
list_row='5'
win_width='120px'


# Options
layout=`cat ${theme} | grep 'USE_ICON' | cut -d'=' -f2`
if [[ "$layout" == 'NO' ]]; then
	option_1=" urxvt"
	option_2=" pcmanfm"
	option_3=" subl"
	option_4=" mc"
	option_5=" nano"
else
	option_1=""
	option_2=""
	option_3=""
	option_4=""
	option_5=""
fi

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "window {width: $win_width;}" \
		-theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-theme-str 'textbox-prompt-colon {str: "";}' \
		-dmenu \
		-p "$prompt" \
		-mesg "$mesg" \
		-markup-rows \
		-theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
}

# Execute Command
run_cmd() {
	polkit_cmd="pkexec env PATH=$PATH DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY"
	if [[ "$1" == '--opt1' ]]; then
		${polkit_cmd} urxvt
	elif [[ "$1" == '--opt2' ]]; then
		${polkit_cmd} dbus-run-session pcmanfm
	elif [[ "$1" == '--opt3' ]]; then
		${polkit_cmd} subl
	elif [[ "$1" == '--opt4' ]]; then
		${polkit_cmd} urxvt -e mc
	elif [[ "$1" == '--opt5' ]]; then
		${polkit_cmd} urxvt -e nano
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $option_1)
		run_cmd --opt1
        ;;
    $option_2)
		run_cmd --opt2
        ;;
    $option_3)
		run_cmd --opt3
        ;;
    $option_4)
		run_cmd --opt4
        ;;
    $option_5)
		run_cmd --opt5
        ;;
esac

