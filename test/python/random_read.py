# try some random reads that look like production

# given a KAIROSDB and a size/shape of the time series
# and given a time range (relative to now) to consider as the viewable time window
# and given a query shape
#  query all metrics for a device over time range
#  query a few metrics for several devices over a time range

# construct a query
# estimate the expected count of elements we should see
# sample a few elements to see if they are in expected range

import logging
import json
import settings
import requests
import math
import time
import random

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
iread_items = 0
read_items = 0

call_time = 0.0
call_count = 0
icall_count = 0

logger.info(
    "start: base={} devices={} metrics={} volumes={} samples_per_hour={} metric_read_rate={} window_begin={} window_end={} endpoint={}".format(
        settings.METRIC_BASE,
        settings.DEVICES, settings.METRICS, settings.VOLUMES,
        settings.SAMPLES_PER_HOUR,
        settings.METRIC_READ_RATE,
        settings.WINDOW_BEGIN,
        settings.WINDOW_END,
        settings.KAIROS))

rateLimiter = RateLimiter(itemRate = settings.METRIC_READ_RATE)

start_time = time.time() - settings.HOURS * 3600
next_report = time.time() + settings.REPORT_INTERVAL
begin = time.time()
ibegin = begin

for loop in xrange(settings.QUERIES):

    # generate a simple grouping query across the sample area

    # pick a device/metric
    metric = '%s|%d' % (settings.METRIC_BASE, random.randint(0, settings.METRICS - 1))

    # pick a timerange (24 hour randomly distributed)
    base_time = long(random.choice(range(settings.WINDOW_BEGIN, settings.WINDOW_END - 1)))
    end_time = base_time + 86400000

    # pick a random volume
    rand_vol = random.randint(0, settings.VOLUMES - 1)

    query_params = "query: metric={} volume={} start={}".format(metric, rand_vol, base_time)

    # standard grouping
    # standard aggregators
    query = {
        "start_absolute": base_time,
        "end_absolute": end_time,
        "metrics": [
            {
                "name": metric,
                "limit": 100000,
                "aggregators": [
                    {
                        "name": "avg",
                        "sampling": {
                            "value": 1,
                            "unit": "minutes"
                        }
                    }
                ],
                "group_by": [
                    {
                        "name": "tag",
                        "tags": ["device"]
                    }
                ],
                "tags": {
                    "volume": rand_vol
                }
            }
        ]
    }

    payload = json.dumps(query)
    url = settings.KAIROS + "/api/v1/datapoints/query"
    headers = {'Content-Type': 'application/json'}

    t1 = time.time()

    response = {}
    try:
        response = requests.post(url=url, timeout=10, headers=headers, data=payload)
        response.raise_for_status()

        answer = response.json()
        # logger.info(json.dumps(answer, indent=2, sort_keys=True))

        items_returned = 0
        for queries in answer["queries"]:
            for results in queries["results"]:
                items_returned = items_returned + len(results["values"])

        # TODO compute what we should see and validate the values are there...

        iread_items = iread_items + items_returned
        read_items = read_items + items_returned

        logger.info("query={} items_returned={}".format(query_params, items_returned))

    except Exception:
        logger.exception("query={}, response={}".format(query_params, response.text))
        exceptions = exceptions + 1

    call_count = call_count + 1
    icall_count = icall_count + 1
    call_time = call_time + (time.time() - t1)

    # lastly should we sleep?
    rateLimiter(1)

    # should we log
    now = time.time()
    if now > next_report:
        logger.info(
            "update: calls={} icalls={} call_rate={} read={} iread={} avg_call_time={} exceptions={}"
                .format(call_count, icall_count, icall_count / (now - ibegin),
                        read_items, iread_items, call_time / call_count if call_count > 0 else 0, exceptions))

        next_report = now + settings.REPORT_INTERVAL
        ibegin = now
        iread_items = 0
        icall_count = 0

duration = time.time() - begin
logger.info("end: duration={} calls={} read={} metric_rate={} avg_call_time={} exceptions={}"
            .format(duration, call_count, read_items, call_count * 1.0 / duration, call_time / call_count, exceptions))
