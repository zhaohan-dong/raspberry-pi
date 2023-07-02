#!/bin/bash

if [ $(who | wc -l) != 0 ]; then  # If there are users logged in, do not shutdown
	exit;
else /sbin/shutdown -P +5 "Sudoers, use 'sudo shutdown -c' to cancel.";
fi;