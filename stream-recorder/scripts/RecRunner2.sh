#!/bin/bash

#Create folders
mkdir raw
mkdir mp3

#Pull schedule on script start
bash -x ./getsched17.sh  

#Immediately start recorder
date -R
bash -x ./whatson4.sh &

#Falls into routine afterwards
while true
do
  #Get current minute of hour
  sMinuteHand=$(date +%M)
  if [[ ${sMinuteHand} -eq 0 ]]  #Top of hour? Start recorder.
  then
    echo whatson starting ${date}
    bash -x ./whatson4.sh &
  elif [[ ${sMinuteHand} -eq 15 ]]  #15 minutes past? Start cleanup for previous hours.
  then
    echo cleanup starting ${date}
    bash -x ./posted.sh &
    bash -x ./getInfo2.sh &
#    bash -x ./CopyToRAS.sh &
#    bash -x ./Cleaner.sh &
  elif [[ ${sMinuteHand} -eq 50 ]]  #10 minutes to? Check the schedule.
  then
    echo checking the schedule ${date}
    bash -x ./getsched17.sh &
  else
    sleep 60  # take a break for a minute, then check again
  fi
done
