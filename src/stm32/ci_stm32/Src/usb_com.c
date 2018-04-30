#include "usb_com.h"

GPIO_InitTypeDef gpio;

int is_empty_buf(uint8_t* buf, int size) {
	for (int i = 0; i < size; i++) {
		if (buf[i] != 0) return 0;
	}
	
	return 1;
}

void runTxR(PCD_HandleTypeDef* hpcd) {
	led_init();
	
	HAL_GPIO_TogglePin(GPIOD, GPIO_PIN_15);
	
	uint8_t buf[DATA_SIZE];
	
	//uint8_t test[] = {'t', 'e', 's', 't', 'i', 'n', 'g', '\n', '-', '-', '-', '-'};
	
	usb_connect(hpcd);
	
	//test for TxR
	while(1) {
		//rcv
		HAL_PCD_EP_Receive(hpcd, 0, buf, DATA_SIZE);
		//if bytes rcvd, set pin 14
		HAL_GPIO_WritePin(GPIOD, GPIO_PIN_14, (is_empty_buf(&buf[0], DATA_SIZE) ? GPIO_PIN_RESET : GPIO_PIN_SET));
		//transmit
		HAL_PCD_EP_Transmit(hpcd, 0, buf, DATA_SIZE);
		//toggle pin 15
		HAL_GPIO_TogglePin(GPIOD, GPIO_PIN_15);
		HAL_Delay(1000);
	}
}

void led_init(void) {
	__GPIOD_CLK_ENABLE();
	gpio.Pin = GPIO_PIN_All;
	gpio.Mode = GPIO_MODE_OUTPUT_PP;
	gpio.Pull = GPIO_PULLUP;
	gpio.Speed = GPIO_SPEED_HIGH;
	HAL_GPIO_Init(GPIOD, &gpio);
}

void usb_connect(PCD_HandleTypeDef* hpcd) {
	HAL_PCD_DevConnect(hpcd);
	
	HAL_PCD_EP_Open(hpcd, 0, EP_MPS, 0);
	
	HAL_PCD_EP_Transmit(hpcd, 0, DESCRIPTOR, DESCRIPTOR_SIZE);
	//HAL_PCD_EP_Flush(hpcd, 0);
	HAL_Delay(1000);
}
