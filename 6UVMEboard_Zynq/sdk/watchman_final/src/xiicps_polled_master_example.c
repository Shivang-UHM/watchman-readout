/******************************************************************************
* Copyright (C) 2010 - 2020 Xilinx, Inc.  All rights reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/

/*****************************************************************************/
/**
* @file xiicps_polled_master_example.c
*
* A design example of using the device in polled mode as master.
*
* The example uses buffer size 132. Please set the send buffer of the
* Aardvark device to be continuous 64 bytes from 0x00 to 0x3F.
 *
 * <pre> MODIFICATION HISTORY:
 *
 * Ver   Who Date     Changes
 * ----- --- -------- -----------------------------------------------
 * 1.00a jz  01/30/10 First release
 *
 * </pre>
 *
 ****************************************************************************/

/***************************** Include Files **********************************/
#include "xparameters.h"
#include "xiicps.h"
#include "xil_printf.h"

/************************** Constant Definitions ******************************/

/*
 * The following constants map to the XPAR parameters created in the
 * xparameters.h file. They are defined here such that a user can easily
 * change all the needed parameters in one place.
 */
#define IIC_DEVICE_ID		XPAR_XIICPS_0_DEVICE_ID

/*
 * The slave address to send to and receive from.
 */
#define IIC_SLAVE_ADDR		0x10
#define IIC_SCLK_RATE		400000

/*
 * The following constant controls the length of the buffers to be sent
 * and received with the IIC.
 */
#define TEST_BUFFER_SIZE	3

/**************************** Type Definitions ********************************/


/************************** Function Prototypes *******************************/

int IicPsMasterPolledExample(u16 DeviceId);
int iicps_example(void);
/************************** Variable Definitions ******************************/

XIicPs Iic;		/**< Instance of the IIC Device */

/*
 * The following buffers are used in this example to send and receive data
 * with the IIC.
 */
u8 SendBuffer[TEST_BUFFER_SIZE];    /**< Buffer for Transmitting Data */
u8 RecvBuffer[TEST_BUFFER_SIZE];    /**< Buffer for Receiving Data */


/******************************************************************************/
/**
*
* Main function to call the polled master example.
*
* @param	None.
*
* @return	XST_SUCCESS if successful, XST_FAILURE if unsuccessful.
*
* @note		None.
*
*******************************************************************************/
int iicps_example(void)
{
	int Status;

	xil_printf("IIC Master Polled Example Test \r\n");

	/*
	 * Run the Iic polled example in master mode, specify the Device
	 * ID that is specified in xparameters.h.
	 */
	Status = IicPsMasterPolledExample(IIC_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		xil_printf("IIC Master Polled Example Test Failed\r\n");
		return XST_FAILURE;
	}

	xil_printf("Successfully ran IIC Master Polled Example Test\r\n");
	return XST_SUCCESS;
}

/*****************************************************************************/
/**
*
* This function sends data and expects to receive data from slave as modular
* of 64.
*
* This function uses interrupt-driven mode of the device.
*
* @param	DeviceId is the Device ID of the IicPs Device and is the
*		XPAR_<IICPS_instance>_DEVICE_ID value from xparameters.h
*
* @return	XST_SUCCESS if successful, otherwise XST_FAILURE.
*
* @note		None.
*
*******************************************************************************/
int IicPsMasterPolledExample(u16 DeviceId)
{
	int Status;
	XIicPs_Config *Config;
	int Index;

	/*
	 * Initialize the IIC driver so that it's ready to use
	 * Look up the configuration in the config table,
	 * then initialize it.
	 */
	Config = XIicPs_LookupConfig(DeviceId);
	if (NULL == Config) {
		xil_printf("lookup failed\r\n");
		return XST_FAILURE;

	}

	Status = XIicPs_CfgInitialize(&Iic, Config, Config->BaseAddress);
	if (Status != XST_SUCCESS) {
		xil_printf("init failed\r\n");
		return XST_FAILURE;

	}

	/*
	 * Perform a self-test to ensure that the hardware was built correctly.
	 */
	Status = XIicPs_SelfTest(&Iic);
	if (Status != XST_SUCCESS) {
		xil_printf("Selftest failed\r\n");
		return XST_FAILURE;

	}

	/*
	 * Set the IIC serial clock rate.
	 */
	XIicPs_SetSClk(&Iic, IIC_SCLK_RATE);

	/*
	 * Initialize the send buffer bytes with a pattern to send and the
	 * the receive buffer bytes to zero to allow the receive data to be
	 * verified.
	 */
	int voltage =1.7;
	int intvolt = (int)(65536.0 * voltage / 2.5);
	SendBuffer[0] = 0x30 | 0x07;	// 0x30 command to write and update | channel is channel
	SendBuffer[1] = intvolt>>8;	//0b10000000; // MSB First
	SendBuffer[2] = intvolt & 0x00FF;	//0b00000000; // LSB Last

//	for (Index = 0; Index < TEST_BUFFER_SIZE; Index++) {
//		SendBuffer[Index] = (Index % TEST_BUFFER_SIZE);
//		RecvBuffer[Index] = 0;
//	}

	/*
	 * Send the buffer using the IIC and ignore the number of bytes sent
	 * as the return value since we are using it in interrupt mode.
	 */
	Status = XIicPs_MasterSendPolled(&Iic, SendBuffer,TEST_BUFFER_SIZE, IIC_SLAVE_ADDR);
	if (Status != XST_SUCCESS) {
		xil_printf("sendPolled failed\r\n");
		return XST_FAILURE;

	}

	/*
	 * Wait until bus is idle to start another transfer.
	 */
	while (XIicPs_BusIsBusy(&Iic)) {
		/* NOP */
	}

//	Status = XIicPs_MasterRecvPolled(&Iic, RecvBuffer,
//			  TEST_BUFFER_SIZE, IIC_SLAVE_ADDR);
//	if (Status != XST_SUCCESS) {
//		return XST_FAILURE;
//	}
//
//	/*
//	 * Verify received data is correct.
//	 */
//	 for(Index = 0; Index < TEST_BUFFER_SIZE; Index ++) {
//
//		/* Aardvark as slave can only set 64 bytes for output */
//		if (RecvBuffer[Index] != Index % 64) {
//			return XST_FAILURE;
//		}
//	}

	return XST_SUCCESS;
}
