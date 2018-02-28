import os

# Load the rest of the env variables
KAIROS = os.getenv('KAIROS')
METRIC_BASE = os.getenv('METRIC_BASE', 'M')

# get seed, rate, count
DEVICE_PROCESS_RATE = float(os.getenv('RATE', '1.0'))
HOURS = int(os.getenv('HOURS', '24'))
DEVICES = int(os.getenv('DEVICES', '10'))
METRICS = int(os.getenv('METRICS', '16'))
VOLUMES = int(os.getenv('VOLUMES', '10'))
SAMPLES_PER_HOUR = int(os.getenv('SAMPLES_PER_HOUR', '120'))
REPORT_INTERVAL = 10

# for i in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25; do run=lyu7-$i; kubectl --context skunk4.pstg-prd.net --image 473933976095.dkr.ecr.us-west-2.amazonaws.com/gmcnutt:lyu9 --restart=Never run $run -- sh -c "KAIROS=http://joking-warthog-kairosdb METRIC_BASE=$run HOURS=240 DEVICES=100 VOLUMES=50 METRICS=16 DEVICE_PROCESS_RATE=100 python bulk_write.py"; done

# for i in 0 1 2 3 4; do run=lyu6-$i; kubectl --context cluster1.pstg-dev.net --image 621123821552.dkr.ecr.us-west-2.amazonaws.com/gmcnutt:lyu9 --restart=Never run $run -- sh -c "KAIROS=http://ordered-lamb-kairosdb METRIC_BASE=$run HOURS=240 DEVICES=10 VOLUMES=50 METRICS=16 DEVICE_PROCESS_RATE=0.25 python bulk_write.py"; done
