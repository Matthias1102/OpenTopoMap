#!/bin/bash

#
# Cleanup temporary folders.
#

# Change to the parent folder of this script
cd $(dirname $0)/.. || exit 1

echo "Removing these folders: mkgmap_work, splitter_out"
echo "The following folders will be kept: dem1, download_geofabrik, output"
rm -rf mkgmap_work
rm -rf splitter_out
