#include <stdio.h>
#include <sys/types.h>
#include <string.h>
#include </usr/local/include/libusb-1.0/libusb.h>

#define BULK_EP_OUT     0x82
#define BULK_EP_IN      0x02

int main(void)
{
	printf("\nInitializing...");
	
    int e = 0;
    struct libusb_device_handle *handle;
    struct libusb_device **devs;
    struct libusb_device *dev;
    struct libusb_device_descriptor* desc = malloc(sizeof(struct libusb_device_descriptor));
    char str1[256], str2[256];

    /* Init libusb */
    if (libusb_init(NULL) < 0)
    {
        printf("\nfailed to initialise libusb\n");
        return 1;
    }
	
	printf("\nInitialized.");
	
	/*
	libusb_get_device_list(NULL, &devs);
	
	for (int i = 0; devs[i]; ++i) {
		libusb_open(devs[i], &handle);
		
		libusb_get_device_descriptor(devs[i], desc);
		
		printf("\n%s", desc->idVendor);
	}*/
	
	printf("\nOpening device...");

    handle = libusb_open_device_with_vid_pid(NULL, 0x154B, 0x007A);
    if(handle == NULL)
    {
        printf("\nError in device opening!");
    }
    else
        printf("\nDevice Opened");

    // Tell libusb to use the CONFIGNUM configuration of the device
	
	printf("\nDetaching driver...");

    libusb_set_configuration(handle, 1);
    if(libusb_kernel_driver_active(handle, 0) == 1)
    {
        printf("\nKernel Driver Active");
        if(libusb_detach_kernel_driver(handle, 0) == 0)
            printf("\nKernel Driver Detached!");
    }
	
	printf("\nClaiming interface...");

    if(libusb_claim_interface(handle, 0) < 0)
    {
        printf("\nCannot Claim Interface");
    }

      /* Communicate */
	printf("\nClaimed.\nCommunicating...");

    int bytes_read;
    int nbytes = 256;
    unsigned char *my_string, *my_string1;
    int transferred = 0;
    my_string = (unsigned char *) malloc (nbytes + 1);
    my_string1 = (unsigned char *) malloc (nbytes + 1);

    strcpy(my_string, "divesd");
    printf("\nTo be sent : %s", my_string);

    e = libusb_bulk_transfer(handle, BULK_EP_OUT, my_string, bytes_read, &transferred, 5000);
    printf("\nXfer returned with %d", e);
    printf("\nSent %d bytes with string: %s\n", transferred, my_string);

    libusb_bulk_transfer(handle, BULK_EP_IN, my_string1, 256, &transferred, 5000);
    printf("\nXfer returned with %d", e);     //It returns -1... This is an error, I guess.
    printf("\nReceived %d bytes with string: %s\n", transferred, my_string1);

    e = libusb_release_interface(handle, 0);
    libusb_close(handle);
    libusb_exit(NULL);
    return 0;
}

