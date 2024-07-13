#!/bin/bash

#
# Create a Garmin map for the regions mentioned below.
# We have chosen all region codes such that they start with a 0, continued
# by their telephone country code. In this way, all contour maps can use
# region codes that don't start with a 0.
#

# Change to the folder where the script is located
cd $(dirname $0) || exit 1

./create_map.sh https://download.geofabrik.de/europe/germany-latest.osm.pbf 0490  || exit 1
./create_map.sh https://download.geofabrik.de/europe/united-kingdom-latest.osm.pbf 0440  || exit 1
./create_map.sh https://download.geofabrik.de/europe/france-latest.osm.pbf 0330  || exit 1
./create_map.sh https://download.geofabrik.de/europe/switzerland-latest.osm.pbf 0410  || exit 1
./create_map.sh https://download.geofabrik.de/europe/italy-latest.osm.pbf 0390  || exit 1
./create_map.sh https://download.geofabrik.de/europe/liechtenstein-latest.osm.pbf 0423  || exit 1
./create_map.sh https://download.geofabrik.de/europe/belgium-latest.osm.pbf 0320  || exit 1
./create_map.sh https://download.geofabrik.de/europe/netherlands-latest.osm.pbf 0310  || exit 1
./create_map.sh https://download.geofabrik.de/europe/norway-latest.osm.pbf 0470  || exit 1
./create_map.sh https://download.geofabrik.de/europe/spain-latest.osm.pbf 0340  || exit 1
./create_map.sh https://download.geofabrik.de/europe/denmark-latest.osm.pbf 0450  || exit 1
./create_map.sh https://download.geofabrik.de/europe/sweden-latest.osm.pbf 0460  || exit 1
./create_map.sh https://download.geofabrik.de/europe/ireland-and-northern-ireland-latest.osm.pbf 0353  || exit 1
./create_map.sh https://download.geofabrik.de/europe/luxembourg-latest.osm.pbf 0352  || exit 1
./create_map.sh https://download.geofabrik.de/europe/portugal-latest.osm.pbf 0351  || exit 1
./create_map.sh https://download.geofabrik.de/europe/austria-latest.osm.pbf 0430  || exit 1

./create_map.sh https://download.geofabrik.de/europe/andorra-latest.osm.pbf  0376 || exit 1
./create_map.sh https://download.geofabrik.de/europe/croatia-latest.osm.pbf  0385 || exit 1
./create_map.sh https://download.geofabrik.de/europe/slovenia-latest.osm.pbf 0386 || exit 1
./create_map.sh https://download.geofabrik.de/europe/bosnia-herzegovina-latest.osm.pbf 0387 || exit 1
./create_map.sh https://download.geofabrik.de/europe/montenegro-latest.osm.pbf 0382 || exit 1
./create_map.sh https://download.geofabrik.de/europe/greece-latest.osm.pbf 0300 || exit 1
./create_map.sh https://download.geofabrik.de/europe/czech-republic-latest.osm.pbf 0420 || exit 1
./create_map.sh https://download.geofabrik.de/europe/slovakia-latest.osm.pbf 0421 || exit 1
./create_map.sh https://download.geofabrik.de/europe/poland-latest.osm.pbf 0480 || exit 1
