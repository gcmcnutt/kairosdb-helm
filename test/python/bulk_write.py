# Generate predictable data at a rate from a seed
import logging
import json
import settings
import requests
import math
import time

from ratelimiter import RateLimiter

logger = logging.getLogger(__name__)
logFormatStr = '[%(asctime)s] p%(process)s {%(pathname)s:%(lineno)d} %(levelname)s - %(message)s'
logging.basicConfig(format=logFormatStr, level=logging.INFO)

rate_limiter = RateLimiter(max_calls=settings.DEVICE_PROCESS_RATE / 10.0, period=0.1)

exceptions = 0
written = 0
iwritten = 0

call_time = 0.0
call_count = 0
icall_time = 0.0
icall_count = 0

next_report = time.time() + settings.REPORT_INTERVAL

logger.info(
    "start: base={} hours={} devices={} metrics={} volumes={} samples_per_hour={} endpoint={}".format(
        settings.METRIC_BASE, settings.HOURS,
        settings.DEVICES, settings.METRICS, settings.VOLUMES,
        settings.SAMPLES_PER_HOUR,
        settings.KAIROS))

start_time = time.time() - settings.HOURS * 3600
begin = time.time()
ibegin = begin

for h in xrange(settings.HOURS):
    for d in xrange(settings.DEVICES):

        # should we log
        now = time.time()
        if now > next_report:
            logger.info(
                "update: hours={} device={} iwritten={} imetric_rate={} icall_count={} iavg_call_time={} exceptions={}"
                .format(h, d, iwritten, iwritten / (now - ibegin), icall_count, icall_time / icall_count, exceptions))

            next_report = now + settings.REPORT_INTERVAL
            icall_time = 0.0
            icall_count = 0
            iwritten = 0
            ibegin = now

        with rate_limiter:

            batch = []

            # for each volume
            for v in xrange(settings.VOLUMES):

                # for each metric
                for m in xrange(settings.METRICS):
                    a = {}
                    a['name'] = '%s|%d' % (settings.METRIC_BASE, m)
                    a['tags'] = {"device": str(d), "volume": str(v)}
                    a['ttl'] = 2 * settings.HOURS * 3600

                    # for each sample
                    dp = []
                    for s in xrange(settings.SAMPLES_PER_HOUR):
                        # start time plus hours run plus samples + device number based dither for msec
                        t = int((start_time + h * 3600.0 + s * 3600.0 / settings.SAMPLES_PER_HOUR) * 1000 + d)

                        # sin wave with scale a function of volume, phase as a function of device, frequency as a function of metric
                        value = (1.0 + v * 1.0 / settings.VOLUMES) * math.sin((2 * math.pi * d / settings.DEVICES) + (1.0 + m) * math.pi * (
                            h * 3600.0 + s * 3600.0 / settings.SAMPLES_PER_HOUR) / (settings.HOURS * 3600.0))

                        dp.append([t, value])

                    a['datapoints'] = dp
                    batch.append(a)

            payload = json.dumps(batch)
            url = settings.KAIROS + "/api/v1/datapoints"
            headers = {'Content-Type': 'application/json'}

            # logger.info(payload)

            t1 = time.time()
            try:
                response = requests.post(url=url, timeout=10, headers=headers, data=payload)
                response.raise_for_status()

            except Exception:
                logger.exception("error sending data")
                exceptions = exceptions + 1

            call_count = call_count + 1
            icall_count = icall_count + 1
            call_time = call_time + (time.time() - t1)
            icall_time = icall_time + (time.time() - t1)
            written = written + settings.VOLUMES * settings.METRICS * settings.SAMPLES_PER_HOUR
            iwritten = iwritten + settings.VOLUMES * settings.METRICS * settings.SAMPLES_PER_HOUR

duration = time.time() - begin
logger.info("end: duration={} written={} metric_rate={} kairos_calls={} avg_call_time={} exceptions={}"
            .format(duration, written, written * 1.0 / duration, call_count, call_time / call_count, exceptions))
