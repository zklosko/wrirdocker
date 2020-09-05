#!/bin/bash

ps -ef | grep -v $$ | grep -q $0 && exit

sDest=192.168.200.14
#sDest=rostov
sMinFree=97

echo Start $0 $(date)

ls raw/*.publish |
while read sFile ; do
  echo Working on ${sFile}
  sSP=$(ssh demandbatch@${sDest} df .|tail -1)
  sPCF=$(echo $sSP|cut -f5 -d' ')
  if [[ ${sPCF%\%} -gt ${sMinFree} ]] ; then
    echo "no space at destination (less that ${sMinFree} percent)"
    exit
  fi

  mv ${sFile} ${sFile%.publish}.tfr
  sFN=${sFile%.publish}
  echo Publishing $sFN
  for sExt in mp3 ogg; do
    if scp ${sFN}.${sExt} demandbatch@${sDest}:. ; then
      echo Copy good
    else
      touch ${sFN}.${sExt}.error
    fi
  done
  [[ -s ${sFN}.info ]] && scp ${sFN}.info demandbatch@${sDest}:.
  [[ -s ${sFN}.audio.txt ]] && scp ${sFN}.audio.txt demandbatch@${sDest}:.
  if scp ${sFN}.tfr demandbatch@${sDest}:./${sFN##*/}.ready ; then
    mv ${sFN}.tfr ${sFN}.done
  fi
done

#sShowFile="shows.txt.togo"
#if [[ -f ${sShowFile} ]] ; then
#  if scp -i ~/demandbatch-at-ras ${sShowFile} demandbatch@${sDest}:./${sShowFile%.togo} ;then
#    $? rm ${sShowFile}
#  fi
#fi

sSched=$(find showdata.txt -newer showdata.txt.copied)
if [[ -n ${sSched} ]] ; then
  if scp showdata.txt demandbatch@${sDest}:. ; then
    touch -r showdata.txt showdata.txt.copied
  fi
fi

 
echo End $0 $(date)
