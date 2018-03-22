SAMPLES=16
FREQ=16.0#6.28318530718#2pi
SIZE=12
AMPLITUDE=100

all:
	gcc sin_gen.c -o sin_gen.exe
	./sin_gen.exe $(SAMPLES) $(FREQ) $(SIZE) $(AMPLITUDE)

clean:
	rm -rf sin_gen.exe