/*
radix-4 DIF FFT twiddle coefficient calculator

TO RUN: ./<executable> <# samples>

CREATED BY: James C. Norris
*/

#include <stdio.h>
#include <stdlib.h>
//#include <string.h>
//#include <inttypes.h>
#include <math.h>

#define PI 3.14159265359

struct complex {
	int real, imag;
};

double _log4(double d) {
	return (log(d) / log(4));
}

struct complex* calc(double k, double n, int N) {
	struct complex* c = malloc(sizeof(struct complex));
	
	double phase = 2 * PI * (k * n) / N;
	
	c->real = (int) cos(phase);
	c->imag = (int) -sin(phase);
	
	return c;
}

int main(int argc, char* argv[]) {
	int N = atoi(argv[1]);
	int stages = _log4((double) N + 1 /* +1 to avoid precision bug */);
	int factors = N / 4;
	
	printf("...\nFinding twiddle coefficients for:\nSAMPLES(N)=%i\nSTAGES(Pmax)=%i\
	\nFACTORS(kmax)=%i\n...\n", N, stages, factors);
	
	for (double k = 0; k < factors; k++) {
		for (double n = 0; n < N; n++) {
			
			struct complex* c = calc(k, n, N);
			
			printf("T(k:%i, n:%i) = %i + %ij\n", (int) k, (int) n, c->real, c->imag);
			
		}
	}
	
	return 0;
}