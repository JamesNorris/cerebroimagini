<h1>Cerebroimagini</h1>

A low-cost implementation of functional Near InfraRed (fNIR) spectroscopy with the specific purpose
of brain mapping.

<h3>Usage</h3>

<h3>FPGA</h3>

<ol>
<li> Download Intel Quartus Prime Lite (QPL) edition
<li> Using QPL, open:	/fpga/CerebroImagini.qpf
</ol>
...compile, JTAG programmer

There are a few notable modifications which can affect the speed/accuracy tradeoff:

<ol>
<li> The length of the radix-2^N DIT FFT vector
	<ul>
	<li> Increasing the length provides higher frequency resolution but also increases the buffer times
	<li> Increasing the length takes a higher number of logic elements on the FPGA
	</ul>
</ol>
...

<h3>Credits</h3>

<b>DIT FFT:</b> https://github.com/benreynwar/fft-dit-fpga

...incomplete
