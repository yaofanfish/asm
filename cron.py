import os

f = os.path.join(os.path.dirname(os.path.abspath(__file__)), "push.py")
c = f"python3 {f} 1 0 1"

crons = [
	f"@hourly {c}",
	f"@reboot {c}",
	f"0,30 * * * * {c}",
	f"*/15 * * * * {c}",
	f"*/5 * * * * {c}",
	f"*/1 * * * * {c}",
]
cron = crons[5]

def inCron(croncmd=cron):
	croncmd = croncmd.strip()
	cmd = f"(crontab -l 2>/dev/null; echo '{croncmd}') | crontab -"
	print(cmd)
	os.system(cmd)

def outCron(croncmd=cron):
	croncmd = croncmd.strip()
	cmd = f"crontab -l 2>/dev/null | grep -v '{croncmd}' | crontab -"
	print(cmd)
	os.system(cmd)

def outAll():
	for i in crons:
		outCron(croncmd=i)

inCron()
