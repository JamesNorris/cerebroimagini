/*
sine wave values generator

TO RUN: ./<executable> <# samples (int)> <frequency (float)> <# bits per sample (int, 32 max)> <amplitude (int)>

CREATED BY: James C. Norris

Please note that accuracy will be lost at higher data sizes.
*/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <math.h>

#define PI 3.14159265359

int main(int argc, char* argv[]) {
	int N = atoi(argv[1]);
	float freq = atof(argv[2]);
	int size = atoi(argv[3]);
	int A = atoi(argv[4]);
	
	printf("...\nGenerating sine wave for:\nSAMPLES=%i\nFREQUENCY=%f\nSIZE=%i\nAMPLITUDE=%i\n...\n", N, freq, size, A);
	
	int buffer[N];//create buffer of N samples
	
	for (int i = 0; i < N; i++) {
		buffer[i] = (int) (sin(2 * PI * i * freq) * A);
	}
	
	int mask = 0;
	
	for (int i = 0; i < size; i++) {
		mask = (mask << 1) | 1;
	}
	
	printf("BITMASK=0x%x\n...\n", mask);
	
	for (int i = 0; i < N; i++) {
		int buf = buffer[i];
		int sign = 1;
		
		if (buf < 0) {
			sign = -1;
			buf *= -1;//make positive
		}
		
		int masked = buf & mask;
		
		printf("%i: in_x = %i;\n", i, (masked * sign));
	}
	
	return 0;
}