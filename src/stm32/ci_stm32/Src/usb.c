/*

#include <stdio.h>
#include <stdlib.h>

#include "stm32f4xx.h"                  // Device header
#include "stm32f4xx_hal.h"              // Keil::Device:STM32Cube HAL:Common

#define EP_ADDR 0
#define EP_MPS DEP0CTL_MPS_64
#define EP_TYPE 0

GPIO_InitTypeDef gpio;
PCD_HandleTypeDef hpcd;

//initialization functions
void SystemClock_Config(void);
void led_init(void);
void pcd_init(void);

//utility
int is_empty_buf(uint8_t* buf, int size) {
	for (int i = 0; i < size; i++) {
		if (buf[i] != 0) return 0;
	}
	
	return 1;
}

void pcd_connect(void);

void runTxR(void);

//the systick handler required for HAL_Dela() operation
void SysTick_Handler(void) {
	HAL_IncTick();
}

int main() {
	HAL_Init();
	SystemClock_Config();
	led_init();
	
	HAL_GPIO_TogglePin(GPIOD, GPIO_PIN_15);
	
	pcd_init();
	
	pcd_connect();
	
	runTxR();
}

void runTxR(void) {
	uint8_t buf[12];
	
	//uint8_t test[] = {'t', 'e', 's', 't', 'i', 'n', 'g', '\n', '-', '-', '-', '-'};
	
	//test for TxR
	while(1) {
		//rcv
		HAL_PCD_EP_Receive(&hpcd, EP_ADDR, buf, 12);
		//if bytes rcvd, set pin 14
		//HAL_GPIO_SetPin(GPIOD, GPIO_PIN_14, is_empty_buf(buf, 12) ? GPIO_PIN_RESET : GPIO_PIN_SET);
		//transmit
		HAL_PCD_EP_Transmit(&hpcd, EP_ADDR, buf, 12);
		//toggle pin 15
		HAL_GPIO_TogglePin(GPIOD, GPIO_PIN_15);
		HAL_Delay(100);
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

void pcd_init(void) {
	//HAL_NVIC_SetPriority(USB_IRQn, 0, 0);
    //HAL_NVIC_EnableIRQ(USB_IRQn); 
	
	__HAL_RCC_USB_OTG_FS_CLK_ENABLE();
	
	hpcd.Instance = USB_OTG_FS;
	
	hpcd.Init = (PCD_InitTypeDef) {
		.battery_charging_enable = 1,
		.dev_endpoints = 1,
		.ep0_mps = EP_MPS,
		.low_power_enable = 0,
		.lpm_enable = 1,
		.phy_itface = PCD_PHY_EMBEDDED,
		.Sof_enable = 0,
		.speed = PCD_SPEED_FULL,
		.vbus_sensing_enable = 1
	};
	
	HAL_PCD_Init(&hpcd);
	
	//hpcd.pData = (void*) 0x00001000;//upper stack?
	
	HAL_PCD_Start(&hpcd);
}

void pcd_connect(void) {
	HAL_PCD_EP_Open(&hpcd, EP_ADDR, EP_MPS, EP_TYPE);
	HAL_PCD_DevConnect(&hpcd);
}

void SystemClock_Config(void) {
  RCC_ClkInitTypeDef RCC_ClkInitStruct;
  RCC_OscInitTypeDef RCC_OscInitStruct;

  // Enable Power Control clock
  __PWR_CLK_ENABLE();

  // The voltage scaling allows optimizing the power consumption when the
  // device is clocked below the maximum system frequency, to update the
  // voltage scaling value regarding system frequency refer to product
  // datasheet.
  __HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE1);

  // Enable HSE Oscillator and activate PLL with HSE as source
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSI | RCC_OSCILLATORTYPE_HSE;
  RCC_OscInitStruct.HSEState = RCC_HSE_ON;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;

  // This assumes the HSE_VALUE is a multiple of 1MHz. If this is not
  // your case, you have to recompute these PLL constants.
  RCC_OscInitStruct.PLL.PLLM = (HSE_VALUE/1000000u);
  RCC_OscInitStruct.PLL.PLLN = 336;
  RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV2;
  RCC_OscInitStruct.PLL.PLLQ = 7;
  HAL_RCC_OscConfig(&RCC_OscInitStruct);

  // Select PLL as system clock source and configure the HCLK, PCLK1 and PCLK2
  // clocks dividers
  RCC_ClkInitStruct.ClockType = (RCC_CLOCKTYPE_SYSCLK | RCC_CLOCKTYPE_HCLK
      | RCC_CLOCKTYPE_PCLK1 | RCC_CLOCKTYPE_PCLK2);
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV4;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV2;
  HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_5);
}

*/
