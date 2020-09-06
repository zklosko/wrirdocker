#!/bin/bash

sDays=75
echo Starting $0 $(date)

sOldFiles=$(find /scripts/raw/* -ctime +${sDays})
[[ -n "${sOldFiles}" ]] && rm ${sOldFiles}

echo Ending $0 $(date)
