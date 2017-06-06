#!/bin/bash

###
# vkucukcakar/cron
# cron Docker image for time-based job scheduling
# Copyright (c) 2017 Volkan Kucukcakar
# 
# This file is part of vkucukcakar/cron.
# 
# vkucukcakar/cron is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
# 
# vkucukcakar/cron is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# 
# This copyright notice and license must be retained in all files and derivative works.
###

# Give execute permission to scripts in given locations if auto configuration is enabled.
if [ "$AUTO_CONFIGURE" == "enable" ]; then
	echo "AUTO_CONFIGURE enabled, starting auto configuration."	
	# Check if the required environment variable is set and configure files. EXECUTABLES should contain space separated filenames to give execute permission.
	if [ ! -z "$EXECUTABLES" ] && [[ $EXECUTABLES =~ ^([[:alnum:]/\._-]+[[:blank:]]*)+$ ]]; then
		for _EXECUTABLE_FILE in $EXECUTABLES; do
			if [ -f ${_EXECUTABLE_FILE} ]; then
				echo "Giving execute permission to file ${_EXECUTABLE_FILE}"
				chmod +x ${_EXECUTABLE_FILE}
			else
				echo "Error: Cannot give execute permission to file ${_EXECUTABLE_FILE}, file not found"
				exit 1
			fi
		done
	else
		echo "Error: Environment variable EXECUTABLES is not correctly set. EXECUTABLES should contain space separated filenames to give execute permission."
		exit 1
	fi
	echo "AUTO_CONFIGURE completed."
else
	echo "AUTO_CONFIGURE disabled."
fi

# Workaround for crontab not running because of Docker hardlinking issue: touch /etc/crontabs/root file
echo 'Running hardlink workaround for "/etc/crontabs/root".'
touch /etc/crontabs/root

# Empty /etc/periodic/* directories notice
if [ ! "$(ls -A /etc/periodic/15min)" ] && [ ! "$(ls -A /etc/periodic/hourly)" ] && [ ! "$(ls -A /etc/periodic/daily)" ] && [ ! "$(ls -A /etc/periodic/weekly)" ] && [ ! "$(ls -A /etc/periodic/monthly)" ]; then
	echo 'Notice: No executable files found under "/etc/periodic/15min", "/etc/periodic/hourly", "/etc/periodic/daily", "/etc/periodic/weekly", "/etc/periodic/monthly". You can copy or mount executables to these locations.'
fi

# Custom crontab notice notice
echo 'Notice: You can copy or mount your custom crontab file to "/etc/crontabs/root" file.'

# Log redirection hint.
echo "Notice: Hint: Executable output can be redirected back to Docker logs by using '/var/log/cron.log' or '/proc/1/fd/1'"
echo "Notice: Hint: Error logs can be redirected back to Docker logs by mixing with stdout or by using '/var/log/cron-error.log' or '/proc/1/fd/2'"
echo "Notice: Hint: e.g.: echo 'Hello World' >>/var/log/cron.log 2>&1"

# Execute another entrypoint or CMD if there is one
if [[ "$@" ]]; then
	echo "Executing $@"
	$@
	EXITCODE=$?
	if [[ $EXITCODE > 0 ]]; then 
		exit $EXITCODE
	fi
fi
