#include <stdio.h>

//#include "stm32f4xx.h"                  // Device header
#include "stm32f4xx_hal.h"              // Keil::Device:STM32Cube HAL:Common
//#include "stm32f4xx_hal_conf.h"         // Keil::Device:STM32Cube Framework:Classic

#define EP_ADDR 0
#define EP_MPS 16
#define EP_TYPE 0

PCD_HandleTypeDef hpcd;

int main() {
	HAL_Init();
	
	hpcd.Init = (PCD_InitTypeDef) {
		.battery_charging_enable = 1,
		.dev_endpoints = 1,
		.ep0_mps = EP_MPS,
		.low_power_enable = 0,
		.lpm_enable = 1,
		.phy_itface = PCD_PHY_EMBEDDED,
		.Sof_enable = 1,
		.speed = PCD_SPEED_FULL
	};
	
	HAL_PCD_Init(&hpcd);
	__HAL_RCC_USB_OTG_FS_CLK_ENABLE();
	HAL_PCD_EP_Open(&hpcd, EP_ADDR, EP_MPS, EP_TYPE);
	HAL_PCD_Start(&hpcd);
	
	uint8_t buf[12];
	
	//test for TxR
	while(1) {
		HAL_PCD_EP_Receive(&hpcd, EP_ADDR, buf, 12);
		while(buf[0] == '\0') {
			//wait
		}
		printf("%s\n", buf);
		HAL_PCD_EP_Transmit(&hpcd, EP_ADDR, buf, 12);
	}
}
