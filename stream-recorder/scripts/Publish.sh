#!/bin/bash

#Begin CopyToRAS.sh
ps -ef | grep -v $$ | grep -q $0 && exit

sWorkDir=${PWD}
# make working folder if not present
[[ ! -d ${sWorkDir}/publish ]] && mkdir ${sWorkDir}/publish

sDest=./publish  # mount to /wrirdocker/json/htdocs/shows
sMinFree=97

echo Start $0 $(date)

ls raw/*.publish |
while read sFile ; do
  echo Working on ${sFile}

  mv ${sFile} ${sFile%.publish}.tfr  # creates showname.publish.tfr file
  sFN=${sFile%.publish}  # removes .publish from filename variable?
  echo Publishing $sFN
  for sExt in mp3 ogg; do
    if cp ${sFN}.${sExt} ${sDest} ; then  # copy mp3, ogg files to dest
      echo Copy good
    else
      touch ${sFN}.${sExt}.error  # create showname.error file on copy error
    fi
  done
  [[ -s ${sFN}.info ]] && cp ${sFN}.info ${sDest}
  [[ -s ${sFN}.audio.txt ]] && cp ${sFN}.audio.txt ${sDest}
  if cp ${sFN}.tfr ${sDest}/${sFN##*/}.ready ; then
    mv ${sFN}.tfr ${sFN}.done  # ???
  fi
done

# below condition appears to be failing
# sSched=$(find showdata.txt -newer showdata.txt.copied)
# if [[ -n ${sSched} ]] ; then
#   if cp showdata.txt ${sDest} ; then
#     touch -r showdata.txt showdata.txt.copied
#   fi
# fi
