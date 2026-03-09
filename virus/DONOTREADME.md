a bunch of stuff i did
1 shcode inj for non pie, fixed vaddrs
2 shcode injection for pies, using fixed rel file offsets (from call-pop)
3 shcode inj for pies, constructing a pointer-using syscall on stack
4 shcode inj for pies, without fixed rel file offsets and being injected dynamically by python
future:
5 the class takes an infected file as __init__ instead of a healthy + shellcode file
6 self-replicating malware, writes python because i do not want to deal with parsing in asm

dependencies:
- python3
- coreutils
- binutils
(mild - exists in debian min)
