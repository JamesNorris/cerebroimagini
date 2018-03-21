CEREBROIMAGINI
--------------

A low-cost implementation of functional Near InfraRed (fNIR) specroscopy with the specific purpose
of brain mapping.

USAGE:

FPGA:

1) Download Intel Quartus Prime Lite (QPL) edition
2) Using QPL, open the CerebroImagini.qpf file found in:
	/fpga/
3) Build
4) Program FPGA using JTAG

There are a few notable modifications which can affect the speed/accuracy tradeoff:

1) The length of the radix-2 DIT FFT vector
	- Increasing the length provides higher accuracy but slows the initial wait
	- Increasing the length takes a higher number of logic elements on the FPGA

...

CREDITS:

DIT FFT: https://github.com/benreynwar/fft-dit-fpga

...incomplete