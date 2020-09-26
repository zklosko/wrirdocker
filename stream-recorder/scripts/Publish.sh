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

  mv ${sFile} ${sFile%.publish}.tfr  # renames input file
  sFN=${sFile%.publish}  # removes .publish from filename variable
  echo Publishing $sFN
  for sExt in mp3 ogg; do
    if cp ${sFN}.${sExt} ${sDest} ; then  # copy mp3, ogg files to dest
      echo Copy good
    else
      touch ${sFN}.${sExt}.error  # create showname.error file on copy error
    fi
    
    # Archive the show directly to the Z drive for immediate access
    sShowYr=${sFN:0:4}
    mkdir "/Z/VOLUNTEERS/Zachary Klosko/ShowArchive/${sShowYr}/"
    if cp ${sFN}.mp3 "/Z/VOLUNTEERS/Zachary Klosko/ShowArchive/${sShowYr}/" ; then
      echo Archive good
    else
#       cp ${sFN}.mp3 sWorkDir/archive
#       echo Archive error
      touch ${sFN}.noarc
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
