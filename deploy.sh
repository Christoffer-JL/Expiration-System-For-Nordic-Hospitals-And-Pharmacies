#!/bin/bash

# Navigate to your project directory
cd ~/reg_skane/Region-Sk-ne-2

# Pull the latest changes from the Git repository
git pull origin main

# Restart your server application
pm2 restart ServerApplet

