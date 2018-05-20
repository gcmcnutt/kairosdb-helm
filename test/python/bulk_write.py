# Generate predictable data at a rate

# usage:
# KAIROS=http://internal-ad9e3bdb15c7611e8a9910aa08f0fe8e-766401239.us-west-2.elb.amazonaws.com METRIC_BASE=g1 HOURS=4 DEVICES=1 METRICS=2 VOLUMES=2 python bulk_write.py


import logging
import json
import settings
import requests
import math
import time

class RateLimiter:
    def __init__(self, itemRate=5.0, refillInterval=1, maxFill=2.0):
        self.itemRate = itemRate
        self.refillInterval = refillInterval
        self.maxFill = maxFill

        # start out with 2x the number of tokens
        self.tokens = self.itemRate * self.maxFill
        self.lastFillTime = time.time()

    def __call__(self, items):
        self.tokens = self.tokens - items

        now = time.time()
        if now > self.lastFillTime + self.refillInterval:
            # add some tokens
            self.tokens = min(self.itemRate * self.maxFill, self.tokens + self.itemRate * (now - self.lastFillTime))
            self.lastFillTime = now

        # if we are behind sleep
        if self.tokens < 0:
            delay = -self.tokens / self.itemRate
            time.sleep(delay)


logger = logging.getLogger(__name__)
logFormatStr = '[%(asctime)s] p%(process)s {%(pathname)s:%(lineno)d} %(levelname)s - %(message)s'
logging.basicConfig(format=logFormatStr, level=logging.INFO)

exceptions = 0
written = 0
iwritten = 0

call_time = 0.0
call_count = 0

logger.info(
    "start: base={} hours={} devices={} metrics={} volumes={} samples_per_hour={} metric_write_rate={} real_ttl_sec={} endpoint={}".format(
        settings.METRIC_BASE, settings.HOURS,
        settings.DEVICES, settings.METRICS, settings.VOLUMES,
        settings.SAMPLES_PER_HOUR,
        settings.METRIC_WRITE_RATE,
        settings.REAL_TTL_SEC,
        settings.KAIROS))

rateLimiter = RateLimiter(itemRate = settings.METRIC_WRITE_RATE)
next_report = time.time() + settings.REPORT_INTERVAL
start_time = time.time() - settings.HOURS * 3600

begin = time.time()
ibegin = begin

for h in xrange(settings.HOURS):
    for d in xrange(settings.DEVICES):

        batch = []

        # for each volume
        for v in xrange(settings.VOLUMES):

            # for each metric
            for m in xrange(settings.METRICS):
                a = {}
                a['name'] = '%s|%d' % (settings.METRIC_BASE, m)
                a['tags'] = {"device": str(d), "volume": str(v)}
                a['type'] = 'float'
                # a['ttl'] = settings.REAL_TTL_SEC

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

                iwritten = iwritten + settings.SAMPLES_PER_HOUR

            # lastly should we sleep?
            rateLimiter(settings.SAMPLES_PER_HOUR * settings.METRICS)

            # should we log
            now = time.time()
            if now > next_report:
                logger.info(
                    "update: hours={} device={} generated={} gen_rate={} written={} call_count={} avg_call_time={} exceptions={}"
                        .format(h, d, iwritten, iwritten / (now - ibegin), written, call_count, call_time / call_count if call_count > 0 else 0, exceptions))

                next_report = now + settings.REPORT_INTERVAL
                ibegin = now
                iwritten = 0

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
        call_time = call_time + (time.time() - t1)
        written = written + settings.VOLUMES * settings.METRICS * settings.SAMPLES_PER_HOUR

duration = time.time() - begin
logger.info("end: duration={} written={} metric_rate={} kairos_calls={} avg_call_time={} exceptions={}"
            .format(duration, written, written * 1.0 / duration, call_count, call_time / call_count, exceptions))
