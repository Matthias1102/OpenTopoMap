# Scripts for building custom maps for Garmin GPS devices

This approach is based on the instructions
[Building a custom Garmin map - a complete walkthrough](https://github.com/Matthias1102/OpenTopoMap/blob/master/garmin/README.md).

## Download Tools

The script [`download_tools.sh`](./download_tools.sh) creates the `tools` folder and downloads the required tools:

- [mkgmap](https://www.mkgmap.org.uk/doc/index.html), [Release Notes](https://www.mkgmap.org.uk/download/mkgmap.html)
- [splitter](https://www.mkgmap.org.uk/doc/splitter.html), [Release Notes](https://www.mkgmap.org.uk/download/splitter.html)
- [Srtm2Osm](https://wiki.openstreetmap.org/wiki/Srtm2Osm), [Release Notes](https://wiki.openstreetmap.org/wiki/Srtm2Osm#Download)
- [Osmosis](https://wiki.openstreetmap.org/wiki/Osmosis), [Release Notes](https://github.com/openstreetmap/osmosis/releases/tag/0.49.2)

Before you can use the download script, edit your local copy of the file
[setup_vars.bash](https://github.com/Matthias1102/GarminContourMap/blob/main/setup_vars.bash)
and adjust the version info for all tools according to the Release Note pages listed above.

## Download *.hgt files from viewfinderpanoramas

This script downloads and  uncompresses the *.hgt files containing height information
for Europe. The *.hgt files are needed by mkgmap tool used in the
create_map.sh script in order to create hill shading. For further
details, refer to https://www.mkgmap.org.uk/doc/options

The *.hgt files typically cover 1 degree latitude by 1 degree longitude
and are named by the coordinates of their bottom left corner (e.g. N53E009).
They contain height information in a grid of points. We use hgt files
that contain 1 arc second data. 1 arc second files have 3601 x 3601
points, with a file size of 25,934,402 bytes.

An interactive coverage map of all available tiles with 1 arc seconds
resolution can be found at
https://viewfinderpanoramas.org/Coverage%20map%20viewfinderpanoramas_org1.htm


