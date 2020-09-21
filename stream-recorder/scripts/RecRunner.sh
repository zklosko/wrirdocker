#!/bin/bash

# Removed -x from all execution lines
#Pull schedule on script start
bash ./getsched17.sh  #removed & from command

while true
do
  date -R
  #echo pre whatson $(date)
  bash ./whatson4.sh &  # sending to background
  #echo post whatson $(date)
  bash ./posted.sh &
  bash ./getInfo2.sh &
  sleep 5
  #At 10 minutes to, get the new schedule. xx:50
  sMinuteHand=$(date +%M)
  if [[ ${sMinuteHand} -eq 50 ]]  # was if [[ 10${sMinuteHand} -eq 50 ]]
  then
    bash ./getsched17.sh &
  fi
  bash ./Publish.sh &
  bash ./Cleaner.sh &
  echo Cycle completed $(date)

  #Recheck at top of minute xx:xx:00
  sSecondHand=$(date "+%S")
  sleep $(( 60 - ${sSecondHand} ))  # was sleep $(( 60 - 10#${sSecondHand} ))
done
