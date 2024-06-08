# RHMD
# Realist Hyperland Minimal Desktop LTO & GPO version
# .zlogin file -> ~/.zlogin
# (c) 2024

[[ -f ~/.zshrc ]] && source ~/.zshrc
[[ -t 0 && $(tty) == /dev/tty1 && ! $DISPLAY ]] && exec dbus-run-session Hyprland > /dev/null 2>&1
