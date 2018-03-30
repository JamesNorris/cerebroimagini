<h1>FPGA</h1>

This directory contains all the verilog code that will be running on the FPGA. The purpose of this code is to 
implement all DSP necessary to aquire the mixed sensor intensity at 730nm and 850nm. This is acomplished by 
passing the raw ADC output for each sensor detector through an FFT and filtering the frequency-domaine signal 
to read each signal seperately. The intensity of the 730nm emitted light and 850nm emmited light is then 
gathered and outputted to the microprocessor.

<h3>Dependancies</h3>
TODO

<h3>Compilation</h3>
TODO

<h3>Uploading to the Processor</h3>
TODO

<h3>And more...</h3>
TODO

