import os
import time

# Load the rest of the env variables
KAIROS = os.getenv('KAIROS')
METRIC_BASE = os.getenv('METRIC_BASE', 'M')

# get seed, rate, count
METRIC_WRITE_RATE = float(os.getenv('METRIC_WRITE_RATE', '1000.0'))
HOURS = int(os.getenv('HOURS', '24'))
JOBS = int(os.getenv('JOBS', '1'))
DEVICES = int(os.getenv('DEVICES', '10'))
METRICS = int(os.getenv('METRICS', '16'))
VOLUMES = int(os.getenv('VOLUMES', '10'))
SAMPLES_PER_HOUR = int(os.getenv('SAMPLES_PER_HOUR', '120'))
REAL_TTL_SEC = int(os.getenv('REAL_TTL_SEC', '86400'))
REPORT_INTERVAL = 15

# read values
METRIC_READ_RATE = float(os.getenv('METRIC_READ_RATE', '1.0'))
WINDOW_END = int(os.getenv('WINDOW_END', str(int(time.time() * 1000))))
WINDOW_BEGIN = int(os.getenv('WINDOW_BEGIN', str(WINDOW_END - 86400000)))
QUERIES = int(os.getenv('QUERIES', '1000'))
