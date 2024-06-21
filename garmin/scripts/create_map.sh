#!/bin/bash

# Create a Garmin map for the specified region.
#
# Usage:
#
# ./create_map.sh REGIONURL MAPID
#
# REGIONURL must refer to a *.osm.pbf file on https://download.geofabrik.de/
# MAPID must be a unique 4-digit number, e.g., based on the telephone country code
#
# Examples:
#
# ./create_map.sh https://download.geofabrik.de/europe/alps-latest.osm.pbf 4100
# ./create_map.sh https://download.geofabrik.de/europe/germany-latest.osm.pbf 4900
# ./create_map.sh https://download.geofabrik.de/europe/united-kingdom.html 4400
#

REGIONURL=$1
MAPID=$2

if [ -z "${REGIONURL}" ]; then
   echo "REGIONURL not defined"
   exit 1
fi

if [ -z "${MAPID}" ]; then
   echo "MAPID not defined"
   exit 1
fi

re='^[0-9][0-9][0-9][0-9]$'
if ! [[ $MAPID =~ $re ]] ; then
   echo "MAPID must be a four-digit number"
   exit 1
fi

REGION=$(echo ${REGIONURL} | sed 's#.*/##g' | sed 's#\.osm\.pbf##g')

echo "########## Creating map for region ${REGION} ##########"

# Go to the OpenTopoMap/garmin folder
cd $(dirname "$0")/..

# Adjust the versions of these two tools to their latest relase,
# according to www.mkgmap.org.uk
MKGMAP="mkgmap-r4919"
SPLITTER="splitter-r654"

#
# Download mkgmap, splitter, bounds, and sea
#
mkdir -p tools
pushd tools > /dev/null

if [ ! -d "${MKGMAP}" ]; then
    echo "Downloading ${MKGMAP}..."
    wget "http://www.mkgmap.org.uk/download/${MKGMAP}.zip"
    unzip "${MKGMAP}.zip"
else
    echo "${MKGMAP} already downloaded"
fi
MKGMAPJAR="$(pwd)/${MKGMAP}/mkgmap.jar"

if [ ! -d "${SPLITTER}" ]; then
    echo "Downloading ${SPLITTER}..."
    wget "http://www.mkgmap.org.uk/download/${SPLITTER}.zip"
    unzip "${SPLITTER}.zip"
else
    echo "${SPLITTER} already downloaded"
fi
SPLITTERJAR="$(pwd)/${SPLITTER}/splitter.jar"

popd > /dev/null

if stat --printf='' bounds/bounds_*.bnd 2> /dev/null; then
    echo "bounds already downloaded"
else
    echo "downloading bounds"
    rm -f bounds.zip  # just in case
    wget -O bounds.zip "http://osm.thkukuk.de/data/bounds-latest.zip"
    unzip "bounds.zip" -d bounds
fi

BOUNDS="$(pwd)/bounds"

if stat --printf='' sea/sea_*.pbf 2> /dev/null; then
    echo "sea already downloaded"
else
    echo "downloading sea"
    rm -f sea.zip  # just in case
    wget -O sea.zip "https://www.thkukuk.de/osm/data/sea-latest.zip"
    unzip "sea.zip"
fi

SEA="$(pwd)/sea"

#
# Fetch map data, split & build garmin map
#

mkdir -p data
pushd data > /dev/null

if stat --printf='' ${REGION}.osm.pbf 2> /dev/null; then
    echo "${REGION}.osm.pbf already downloaded"
else
    echo "downloading ${REGION}.osm.pbf"
    wget ${REGIONURL}
fi

echo "##### Running ${SPLITTERJAR}... #####"
rm -f ${MAPID}*.pbf areas.* densities-out.txt template.args
java -Xmx8192M -jar $SPLITTERJAR --precomp-sea=$SEA  --mapid=${MAPID}0001 "$(pwd)/${REGION}.osm.pbf"
DATA="$(pwd)/${MAPID}*.pbf"

popd > /dev/null

OPTIONS="$(pwd)/opentopomap_options"
STYLEFILE="$(pwd)/style/opentopomap"

pushd style/typ > /dev/null

echo "##### Generating opentopomap.typ... #####"
java -jar $MKGMAPJAR --family-id=35 opentopomap.txt
TYPFILE="$(pwd)/opentopomap.typ"

popd > /dev/null

echo "##### Running ${MKGMAPJAR}... #####"
rm -rf ./output_tmp
java -Xmx8192M -jar $MKGMAPJAR -c $OPTIONS --style-file=$STYLEFILE \
    --precomp-sea=$SEA \
    --dem=./dem1/all \
    --output-dir=output_tmp --bounds=$BOUNDS $DATA $TYPFILE

echo "Generated map will be saved as output/otm-${REGION}.img"
mkdir -p output
mv output_tmp/gmapsupp.img output/otm-${REGION}.img
