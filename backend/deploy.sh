#!/bin/bash

cd ~/reg_skane/Region-Sk-ne-2

git pull origin main

sudo systemctl restart mysql

pm2 restart ServerApplet

