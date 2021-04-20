#!/bin/bash

# Cleaning files in raw
sDays=1  # files older than 24 hours
echo Starting $0 $(date)

find /scripts/raw/* -ctime ${sDays} -delete

# # Cleaning files in publish a.k.a. /shows
# sDir="./publish"

# echo "Starting $0 $(date)"

# cd "${sDir}" || exit

# # below may not work in a container
# sLimit="95"
# while sPCFree=$(df . --output=pcent|tail -1) && [[ ${sPCFree%\%} -ge ${sLimit} ]]
# do
#   echo "Free space: ${sPCFree}"
#   sDel=$(ls -tr ./ | head -1)
#   echo "delete ${sDel}"
#   rm "${sDel}"
# done

# echo Ending $0 $(date)
