import sys, os, subprocess, time, json

MAX_PUSH_PERIOD=240 # seconds
MAX_PUSH=5 # times
VERBOSE=1
PUSH_FILE="pu.sh"
JSON_FILE="push.json"

pu_sh_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), PUSH_FILE)
jason_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), JSON_FILE)
def checkstop(MAX_PUSH=None, i=None):
	if MAX_PUSH==None:
		MAX_PUSH = globals()["MAX_PUSH"]
	if i==None:
		i = globals()["i"]
	if MAX_PUSH!=-1:
		if i>=MAX_PUSH:
			print("\033[1;31mSTOPPED AUTO-PUSHING\033[0m")
			sys.exit()
def upd(i=None):
	if i is None:
		i = globals()["i"]
	with open(jason_file) as f:
		jason = json.load(f)
	try:
		if jason["stop"]:
			checkstop(0, 1)
	except KeyError:
		pass
	with open(jason_file, "w") as f:
		json.dump({"pushno": i, "stop": 0}, f)
i=0
if not MAX_PUSH:
	sys.exit()
while 1:
	print("\033[1;36mPUSH\033[0m") if VERBOSE else None
	subprocess.run([pu_sh_file], capture_output=not bool(VERBOSE))
	upd()
	i+=1
	checkstop(MAX_PUSH, i)
	time.sleep(MAX_PUSH_PERIOD)
