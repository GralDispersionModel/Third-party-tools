#!/bin/bash
# vim:tabstop=2:autoindent:
#
# Authors: Cecilia Grela (cecilia@cesga.es) and Javier Cacheiro (jlopez@cesga.es). CESGA (http://trafair.eu/)
# Purpose: Generate GeoTIFFs with hourly aggregated concentrations
# Usage:
#       generate_geotiffs.sh 2020-04-20
# where 2020-04-20 corresponds to the date of the GRAL simulation
#
# Changelog
#  V1: 2020-04-29 JC
#      First version

# We get as argument the DATE of the simulation
if [[ $# != 1 ]]; then
    echo "Usage: $0 YYYY-MM-DD"
    exit 1
fi

DATE="$1"

# Let's split the date provided
YEAR=${DATE:0:4}
MONTH=${DATE:5:2}
DAY=${DATE:8:2}

WRKDIR="/home/otras/tro/arl/lustre/operativa"
TOOLS="/home/otras/tro/arl/lustre/operativa/tools"
GEOTIFFDIR="geotiff"

echo "--------------------------------------------------"
echo "Starting geotiff generation: $(date '+%m%d%Y %T')"
echo "Date of the simulation: "$DATE

# Modules needed
module load numpy/1.15.2-python-2.7.15 gdal/2.2.3-python-2.7.15

mkdir geotiff

# For each hour it generates a file with the format: 000{:02d}.total.txt
echo "Generating total hourly concentrations"
$TOOLS/aggregate_concentrations.py

mv 000*.total.txt $GEOTIFFDIR

cd $GEOTIFFDIR

for filename in *.total.txt; do
  basename=${filename%%.total.txt}
  echo "Converting $filename"
  # The format of the GeoTIFF filename needed is: yyyyMMddTHHmmssZ
  # for example 20190917T004000Z.tif
  hour="${basename:3:2}"
  minute="00"
  second="00"
  tiffname="${YEAR}${MONTH}${DAY}T${hour}${minute}${second}Z"
  # Transform ESRI ASCII to GeoTIFF
  gdal_translate -a_srs EPSG:32629 -co COMPRESS=PACKBITS -co TILED=YES $filename ${tiffname}.tif
done

echo "Ended geotiff generation: $(date '+%m%d%Y %T')"
