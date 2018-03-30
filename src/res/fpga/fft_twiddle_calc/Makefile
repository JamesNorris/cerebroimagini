WIDTH=32 # samples used in fft
RADIX=2 

all:
	gcc fft_twiddle_calc.c -o dif_twiddle_calc.exe
	./fft_twiddle_calc.exe $(WIDTH) $(RADIX)

clean:
	rm -rf fft_twiddle_calc.exe