#!/usr/bin/python3

import sys, os, subprocess
import code
import argparse

p=argparse.ArgumentParser()
p.add_argument("-d", action="store_true")
p.add_argument("-q", "--quick", action="store_true")
p.add_argument("-s", "--shellcode", default="sh")
p.add_argument("-f", "--file", default="a.out")
p.add_argument("--quiet", action="store_true")
p.add_argument("--pie", default="1")
args = p.parse_args()

def insert(dst, src, idx):
	for i in range(len(src)):
		try:
			dst[idx+i] = src[i]
		except:
			return 1
	return 0
def bash():
	os.system("bash -i")
def insertdefault(insertoffset=0x1350):
	global buf, shcode
	buf = bytearray(buf)
	insert(buf, shcode, insertoffset) # at offset
	if not args.quiet:
		print("inserted shellcode at offset", hex(insertoffset))
default = 0x1350 if args.pie else 0x401350
def changeeentry(b=None, new=default): # old: 0x1040 (64) 0x1070 (32) # VIRTUAL MEM, NOT FILE OFFSET
	if b:
		buf = b
	else:
		buf = globals()["buf"]
	for i in range(8):
		buf[0x18+i] = (new >> 8*i)&0xff
	if not args.quiet:
		print("changed e_entry to", hex(new))
def default():
	insertdefault()
	changeeentry()
	writein()
	if not args.quiet:
		print("default done")
def writein():
	with open(args.file, "wb") as f:
		f.write(buf)

with open(args.file, "rb") as f:
	buf = f.read()
with open(args.shellcode, "rb") as f:
	shcode = f.read()

buf = bytearray(buf)
if not args.quiet:
	print("0x116c and 0x2000")

if args.d:
	default()

if not args.quick:
	code.interact(local=dict(globals(), **locals()))
