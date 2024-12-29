#!/bin/bash

# 仮想ディスプレイサーバを起動
Xvfb :99 -screen 0 1024x768x16 &

# 0 A.D. を起動
/usr/games/0ad
