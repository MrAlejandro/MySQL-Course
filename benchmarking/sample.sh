#!/bin/sh

USER=$1
echo $USER
read -s -p "Password:" PASS
echo "\n"
INTERVAL=5
PREFIX=$INTERVAL-sec-status
RUNFILE=~/benchmark/running
mysql -u$USER -p$PASS -e 'SHOW GLOBAL VARIABLES'
