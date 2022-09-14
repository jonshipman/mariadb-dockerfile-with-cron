#!/bin/bash

if [ "$1" = 'mariadbd' ]; then
	printenv > /usr/environment
	eval "maybe-import.sh" &>/dev/null & disown
	eval "cron -f" &>/dev/null & disown
fi
