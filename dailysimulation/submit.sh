#!/bin/bash

set +x

# Enable us to use modules from cron
source /opt/cesga/Lmod7/setup.sh

# Modules needed
module load numpy/1.15.2-python-2.7.15
module load gcc/6.4.0
module load R 
WRKDIR=/home/otras/tro/arl/lustre/operativa
TOOLS=/home/otras/tro/arl/lustre/operativa/tools

cd $WRKDIR

# Get current date in YYYY-MM-DD format and store it in $date
printf -v DATE '%(%Y-%m-%d)T' -1

cp -a template $DATE
cd $DATE
head -n 48 $HOME/mettimeseries/$DATE/mettimeseries.dat | $TOOLS/adjust_mettimeseries.py > mettimeseries.dat
cp $HOME/mettimeseries/$DATE/Precipitation.txt ../$DATE
#$TOOLS/generate_emissions_timeseries.py $DATE > emissions_timeseries.txt
./lanzar_emisiones.sh
sed -e 's/YYYY-MM-DD/'$DATE'/g' run.sh.template > run.sh

sbatch run.sh
