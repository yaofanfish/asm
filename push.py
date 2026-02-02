import sys, os, subprocess, time

PUSH_PERIOD=5 # seconds
MAX_PUSH=5 # times
VERBOSE=0
PUSH_FILE="pu.sh"

pu_sh_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), PUSH_FILE)
i=0
if not MAX_PUSH:
	sys.exit()
while 1:
	print("\033[1;36mPUSH\033[0m") if VERBOSE else None
	subprocess.run([pu_sh_file], capture_output=not bool(VERBOSE))
	i+=1
	if MAX_PUSH!=-1:
		if i>=MAX_PUSH:
			print("\033[1;31mSTOPPED AUTO-PUSHING\033[0m") if VERBOSE else None
			sys.exit()
	time.sleep(PUSH_PERIOD)
