# Santiago Daily Forecast

## How it runs
The daily forecast runs using the distributed cron.

Scripts by CESGA (http://trafair.eu/)

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