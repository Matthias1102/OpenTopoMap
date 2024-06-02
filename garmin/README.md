# Building a custom Garmin map - a complete walkthrough

Based on the [HOWTO](HOWTO) this guide describes how to create a custom Garmin map.
using OpenTopoMap styles.

## Required tools & OpenTopoMap repository

```bash
git clone https://github.com/Matthias1102/OpenTopoMap.git
cd OpenTopoMap/garmin
```

Download [mkgmap](http://www.mkgmap.org.uk/download/mkgmap.html),
[splitter](http://www.mkgmap.org.uk/download/splitter.html) & bounds

Boundary and sea files are no longer provided by
http://osm2.pleiades.uni-wuppertal.de. Instead, we use the URLs
given by https://www.mkgmap.org.uk/download/mkgmap.html.

```bash
MKGMAP="mkgmap-r4919" # adjust to latest version (see www.mkgmap.org.uk)
SPLITTER="splitter-r654"

mkdir tools
pushd tools > /dev/null

if [ ! -d "${MKGMAP}" ]; then
    wget "http://www.mkgmap.org.uk/download/${MKGMAP}.zip"
    unzip "${MKGMAP}.zip"
fi
MKGMAPJAR="$(pwd)/${MKGMAP}/mkgmap.jar"

if [ ! -d "${SPLITTER}" ]; then
    wget "http://www.mkgmap.org.uk/download/${SPLITTER}.zip"
    unzip "${SPLITTER}.zip"
fi
SPLITTERJAR="$(pwd)/${SPLITTER}/splitter.jar"

popd > /dev/null

if stat --printf='' bounds/bounds_*.bnd 2> /dev/null; then
    echo "bounds already downloaded"
else
    echo "downloading bounds"
    rm -f bounds.zip  # just in case
    #wget "http://osm2.pleiades.uni-wuppertal.de/bounds/latest/bounds.zip"
    wget -O bounds.zip "http://osm.thkukuk.de/data/bounds-latest.zip"
    unzip "bounds.zip" -d bounds
fi

BOUNDS="$(pwd)/bounds"

if stat --printf='' sea/sea_*.pbf 2> /dev/null; then
    echo "sea already downloaded"
else
    echo "downloading sea"
    rm -f sea.zip  # just in case
    #wget "http://osm2.pleiades.uni-wuppertal.de/sea/latest/sea.zip"
    wget -O sea.zip "https://www.thkukuk.de/osm/data/sea-latest.zip"
    unzip "sea.zip"
fi

SEA="$(pwd)/sea"
```

## Fetch map data, split & build garmin map

```bash
mkdir data
pushd data > /dev/null

rm -f morocco-latest.osm.pbf
wget "https://download.geofabrik.de/africa/morocco-latest.osm.pbf"

rm -f 6324*.pbf areas.* densities-out.txt template.args
java -jar $SPLITTERJAR --precomp-sea=$SEA "$(pwd)/morocco-latest.osm.pbf"
DATA="$(pwd)/6324*.pbf"

popd > /dev/null

OPTIONS="$(pwd)/opentopomap_options"
STYLEFILE="$(pwd)/style/opentopomap"

pushd style/typ > /dev/null

java -jar $MKGMAPJAR --family-id=35 opentopomap.txt
TYPFILE="$(pwd)/opentopomap.typ"

popd > /dev/null

java -jar $MKGMAPJAR -c $OPTIONS --style-file=$STYLEFILE \
    --precomp-sea=$SEA \
    --output-dir=output --bounds=$BOUNDS $DATA $TYPFILE

# optional: give map a useful name:
mv output/gmapsupp.img output/morocco.img

```
