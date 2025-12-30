#!/bin/bash

# resizing does not work with fvwm3 after screen created 
# 800x600 size screen 
Xephyr :99 -sw-cursor -retro -resizeable -screen 800x600 -ac +extension GLX &
echo 'setting DISPLAY to :99 '
echo 'to undo this use '
echo 'DISPLAY=":1"'


DISPLAY=":99"
# all other programs use 
xterm &
# lastly start a window manager
fvwm3 &






