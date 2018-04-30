LIB_FLAGS=-Wno-unused-variable

all:
	$(MAKE) local

test:
	$(MAKE) local

local:
	$(MAKE) clean
	gcc usb_read_test.c -o usb_read_test.exe -L"/usr/local/lib/" -lusb-1.0
	./usb_read_test.exe
	
clean:
	rm -rf usb_read_test.exe