#!/bin/bash

# Download and uncompress the *.hgt files containing height information
# for Europe. The *.hgt files are needed by mkgmap tool used in the
# create_map.sh script in order to create hill shading. For further
# details, refer to https://www.mkgmap.org.uk/doc/options
#
# The tiles with the *.hgt files are downloaded from
# viewfinderpanoramas.org.
#
# The *.hgt files typically cover 1 degree latitude by 1 degree longitude
# and are named by the coordinates of their bottom left corner (e.g. N53E009).
# They contain height information in a grid of points. We use hgt files
# that contain 1 arc second data. 1 arc second files have 3601 x 3601
# points, with a file size of 25,934,402 bytes.
#
# An interactive coverage map of all available tiles with 1 arc seconds
# resolution can be found at
# https://viewfinderpanoramas.org/Coverage%20map%20viewfinderpanoramas_org1.htm

cd $(dirname "$0")/..
mkdir -p dem1
cd dem1

for a in \
J29 J30 J31 J32 J33 \
K29 K30 K31 K32 K33 \
    L30 L31 L32 L33 L34 L35 \
M29 M30 M31 M32 M33 M34 \
N29 N30 N31 N32 N33 N34 \
O29 O30 O31 O32 O33 O34 O35 \
        P31 P32 P33 P34 P35 P36 \
            Q32 Q33 Q34 Q35 Q36 \
                R33 R34 R35 R36
do
  if stat --printf='' ${a}.zip 2> /dev/null; then
    echo "${a} already exists, skipping download"
  else
    echo "downloading ${a}"
    wget "https://viewfinderpanoramas.org/dem1/${a}.zip"
  fi
done

# Uncompress the downloaded zip files and store them in dem1/all.
rm -rf all
mkdir -p all
for a in *.zip; do
  unzip -d all/ $a
done
mv all/*/*.hgt all/
