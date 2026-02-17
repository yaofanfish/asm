// C version of s.asm
// because I need ts after writing asm for 2 days

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>
#include <string.h>

char* hi = "Hello, CSquare! \n";
int x = 16;
int y = 16;
double mat[4] = {1,0,0,1};
int cords[5][2] = {{8,8},{-8,8},{-8,-8},{8,-8},{NULL,NULL}};
int rcords[5][2];
char renderpixels[64];

void frender() {
	register int ecx = 0;
	register int edx;
	_frender:
	write(1, (renderpixels+ecx), 1);
	edx = ecx;
	edx &= 0x00000007;
	if (!edx) goto _frender;
	putchar('\n');
	if (ecx>=64) {
	}
}

void matmul(int* cord) {
	int* buf = {cord[0]*mat[0]+cord[1]*mat[3], cord[0]*mat[1]+cord[1]*mat[2]};
	memcpy(cord, buf, 2);
}

void setvecs() {
	for (int i=0; i<4; i++) {
		rcords[i][0] = x + cords[i][0]; // 1 & 2
		rcords[i][1] = y + cords[i][1];
		matmul(rcords[i]);
	}
}

void render() {
	setvecs();
	frender();
}

void mloop() {
	render();
}

int main() {
	write(1, hi, strlen(hi)+1);
	return 0;
}
