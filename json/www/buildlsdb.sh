#!/bin/bash

sDIR="/var/www/web1/storage/Y/DIGITAL MUSIC LIBRARY/LiveMusic/"
cd /tmp

sNewDB=$(date "+%Y%j").lsdb
sId=0
sPrevDB=$(ls -1tr /var/www/data/*.lsdb|tail -1)
[[ -f ${sNewDB} ]] && rm ${sNewDB}

if [[ "${1}" == "new" ]] || [[ -z "${sPrevDB}" ]]
then
  sPrevDB=/tmp/dummy.lsdb
  touch -d "1-Jan-1999" ${sPrevDB}
fi

touch $$.unchanged

while read sLine
do
  IFS=\| read sId sArt sNum sSong sSet sFol sFile sYeay sDate <<< "${sLine}"
  if [[ -n $(find "${sDIR}/${sFol}/${sFile}" -not -newer "${sPrevDB}") ]] 
  then
    echo "${sLine}" >> "${sNewDB}"
  else
    echo drop $sLine
    [[ -f $$.unchanged ]] && rm $$.unchanged
  fi
done < "${sPrevDB}"

#TCON (Content type): Experimental;Folk;World (255)

find "${sDIR}" -type f -name '*.mp3' -newer "${sPrevDB}"|
while read sF; do
  [[ -f $$.unchanged ]] && rm $$.unchanged
  sF1=${sF##$sDIR}
  sFile=${sF1##*/}
  sFold=${sF1%/*}
  sId=$((sId+1))
  sTags=$(id3v2 -l "${sF}" | tr '|' ':') 

  sArt=$(grep TPE1 <<< "${sTags}")
  sSong=$(grep TIT2 <<< "${sTags}")
  sNum=$(grep TRCK <<< "${sTags}") 
  sSet=$(grep TALB  <<< "${sTags}")
  sYear=$(grep TYER  <<< "${sTags}")
  sDDMM=$(grep TDAT  <<< "${sTags}")
  sGenre=$(grep TCON  <<< "${sTags}")
  sGenre="${sGenre% (*}"
  sFileDate=$(date -r "${sF}")
  echo add ${sArt#*: } ${sNum#*: } ${sSong#*: } ${sSet#*: } ${sGenre#*: }
  echo "${sId}|${sArt#*: }|${sNum#*: }|${sSong#*: }|${sSet#*: }|${sFold}|${sFile}|${sYear#*: }|${sDDMM#*: }|${sFileDate}|${sGenre#*: }|" >> "${sNewDB}"
done
sFP=$(wc -l<${sPrevDB})
sFD=$(find "${sDIR}" -name '*.mp3' |wc -l)
sFB=$(wc -l<${sNewDB})

echo "Files in directory:" $(find "${sDIR}" -name '*.mp3' |wc -l)
echo "Songs in database: $(wc -l<${sNewDB})"
if [[ -f $$.unchanged ]]
then
  rm $$.unchanged
  echo "no updates"
  rm ${sNewDB}
else
  mv ${sNewDB} /var/www/data/
fi

# vim: sw=2
