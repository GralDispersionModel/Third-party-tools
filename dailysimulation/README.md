# Santiago Daily Forecast

The daily simulation is executed in CESGA's HPC infraestructure FinisTerrae II (https://www.cesga.es/en/infrastructures/computing/)


Scripts by CESGA (https://www.cesga.es/) for TRAFAIR project (http://trafair.eu/)

## How it runs
The daily forecast runs using the distributed cron.

```
crontab -l
SHELL=/bin/bash
PATH=/sbin:/usr/sbin:/usr/local/sbin:/bin:/usr/bin:/usr/local/bin

38 10 * * * run /home/otras/tro/arl/mettimeseries/download_mettimeseries.sh >> /home/otras/tro/arl/mettimeseries/download_mettimeseries.log
50 10 * * * run /home/otras/tro/arl/lustre/operativa/submit.sh >> /home/otras/tro/arl/lustre/operativa/submit.log
50 13 * * * run /home/otras/tro/arl/lustre/operativa/tools/sum_emissions.sh
```

After editing the cron you have to sync it using:

	sync_cron
