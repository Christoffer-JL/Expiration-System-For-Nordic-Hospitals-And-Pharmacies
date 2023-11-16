#!/bin/bash

cd ~/reg_skane/Region-Sk-ne-2

git pull origin main

pm2 restart ServerApplet

