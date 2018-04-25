<h1>Cerebroimagini</h1>

A low-cost implementation of functional Near InfraRed (fNIR) spectroscopy with the specific purpose
of brain mapping.

<h3>Usage</h3>

TODO

<h3>FPGA</h3>

The FPGA is used for fast DSP functionality on a per-sensor basis. This allows us to transmit data
to the microprocessor for each sensor that is already prepared for packetization.

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

<h3>STM32F411E Discovery</h3>

The discovery board gathers all sensor readings through a custom interface designed specifically for the
sensor. Once the data is read, it gets packetized and transmitted to a USB2.0 interface directly to the
user system.

TODO
...

<h3>Wave UI</h3>

The custom UI reads and displays the USB2.0 output of the discovery board.

TODO
...

<h3>Credits</h3>
<ul>
<li><b>DIT FFT:</b> https://github.com/benreynwar/fft-dit-fpga
</ul>

...incomplete
