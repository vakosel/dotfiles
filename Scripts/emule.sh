#!/bin/bash
export WINEPREFIX="$HOME/.wine32"
export WINEDEBUG=-all
exec wine "$HOME/Downloads/Linux/emule.exe"
