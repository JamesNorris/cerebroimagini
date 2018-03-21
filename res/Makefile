WIDTH=64 # samples used in fft

radix_2_DIT:
	gcc r2dit_fft_twiddle_calc.c -o r2dit_fft_twiddle_calc.exe
	./r2dit_fft_twiddle_calc.exe $(WIDTH)

radix_4_DIF:
	gcc r4dif_fft_twiddle_calc.c -o r4dif_fft_twiddle_calc.exe
	./r4dif_fft_twiddle_calc.exe $(WIDTH)

clean:
	rm -rf r2dit_fft_twiddle_calc.exe