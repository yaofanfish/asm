#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

int readpoem(char* poem) {
	int line=0;
	FILE* f = fopen(poem, "r");
	char buf[64];
	int c = 0;
	while (fgets(buf, sizeof(buf), f) != NULL) {
		printf("%s", buf); fflush(stdout);
		if (!strcmp(buf, "\n")) {
			usleep(3000000);
		} else if (!strcmp(buf, "[PAUSE]\n")) {
			printf("\033[A\033[8G"); fflush(stdout);
			fgets(buf, 63, stdin);
			printf("\033[F\033[K\n"); fflush(stdout);
		} else {
			usleep(750000);
		}
		c++;
	}
	return c;
}

int main() {
	readpoem("poem");
	return 0;
}
