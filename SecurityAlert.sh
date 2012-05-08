#!/bin/bash

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# Copyright (C) 2012 by +Mitesh Shah 
# Mr.Miteshah@gmail.com
# People who works on this script to make it easier and good
# +Chris Raess +Josh Sabboth and +Christopher Timm 
# People who want to use this script in their Mac OS X
# Read the +Israel Torres comments on this post
# https://plus.google.com/111560558537332305125/posts/S6mrHJeS5Wd


# Checking every hour for any Authentication Failure entry founded on
# /var/log/auth.log file and update twitter status

# You should need to create a crontab entry for this script
# So this script runs every hours automatically

#Checking twidge (command-line twitter client) is installed or not
dpkg --list | grep twidge &> /dev/null

if [ $? -ne 0 ]
then
echo "Twidge (command-line twitter client) is not installed "
echo "For how to install and configure twidge check the following links:"
echo "http://www.howtogeek.com/62018/how-to-use-the-linux-terminal-to-update-twitter/"
else
#Calculate 1 hour ago time in unix time format
HOURAGO=$(date +%s --date "1 hour ago")

# Take the last authentication failure entry from auth.log
SMS=$(cat /var/log/auth.log | grep 'authentication failure' | tail -n1 )

# Extract the time from SMS variable and convert it to unix time format
SMSTIME=$(date -d "$(echo $SMS | awk '{print $1,$2,$3}')" +%s)

if [ $SMSTIME -gt $HOURAGO ]; then
echo "Updating Twitter Status..."
echo $SMS | awk '{print $3,$5,$9,$10,$12,$14,$15,$16}' | twidge update
fi
fi

