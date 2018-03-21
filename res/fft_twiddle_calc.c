/*
FFT twiddle coefficient calculator

TO RUN: ./<executable> <# samples> <integer radix>

CREATED BY: James C. Norris
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define PI 3.14159265359

int main(int argc, char* argv[]) {
	int N = atoi(argv[1]);
	int radix = atoi(argv[2]);
	
	printf("...\nFinding twiddle coefficients for:\nRADIX=%i\nSAMPLES(N)=%i\n...\n", radix, N);
	
	for (double k = 0; k < N; k++) {
		for (double n = 0; n < N; n++) {
			
			double phase = 2 * PI * (k * n) / radix;
			
			int real = (int) cos(phase);
			int imag = (int) -sin(phase);
			
			printf("T(k:%i, n:%i) = %i + %ij\n", (int) k, (int) n, real, imag);
			
		}
	}
	
	return 0;
}