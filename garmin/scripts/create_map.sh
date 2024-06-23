#!/bin/bash

display_usage() {
    echo -e "\nCreate a map for Garmin GPS devices using OpenTopoMap styles.\n"
    echo -e "Usage:"
    echo -e "$0 REGIONURL MAPID\n"
    echo -e "REGIONURL must refer to a *.osm.pbf file on https://download.geofabrik.de/"
    echo -e "MAPID must be a unique 4-digit number, e.g., based on the telephone country code\n"
    echo -e "Example:"
    echo -e "$0 https://download.geofabrik.de/europe/germany-latest.osm.pbf 4900"
}

if [ $# -le 1 ]; then
  display_usage
  exit 1
fi

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
echo -e "\n########## Create map for region ${REGION} ##########"

#
# Change to the folder where the script is located and set env variables.
#
cd $(dirname $0) || { echo "cd command failed"; exit 1; }
source setup_vars.bash

#
# Download required tools
#
echo -e "\n##### Download required tools #####"
./download_tools.sh || exit 1

# Go to the OpenTopoMap/garmin folder.
cd .. || { echo "cd command failed"; exit 1; }

#
# Set several variables
#
MKGMAPJAR="$(pwd)/tools/${MKGMAP}/mkgmap.jar"
SPLITTERJAR="$(pwd)/tools/${SPLITTER}/splitter.jar"

TOP_DIR="$(pwd)"
DOWNLOAD_DIR="$(pwd)/download_geofabrik"
SPLITTER_OUT_DIR="$(pwd)/splitter_out"
MKGMAP_WORK_DIR="$(pwd)/mkgmap_work"
OUTPUT_DIR="$(pwd)/output"
TYP_DIR="$(pwd)/style/typ"
DEM_DIR="$(pwd)/dem1"
OPENTOPOMAP_OPTIONS="$(pwd)/opentopomap_options"
STYLEFILE="$(pwd)/style/opentopomap"

#
# Check whether files with height information have been downloaded.
#
if [[ "$(ls ${DEM_DIR}/all/*.hgt | wc -l)" -ne 1048 ]]; then
    echo "Files with height information are missing. Please run this command first:"
    echo "./download_viewfinderpanoramas.sh"
    exit 1
fi

#
# Download bounds
#
echo -e "\n##### Download bounds and sea #####"
if stat --printf='' bounds/bounds_*.bnd 2> /dev/null; then
    echo "bounds already downloaded"
else
    echo "downloading bounds"
    rm -f bounds.zip  # just in case
    wget -O bounds.zip "http://osm.thkukuk.de/data/bounds-latest.zip"
    unzip "bounds.zip" -d bounds
fi
BOUNDS="$(pwd)/bounds"
if [ ! -d "${BOUNDS}" ]; then
    echo "Failed to extract ${BOUNDS} folder."
    exit 1
fi

#
# Download sea
#
if stat --printf='' sea/sea_*.pbf 2> /dev/null; then
    echo "sea already downloaded"
else
    echo "downloading sea"
    rm -f sea.zip  # just in case
    wget -O sea.zip "https://www.thkukuk.de/osm/data/sea-latest.zip"
    unzip "sea.zip"
fi
SEA="$(pwd)/sea"
if [ ! -d "${SEA}" ]; then
    echo "Failed to extract ${SEA} folder."
    exit 1
fi

#
# Fetch map data
#
echo -e "\n##### Fetch map data #####"
mkdir -p "${DOWNLOAD_DIR}" 
cd "${DOWNLOAD_DIR}" || exit 1

if stat --printf='' ${REGION}.osm.pbf 2> /dev/null; then
    echo "${REGION}.osm.pbf already downloaded"
else
    echo "downloading ${REGION}.osm.pbf"
    wget ${REGIONURL}
fi
if [ ! -f ${REGION}.osm.pbf ]; then
    echo "Failed to download ${REGION}.osm.pbf."
    exit 1
fi

#
# Run splitter
#
echo -e "\n##### Running ${SPLITTERJAR}... #####"
mkdir -p "${SPLITTER_OUT_DIR}" 
cd "${SPLITTER_OUT_DIR}" || exit 1
rm -f ${MAPID}*.pbf areas.* densities-out.txt template.args
java -Xmx8192M -jar $SPLITTERJAR --precomp-sea=$SEA  --mapid=${MAPID}0001 "${DOWNLOAD_DIR}/${REGION}.osm.pbf" || exit 1
SPLIT_DATA="$(pwd)/${MAPID}*.pbf"

#
# Generate opentopomap.typ
#
echo -e "\n##### Generating opentopomap.typ... #####"
cd ${TYP_DIR} || exit 1
java -jar $MKGMAPJAR --family-id=35 opentopomap.txt || exit 1
TYPFILE="$(pwd)/opentopomap.typ"

#
# Run mkgmap
#
echo -e "\n##### Running ${MKGMAPJAR}... #####"
cd ${TOP_DIR}
rm -rf ${MKGMAP_WORK_DIR}
java -Xmx8192M -jar $MKGMAPJAR -c $OPENTOPOMAP_OPTIONS --style-file=${STYLEFILE} \
    --precomp-sea=$SEA \
    --dem=${DEM_DIR}/all \
    --output-dir=${MKGMAP_WORK_DIR} --bounds=$BOUNDS $SPLIT_DATA $TYPFILE

echo -e "\nDone! Generated map will be saved as\n${OUTPUT_DIR}/otm-${REGION}.img"
mkdir -p "${OUTPUT_DIR}"
mv ${MKGMAP_WORK_DIR}/gmapsupp.img "${OUTPUT_DIR}/otm-${REGION}.img" || exit 1
