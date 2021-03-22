#!/bin/bash

# Cleaning files in raw
sDays=75
echo Starting $0 $(date)

sOldFiles=$(find ./raw/* -ctime +${sDays})  # refactered line
[[ -n "${sOldFiles}" ]] && rm ${sOldFiles}

# Cleaning files in publish a.k.a. /shows
sDir="./publish"  # link to json/htdocs/shows

echo "Starting $0 $(date)"

cd "${sDir}" || exit

sLimit="95"
while sPCFree=$(df . --output=pcent|tail -1) && [[ ${sPCFree%\%} -ge ${sLimit} ]]
do
  echo "Free space: ${sPCFree}"
  sDel=$(ls -tr ./ | head -1)
  echo "delete ${sDel}"
  rm "${sDel}"
done

echo Ending $0 $(date)
