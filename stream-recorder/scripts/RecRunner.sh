#!/bin/bash

#Pull schedule on script start, pass to publish directory for json container
bash ./getsched17.sh  #removed & from command
cp -f showdata.txt ./publish
bash -x ./lsdb2.sh &  # make live sound database at launch

while true
do
  date -R
  #echo pre whatson $(date)
  bash ./whatson4.sh &  # sending to background
  #echo post whatson $(date)
  bash ./posted.sh &
  bash ./getInfo2.sh &
  sleep 5
  
  #At 10 minutes to, get the new schedule, run cleanup. xx:50
  sMinuteHand=$(date +%M)
  if [[ ${sMinuteHand} -eq 50 ]]  # was if [[ 10${sMinuteHand} -eq 50 ]]
  then
    bash ./getsched17.sh &
    bash ./lsdb2.sh &
    cp -f showdata.txt ./publish  # updating showdata.txt file for files.wrir.org scripts
  fi
  
  bash ./Publish.sh &
  bash ./Cleaner.sh &
 
  #Recheck at top of minute xx:xx:00
  sSecondHand=$(date "+%S")
  sleep $(( 60 - ${sSecondHand} ))  # was sleep $(( 60 - 10#${sSecondHand} ))
done
