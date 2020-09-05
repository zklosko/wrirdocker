#!/bin/bash

#Pull schedule on script start
bash -x ./getsched17.sh  #removed & from command

while true
do
  date -R
  echo pre whatson $(date)
  bash -x ./whatson4.sh &  # sending to background
  echo post whatson $(date)
  bash -x ./posted.sh &
  bash -x ./getInfo2.sh &
  sleep 5
  #At 10 minutes to, get the new schedule. xx:50
  sMinuteHand=$(date +%M)
  if [[ ${sMinuteHand} -eq 50 ]]  # was if [[ 10${sMinuteHand} -eq 50 ]]
  then
    bash -x ./getsched17.sh &
  fi
#  bash -x ./CopyToRAS.sh &
#  bash ./Cleaner.sh &
#  bash ./wan-traffic.sh &

  sSecondHand=$(date "+%S")
  sleep $(( 60 - ${sSecondHand} ))  # was sleep $(( 60 - 10#${sSecondHand} ))
  # TODO: change to "sleep until top of hour" in seconds or minutes
done
