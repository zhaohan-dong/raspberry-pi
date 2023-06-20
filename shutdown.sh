#!/bin/bash

if [ $(who | wc -l) != 1 ]; then
	exit;
else poweroff;
fi;