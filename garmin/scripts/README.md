# Scripts for building custom maps for Garmin GPS devices

This approach is based on the instructions
[Building a custom Garmin map - a complete walkthrough](https://github.com/Matthias1102/OpenTopoMap/blob/master/garmin/README.md).

## Download Tools

The script [`download_tools.sh`](./download_tools.sh) creates the `tools` folder and downloads the required tools:

| Tool                                                     | Release notes and download URL                                         |
| -------------------------------------------------------- | ---------------------------------------------------------------------- |
| [mkgmap](https://www.mkgmap.org.uk/doc/index.html)       | [Release notes](https://www.mkgmap.org.uk/download/mkgmap.html)        |
| [splitter](https://www.mkgmap.org.uk/doc/splitter.html)  | [Release notes](https://www.mkgmap.org.uk/download/splitter.html)      |
| [Srtm2Osm](https://wiki.openstreetmap.org/wiki/Srtm2Osm) | [Release notes](https://wiki.openstreetmap.org/wiki/Srtm2Osm#Download) |
| [Osmosis](https://wiki.openstreetmap.org/wiki/Osmosis)   | [Release notes](https://github.com/openstreetmap/osmosis/releases)     |

Before you can use the download script, edit your local copy of the file
[setup_vars.bash](https://github.com/Matthias1102/GarminContourMap/blob/main/setup_vars.bash)
and adjust the version info for all tools according to the Release Note pages listed in the table above.

## Download *.hgt files from [viewfinderpanoramas.org](https://viewfinderpanoramas.org/)

This script
[`download_viewfinderpanoramas.sh`](https://github.com/Matthias1102/OpenTopoMap/blob/Matthias1102/garmin/scripts/download_viewfinderpanoramas.sh)
downloads and  uncompresses the *.hgt files containing height information
for Europe. The *.hgt files are needed by mkgmap tool used in the
[`create_map.sh`](https://github.com/Matthias1102/OpenTopoMap/blob/Matthias1102/garmin/scripts/create_map.sh)
script in order to create the hill shading.
For further details, refer to https://www.mkgmap.org.uk/doc/options.

The *.hgt files typically cover 1 degree latitude by 1 degree longitude
and are named by the coordinates of their bottom left corner (e.g. N53E009).
They contain height information in a grid of points. We use hgt files
that contain 1 arc second data. 1 arc second files have 3601 x 3601
points, with a file size of 25,934,402 bytes.

An interactive coverage map of all available tiles with 1 arc seconds
resolution can be found at
https://viewfinderpanoramas.org/Coverage%20map%20viewfinderpanoramas_org1.htm.

## Create map for the specified region

The script
[`create_map.sh`](https://github.com/Matthias1102/OpenTopoMap/blob/Matthias1102/garmin/scripts/create_map.sh)
creates the map for the specified region.

```
Usage:
create_map.sh REGIONURL MAPID

REGIONURL must refer to a *.osm.pbf file on https://download.geofabrik.de/
MAPID must be a unique 4-digit number, e.g., based on the telephone country code

Example:
create_map.sh https://download.geofabrik.de/europe/germany-latest.osm.pbf 4900
```
To create the map, this script does the following:

- Download bounds and sea from http://osm.thkukuk.de/data
- Fetch OSM map data from https://download.geofabrik.de/.
  This step is skipped if the data for the region is already available in the `download_geofabrik` folder.
  To create a map with the latest OSM data, you have to remove the `.osm.pbf` file for the region in the
  `download_geofabrik` folder.
- Run splitter
- Generate opentopomap.typ
- Run mkgmap
- Copy the final map image to the `output` folder

## Create all maps

The script
[`create_all_maps.sh`](https://github.com/Matthias1102/OpenTopoMap/blob/Matthias1102/garmin/scripts/create_all_maps.sh)
runs the maps creation script for several European regions.
Feel free to comment-out or to add additional regions to your local copy of the script.

## Cleanup

The script
[`cleanup.sh`](https://github.com/Matthias1102/OpenTopoMap/blob/Matthias1102/garmin/scripts/cleanup.sh)
removes the temporary folders `mkgmap_work` and `splitter_out`.

The following folders will be kept:
`dem1` (downloaded height data), `download_geofabrik` (downloaded OSM data), `output` (final maps).
