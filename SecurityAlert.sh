#!/bin/bash

# You should need to create a crontab entry for this script
# So this script runs every 10 minutes automatically.

# Checking for any authentication failure entry founded on
# /var/log/auth.log file and update twitter status.


#Checking twidge (command-line twitter client) is installed or not
dpkg --list | grep twidge &> /dev/null

if [ $? -ne 0 ]
then
	echo "Twidge (command-line twitter client) is not installed "
	echo "For how to install and configure twidge check the following links:"
	echo "http://www.howtogeek.com/62018/how-to-use-the-linux-terminal-to-update-twitter/"
else
	#Calculate 10 Minutes ago time in unix time format
	TENMINAGO=$(date +%s --date "10 minute ago")

	# Take the last authentication failure entry from auth.log
	SMS=$(cat /var/log/auth.log | grep 'authentication failure' | tail -n1 )

	# Extract the time from SMS variable and convert it to unix time format
	SMSTIME=$(date -d "$(echo $SMS | awk '{print $1,$2,$3}')" +%s)

	if [ $SMSTIME -gt $TENMINAGO ]; then
	echo "Updating Twitter Status..."
	echo $SMS | awk '{print $3,$5,$9,$10,$12,$14,$15,$16}' | twidge update
	fi
fi

