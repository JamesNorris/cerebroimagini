CEREBROIMAGINI
--------------

A low-cost implementation of functional Near InfraRed (fNIR) spectroscopy with the specific purpose
of brain mapping.

USAGE:

FPGA:

1) Download Intel Quartus Prime Lite (QPL) edition
2) Using QPL, open:
	/fpga/CerebroImagini.qpf

...compile, JTAG programmer

There are a few notable modifications which can affect the speed/accuracy tradeoff:

1) The length of the radix-2^N DIT FFT vector
	- Increasing the length provides higher frequency resolution but also increases the buffer times
	- Increasing the length takes a higher number of logic elements on the FPGA

...

CREDITS:

DIT FFT: https://github.com/benreynwar/fft-dit-fpga

...incomplete