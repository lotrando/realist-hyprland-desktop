# RHMD
# Realist Hyperland Minimal Desktop LTO & GPO version
# .bashrc file -> ~/.bashrc
# (c) 2024

if shopt -q login_shell; then
    [[ -f ~/.bashrc ]] && source ~/.bashrc
    [[ -t 0 && $(tty) == /dev/tty1 && ! $DISPLAY ]] && exec dbus-run-session Hyprland > /dev/null 2>&1
else
    exit 1
fi
