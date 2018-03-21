/*
radix-2 DIT FFT twiddle coefficient calculator

TO RUN: ./<executable> <# samples>

CREATED BY: James C. Norris
*/

#include <stdio.h>
#include <stdlib.h>
//#include <string.h>
//#include <inttypes.h>
#include <math.h>

double _log2(double d) {
	return (log(d) / log(2));
}

int trim_to_bits(int x, int bits) {
	int and_bits = 0;
	for (int i = 0; i < bits; i++) {
		and_bits = (and_bits << 1) | 1;
	}
	return x & and_bits;
}

int bit_rev_op(int x, int bits) {
	x = trim_to_bits(x, bits);
	
	int out = 0;
	for (int i = 0; i < bits; i++) {
		out = out << 1;
		
		int bit = (x >> i) & 1;
		
		out = out | bit;
	}
	return out/* >> (32 - bits)*/; // realign bits to LSBs;
}

int main(int argc, char* argv[]) {
	int N = atoi(argv[1]);
	int stages = _log2((double) N + 1 /* +1 to avoid precision bug */);
	int factors = N / 2;
	int bits = stages - 1;
	
	printf("...\nFinding twiddle coefficients for:\nSAMPLES(N)=%i\nSTAGES(Pmax)=%i\
	\nFACTORS(kmax)=%i\nBITS_PER_FACTOR=%i\n...\n", N, stages, factors, bits);
	
	for (double P = 1; P <= stages; P++) {
		for (double k = 0; k < factors; k++) {
			
			int t = bit_rev_op((int /* integer floor */) (k * pow(2, P)) / N, bits);
			
			printf("T(P:%i, k:%i) = %li\n", (int) P, (int) k, t);
			
		}
	}
	
	return 0;
}