SAMPLES=16
FREQ=.0625#1/16
SIZE=12
AMPLITUDE=100

all:
	gcc sine_gen.c -o sine_gen.exe
	./sine_gen.exe $(SAMPLES) $(FREQ) $(SIZE) $(AMPLITUDE)

clean:
	rm -rf sine_gen.exe