/*
radix-4 DIF FFT twiddle coefficient calculator

TO RUN: ./<executable> <# samples>

CREATED BY: James C. Norris
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define PI 3.14159265359

int main(int argc, char* argv[]) {
	int N = atoi(argv[1]);
	
	printf("...\nFinding twiddle coefficients for:\nSAMPLES(N)=%i\n...\n", N);
	
	for (double k = 0; k < N; k++) {
		for (double n = 0; n < N; n++) {
			
			double phase = 2 * PI * (k * n) / N;
			
			int real = (int) cos(phase);
			int imag = (int) -sin(phase);
			
			printf("T(k:%i, n:%i) = %i + %ij\n", (int) k, (int) n, real, imag);
			
		}
	}
	
	return 0;
}