#!/bin/bash
PROCESS=`ps axo %mem,pid,euser,cmd | grep start.jar | sort -nr | head -n 1`
COMMAND=`echo $PROCESS|awk '{print "kill -9 "$2}'`


$COMMAND && notify-send "Killing: " "$PROCESS"
