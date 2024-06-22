#!/bin/bash

# Create a Garmin map for the regions mentioned below.
#
./create_map.sh https://download.geofabrik.de/europe/germany-latest.osm.pbf 4900  || exit 1
./create_map.sh https://download.geofabrik.de/europe/united-kingdom-latest.osm.pbf 4400  || exit 1
./create_map.sh https://download.geofabrik.de/europe/france-latest.osm.pbf 3300  || exit 1
./create_map.sh https://download.geofabrik.de/europe/switzerland-latest.osm.pbf 4100  || exit 1
./create_map.sh https://download.geofabrik.de/europe/austria-latest.osm.pbf 4300  || exit 1
./create_map.sh https://download.geofabrik.de/europe/italy-latest.osm.pbf 3900  || exit 1
./create_map.sh https://download.geofabrik.de/europe/liechtenstein-latest.osm.pbf 4230  || exit 1
./create_map.sh https://download.geofabrik.de/europe/belgium-latest.osm.pbf 3200  || exit 1
./create_map.sh https://download.geofabrik.de/europe/netherlands-latest.osm.pbf 3100  || exit 1
./create_map.sh https://download.geofabrik.de/europe/norway-latest.osm.pbf 4700  || exit 1
./create_map.sh https://download.geofabrik.de/europe/spain-latest.osm.pbf 3400  || exit 1
./create_map.sh https://download.geofabrik.de/europe/denmark-latest.osm.pbf 4500  || exit 1
./create_map.sh https://download.geofabrik.de/europe/sweden-latest.osm.pbf 4600  || exit 1
./create_map.sh https://download.geofabrik.de/europe/ireland-latest.osm.pbf 3530  || exit 1
./create_map.sh https://download.geofabrik.de/europe/luxemburg-latest.osm.pbf 3520  || exit 1
./create_map.sh https://download.geofabrik.de/europe/portugal-latest.osm.pbf 3510  || exit 1
