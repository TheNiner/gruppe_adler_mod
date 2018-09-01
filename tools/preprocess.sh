#!/bin/bash

DIRECTORY=`dirname $0`/..

while getopts 'd:' OPTION; do
  case "$OPTION" in
    d)
      DIRECTORY="$OPTARG"
      ;;
    m)
      MACRODIR="$OPTARG"
      ;;
    ?)
      echo "script usage: $(basename $0) [-d project_directory] -m [macro_target_dir]" >&2
      exit 1
      ;;
  esac
done


pushd "$DIRECTORY"

acedir="$MACRODIR/z/ace"
cbadir="$MACRODIR/x/cba"
a3dir="$MACRODIR/A3"

function downloadMacroLib {
    local TARGETDIR=$1
    local URL=$2

    if [[ -d ${TARGETDIR} ]]
    then
        echo "INFO it seems we already got $TARGETDIR, skipping…"
    else
        echo "INFO copying $URL => $TARGETDIR…"
        mkdir -p ${TARGETDIR}
        pushd /tmp
        wget "$URL" -o tmp_preprocess.tar.gz && tar -xf tmp_preprocess.tar.gz -C ${TARGETDIR}
        popd
    fi
}

function escapeSlashesForSed {
    echo $1 | sed 's/\//\\\//g'
}

downloadMacroLib ${cbadir} "http://gruppe-adler.de/api/travis/cba.tar.gz"
downloadMacroLib ${acedir} "http://gruppe-adler.de/api/travis/ace.tar.gz"
downloadMacroLib ${a3dir} "http://gruppe-adler.de/api/travis/a3.tar.gz"

INCLUDINGFILES=`grep -lire '^\s*#include '`

echo "INFO editing #include clauses: forward-slashes, relative cba/ace paths…"

for INCLUDEFILE in ${INCLUDINGFILES}; do
    sed -i '/#include/s/\\/\//g' "$INCLUDEFILE"
    sed -i '/#include/s/\/x\/cba/x\/'$(escapeSlashesForSed ${cbadir})'/' "$INCLUDEFILE"
    sed -i '/#include/s/\/z\/ace/z\/'$(escapeSlashesForSed ${acedir})'/' "$INCLUDEFILE"
    sed -i '/#include/s/\/A3/z\/'$(escapeSlashesForSed ${acedir})'/' "$INCLUDEFILE"
    sed -i '/#include/s/\/x\/grad\///' "$INCLUDEFILE"
done
echo "INFO removing illegal double-hash from macro files…"
for MACROFILE in `find . -iname '*.cpp' -or -iname '*.hpp' -or -iname '*.h' -or -iname '*.inc'`
do
    sed -i -e 's/##//g' "$MACROFILE"
done

exit 5

echo "INFO starting preprocessing of SQF files…"
for SQFFILE in `find . -iname '*.sqf'`
do
    cpp -iquote ./ "$SQFFILE" "${SQFFILE}.1" && mv "${SQFFILE}.1" "$SQFFILE"
done

popd
