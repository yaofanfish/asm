#!/usr/bin/python3
import sys, os, subprocess, time, json

settings={}
settings["MAX_PUSH_PERIOD"]=240 # seconds
settings["MAX_PUSH"]=5 # times
settings["VERBOSE"]=1
settings["PUSH_FILE"]="pu.sh"
settings["JSON_FILE"]="push.json"

for i, j in enumerate(settings.keys()):
	try:
		settings[j]=sys.argv[i+1]
	except IndexError:
		break

pu_sh_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), settings["PUSH_FILE"])
jason_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), settings["JSON_FILE"])
def checkstop(MAX_PUSH=None, i=None):
	if MAX_PUSH==None:
		MAX_PUSH = globals()["settings"]["MAX_PUSH"]
	if i==None:
		i = globals()["settings"]["i"]
	if settings["MAX_PUSH"]!=-1:
		if i>=settings["MAX_PUSH"]:
			print("\033[1;31mSTOPPED AUTO-PUSHING\033[0m")
			sys.exit()
def upd(i=None):
	if i is None:
		i = globals()["settings"]["i"]
	with open(jason_file, "w") as f:
		json.dump({"pushno": i, "stop": 0}, f)
	with open(jason_file) as f:
		jason = json.load(f)
	try:
		if jason["stop"]:
			checkstop(0, 1)
	except KeyError:
		pass
i=0
if not settings["MAX_PUSH"]:
	sys.exit()
while 1:
	print("\033[1;36mPUSH\033[0m") if settings["VERBOSE"] else None
	subprocess.run([pu_sh_file], capture_output=not bool(settings["VERBOSE"]))
	print("PUSHED") if settings["VERBOSE"] else None
	upd()
	i+=1
	checkstop(settings["MAX_PUSH"], i)
	time.sleep(settings["MAX_PUSH_PERIOD"])
