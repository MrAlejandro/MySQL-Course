#!/bin/sh

USER=$1
read -s -p "Password:" PASS
echo "\n"
INTERVAL=5
PREFIX=$INTERVAL-sec-status
RUNFILE=~/benchmark/running
mysql -u$USER -p$PASS -e 'SHOW GLOBAL VARIABLES' >> mysql-variables
while test -e $RUNFILE; do
    file=$(date +%F_%I)
    sleep=$(date +%s.%N | awk "{print $INTERVAL - (\$1 % $INTERVAL)}")
    sleep $sleep
    ts="$(date +"TS %s.%N %F %T")"
    loadavg="$(uptime)"
    echo "$ts $loadavg" >> $PREFIX-${file}-status
    mysql -u$USER -p$PASS -e 'SHOW GLOBAL STATUS' >> $PREFIX-${file}-status &
    echo "$ts $loadavg" >> $PREFIX-${file}-innodbstatus
    mysql -u$USER -p$PASS -e 'SHOW ENGINE INNODB STATUS\G' >> $PREFIX-${file}-innodbstatus &
    echo "$ts $loadavg" >> $PREFIX-${file}-processlist
    mysql -u$USER -p$PASS -e 'SHOW FULL PROCESSLIST' >> $PREFIX-${file}-processlist &
    echo $ts
done
echo Exiting because the $RUNFILE does not exist.
