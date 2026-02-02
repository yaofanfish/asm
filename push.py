import sys, os, subprocess, time

PUSH_PERIOD=5 # seconds
MAX_PUSH=5 # times
VERBOSE=1
PUSH_FILE="pu.sh"

pu_sh_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), PUSH_FILE)
i=0
while 1:
	subprocess.run([pu_sh_file], capture_output=bool(VERBOSE))
	i+=1
	if i<=MAX_PUSH:
		if MAX_PUSH!=-1:
			print("STOPPED UPDATING") if VERBOSE else None
			sys.exit()
	time.sleep(PUSH_PERIOD)