/*
#include <w32api.h>
#include <winusb.h>
#include <tchar.h>
#include <strsafe.h>
#include <usb100.h>
#include <guiddef.h>
#include <setupapi.h>

//DEFINE_GUID(USB_GUID, 0x36FC9E60, 0xC465, 0x11CF, 0x80, 0x56, 0x44, 0x45, 0x53, 0x54, 0x00, 0x00);// "36FC9E60-C465-11CF-8056-444553540000"
GUID USB_GUID = { 0x04ACB32D, 0x9AA5, 0x4AB0, 0x80, 0x49, 0x88, 0xCD, 0x77, 0xCC, 0x8B, 0x74 };// or this?

struct usbdevinfo {
	WINUSB_INTERFACE_HANDLE winUSBHandle;
	UCHAR deviceSpeed, bulkInPipe, bulkOutPipe, interruptPipe;
};

char* deviceName;
char* devicePath;
HANDLE* deviceHandle;
HDEVINFO deviceInfo;
struct usbdevinfo* usbinfo;

BOOL GetDevicePath(LPGUID InterfaceGuid, PCHAR DevicePath, size_t BufLen) {
	BOOL bResult = FALSE;
	//HDEVINFO deviceInfo;
	SP_DEVICE_INTERFACE_DATA interfaceData;
	PSP_DEVICE_INTERFACE_DETAIL_DATA detailData = NULL;
	ULONG length;
	ULONG requiredLength=0;
	HRESULT hr;
	
	deviceInfo = SetupDiGetClassDevs(InterfaceGuid,
	NULL, NULL,
	DIGCF_PRESENT | DIGCF_DEVICEINTERFACE);
	
	interfaceData.cbSize = sizeof(SP_DEVICE_INTERFACE_DATA);
	bResult = SetupDiEnumDeviceInterfaces(deviceInfo,
	NULL,
	InterfaceGuid,
	0,
	&interfaceData);
	
	SetupDiGetDeviceInterfaceDetail(deviceInfo,
	&interfaceData,
	NULL, 0,
	&requiredLength,
	NULL);
	
	detailData = (PSP_DEVICE_INTERFACE_DETAIL_DATA)
	LocalAlloc(LMEM_FIXED, requiredLength);
	
	if(NULL == detailData) {
		SetupDiDestroyDeviceInfoList(deviceInfo);
		return FALSE;
	}
	
	detailData->cbSize = sizeof(SP_DEVICE_INTERFACE_DETAIL_DATA);
	length = requiredLength;
	
	bResult = SetupDiGetDeviceInterfaceDetail(deviceInfo,
	&interfaceData,
	detailData,
	length,
	&requiredLength,
	NULL); 
	
	if(FALSE == bResult) {
		LocalFree(detailData);
		return FALSE;
	}
	
	hr = StringCchCopy(DevicePath,
	BufLen,
	detailData->DevicePath);
	
	if(FAILED(hr)) {
		SetupDiDestroyDeviceInfoList(deviceInfo);
		LocalFree(detailData);
	}
	
	LocalFree(detailData);
	return bResult;
} 

HANDLE OpenDevice(BOOL bSync) {
	HANDLE hDev = NULL;
	
	//char devicePath[MAX_DEVPATH_LENGTH];
	
	BOOL retVal = GetDevicePath( 
	(LPGUID) &USB_GUID,
	devicePath,
	sizeof(deviceName));
	
	hDev = CreateFile(devicePath,
	GENERIC_WRITE | GENERIC_READ,
	FILE_SHARE_WRITE | FILE_SHARE_READ,
	NULL,
	OPEN_EXISTING,
	FILE_ATTRIBUTE_NORMAL | FILE_FLAG_OVERLAPPED,
	NULL);

	return hDev;
} 

BOOL Initialize_Device() {
	BOOL bResult;
	WINUSB_INTERFACE_HANDLE usbHandle;
	USB_INTERFACE_DESCRIPTOR ifaceDescriptor;
	WINUSB_PIPE_INFORMATION pipeInfo;
	UCHAR speed;
	ULONG length;
	
	deviceHandle = OpenDevice(TRUE);
	
	bResult = WinUsb_Initialize(deviceHandle, &usbHandle);
	
	if(bResult) {
		usbinfo->winUSBHandle = usbHandle;
		length = sizeof(UCHAR);
		bResult = WinUsb_QueryDeviceInformation(usbinfo->winUSBHandle,
		DEVICE_SPEED,
		&length,
		&speed);
	}
	
	if(bResult) {
		usbinfo->deviceSpeed = speed;
		bResult = WinUsb_QueryInterfaceSettings(usbinfo->winUSBHandle,
		0,
		&ifaceDescriptor);
	}
	
	if(bResult) {
		for(int i=0;i<ifaceDescriptor.bNumEndpoints;i++) {
			bResult = WinUsb_QueryPipe(usbinfo->winUSBHandle,
			0,
			(UCHAR) i,
			&pipeInfo);
			
			if(pipeInfo.PipeType == UsbdPipeTypeBulk &&
			USB_ENDPOINT_DIRECTION_IN(pipeInfo.PipeId)) {
				usbinfo->bulkInPipe = pipeInfo.PipeId;
			}
			else if(pipeInfo.PipeType == UsbdPipeTypeBulk &&
			USB_ENDPOINT_DIRECTION_OUT(pipeInfo.PipeId)) {
				usbinfo->bulkOutPipe = pipeInfo.PipeId;
			}
			else if(pipeInfo.PipeType == UsbdPipeTypeInterrupt) {
				usbinfo->interruptPipe = pipeInfo.PipeId;
			}
			else {
				bResult = FALSE;
				break;
			}
		}
	}
	
	return bResult;
} 

BOOL WriteToDevice(HWND hwnd) {
	USHORT bufSize = 12;
	UCHAR szBuffer[12];
	BOOL bResult;
	ULONG bytesWritten;

	SendMessage(hwnd, EM_GETLINE, 0, (LPARAM) szBuffer);

	bResult = WinUsb_WritePipe(usbinfo->winUSBHandle,
	usbinfo->bulkOutPipe,
	szBuffer,
	24,
	&bytesWritten,
	NULL);

	return bResult;
} 

BOOL ReadFromDevice(HWND hwnd) {
	USHORT bufSize = 12;
	UCHAR szBuffer[12];
	BOOL bResult;
	ULONG bytesRead;
	
	bResult = WinUsb_ReadPipe(usbinfo->winUSBHandle,
	usbinfo->bulkInPipe,
	szBuffer,
	24,
	&bytesRead,
	NULL);
	
	SendMessage(hwnd, WM_SETTEXT, 0, (LPARAM) szBuffer);
	
	return bResult;
} 

int main() {
	deviceName = "";//TODO
}
*/