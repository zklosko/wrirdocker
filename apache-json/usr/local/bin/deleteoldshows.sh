#!/bin/bash

sDir="/var/www/web1/storage/ShowArchive"

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
