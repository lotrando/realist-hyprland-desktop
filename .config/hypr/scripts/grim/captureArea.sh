#!/bin/bash
grim -g "$(slurp)" $HOME/Pictures/$(date +'%s_grim.png')
mpv $HOME/.config/hypr/sounds/camera-shutter.ogg