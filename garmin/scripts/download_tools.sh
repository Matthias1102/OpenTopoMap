#!/bin/bash

#
# Download the tools that are required for create_contour_map.sh
#

# Change to the folder where the script is located and set env variables.
cd $(dirname $0) || { echo "cd command failed"; exit 1; }
source setup_vars.bash

# Go to the OpenTopoMap/garmin folder and create the tools folder there.
cd .. || { echo "cd command failed"; exit 1; }
mkdir -p tools
cd tools

#
# Download mkgmap
#
if [ ! -d "${MKGMAP}" ]; then
    echo "Downloading ${MKGMAP}..."
    wget "http://www.mkgmap.org.uk/download/${MKGMAP}.zip"
    unzip "${MKGMAP}.zip"
else
    echo "${MKGMAP} already downloaded"
fi
MKGMAP_JAR="$(pwd)/${MKGMAP}/mkgmap.jar"
if [ ! -f ${MKGMAP_JAR} ]; then
    echo "Failed to extract ${MKGMAP_JAR} from zip file."
    exit 1
fi

#
# Download splitter
#
if [ ! -d "${SPLITTER}" ]; then
    echo "Downloading ${SPLITTER}..."
    wget "http://www.mkgmap.org.uk/download/${SPLITTER}.zip"
    unzip "${SPLITTER}.zip"
else
    echo "${SPLITTER} already downloaded"
fi
SPLITTER_JAR="$(pwd)/${SPLITTER}/splitter.jar"
if [ ! -f ${SPLITTER_JAR} ]; then
    echo "Failed to extract ${SPLITTER_JAR} from zip file."
    exit 1
fi

#
# Print success message
#
echo -e "\nSuccess!\nAll tools have been downloaded successfully:"
ls -ld ${MKGMAP}
ls -ld ${SPLITTER}
