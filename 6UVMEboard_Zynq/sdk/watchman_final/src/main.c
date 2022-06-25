
/**
 * @file 	main.c
 * @author	Anthony Schluchin
 * @date	16th November 2018
 * @version 0.0
 */

#include <stdint.h>
#include "lwip/init.h"
#include "netif/xadapter.h"
#include "platform_config.h"
#include "xparameters.h"
#include "udp_peripheral.h"
#include "axis_peripheral.h"
#include "file_hm.h"
#include "global.h"
//#include "iic_DAC_LTC2657.h"
#include "pedestal.h"
#include "xscuwdt.h"
//#include "xiicps.h"
#include "get_15_windows.h"
#include "get_transfer_fct.h"
#include "transfer_function.h"
#include "xtime_l.h"
#include "data_analysis.h"
#include "I2C_bit_banging.h"
#include "gpio_ctrl.h"
//#include "gpio_ctrl.h"
/**************** External global variables ****************/
/*********************************************************/
/** @brief Pointer on the network interface */
extern struct netif *echo_netif;
/** @brief Flag reset when the user send the command "stop uC" */
extern volatile bool run_flag;
/** @brief Flag raised when the user send the command "start streaming" */
extern volatile bool stream_flag;
/** @brief Flag raised when the Triple Timer Counter overflows */
extern volatile bool flag_ttcps_timer;
/** @brief Flag raised when the SCU timer overflows*/
extern volatile bool flag_scu_timer;
/** @brief Flag raised when AXI-DMA has an error */
extern volatile bool flag_axidma_error;
/** @brief Instance of the device watchdog */
extern XScuWdt WdtScuInstance;
/** @brief Flag raised when the program has entered the while loop */
extern volatile bool flag_while_loop;
/** @brief Array of flag, one for each PMT */
extern int flag_axidma_rx[4];
/** @brief Array containing registers of AXI-lite */
extern int *regptr;
/** @brief Flag raised when the user send the command "get transfer function" */
extern volatile bool get_transfer_fct_flag;
/** @brief Flag raised when the user send the command "get windows" */
extern volatile bool get_windows_flag;

/** @brief Flag raised when the user send the command "get windows raw data" */
extern volatile bool get_windows_raw_flag;

extern volatile bool restart_flag;

/** @brief Flag raised when a pedestal value is required by the user */
extern volatile bool pedestal_flag;

/** @brief Flag true when the list is empty (first_element = last_element) */
extern volatile bool empty_flag;
/** @brief Pointer on the first element of the list used in trigger mode */
extern data_list *first_element;
/** @brief Flag raised when AXI-DMA has finished an transfer, in OnDemand mode */
extern volatile bool flag_axidma_rx_done;
//******** To test the error detection********************/
/** @brief Flag raised when the user want to test the autonomous side of the system with a watchdog */
extern volatile bool simul_err_watchdog_flag;
/** @brief Flag raised when the user want to test the autonomous side of the system */
extern volatile bool simul_err_function_prob_flag;
/** @brief Flag raised when the user want to test the autonomous side of the system with a exception */
extern volatile bool simul_err_exception_flag;
/** @brief Flag raised when the user want to test the autonomous side of the system with a assertion */
extern volatile bool simul_err_assertion_flag;
/** @brief UDP Protocol Control Block for command communication */
/** @brief Flag raised for UDP connection restart */
extern volatile bool restart_UDP_flag;

extern struct udp_pcb *pcb_cmd;
/** @brief Buffer structure used to send command packet */
extern struct pbuf *buf_cmd;

/** Number of iterations for the average in pedestal calculation**/
extern int pedestalAvg;

/** Value from the GUI for the number of windows for pedestal calculation   */
extern int nmbrWindowsPed;
///** Value from the GUI for voltage value for comparators and vped  */
// extern int VPED_ANALOG;

/** @brief Buffer used to send the data (50 bytes above it reserved for protocol header) */
extern char *frame_buf;

/* data structure from PL */
extern InboundRingManager_t inboundRingManager;

/** Flag to start pedestal mode pedestal acquisition */
extern bool pedestalTriggerModeFlag;

/**number of average for pedestals in trigger mode*/
extern int nbr_avg_ped_triggerMode;
/** Flag to start division by  nbr_avg_ped_triggerMode */
extern bool dividePedestalsFlag;

extern int *regptr_0;

extern int *regptr_1;

extern uint32_t pedestal_0[512][32][32];
extern XAxiDma AxiDmaInstance;
/*********************** Global variables ****************/
/*********************************************************/
/** @brief Network interface */
static struct netif server_netif;

/*** Type definition *************************************************/
/*********************************************************************/
/**
 * @brief This is the enumeration of the process to stop when exiting the program
 */
typedef enum clean_state_enum
{
	GLOBAL_VAR = 0x1, /**< Free the global variable reserved in function init_global_var */
	LOG_FILE = 0x2,	  /**< From this step, problem can be logged */
	INTERRUPT = 0x4,  /**< Stop the interrupt */
	UDP = 0x8,		  /**< Close both of the UDP communications */
} clean_state_en;
/**
 * @brief This is the enumeration of the state machine
 */
typedef enum dma_stm_enum
{
	IDLE,			  /**< No data to send, waiting on a command */
	STREAM,			  /**< System in mode streaming */
	GET_TRANSFER_FCT, /**< System sending the data for the transfer function in response to the corresponding command */
	GET_WINDOWS,	  /**< System sending the data of consecutive windows in response to the corresponding command */
	GET_PEDESTAL,	  /**< System getting the pedestal for an specific voltage and nmbr of windows, data saved into the pedestal variable */
	GET_WINDOWS_RAW,  /**< System getting the pedestal for an specific voltage and nmbr of windows, dat */
	DIVIDE_PEDESTALS,
	RESTART, /**< Restart main() */
} dma_stm_en;

/*** Function prototypes *********************************************/
void end_main(clean_state_en, char *error_txt);
void updateInboundCircBuffer();
void restart(void);
void setupDACs(void);
void testPattern(int *regptr);
void SDcardAndFiles(void);
void networkInterface(void);
void setPCaddress(void);
void initPedestals(void);
void initTARGETregisters(int *regptr);
void transferFunctionInit(void);

__attribute__((section(".ps7_ddr_0"))) data_axi DDR_incoming_waveform_ring_buffer[INBOUND_RING_BUFFER_LENGTH_IN_PACKETS];

void clearInboundBuffer(void)
{
	// memset( (void *) DDR_incoming_waveform_ring_buffer, 0, MAX_INBOUND_PACKET_BYTES  * INBOUND_RING_BUFFER_LENGTH_IN_PACKETS );
}

void init_FPGA()
{

	disable_interrupts();
	/* now enable interrupts */
	enable_interrupts();
}

int init_ASIC()
{
	GetTargetCStatus(regptr_0);
	GetTargetCControl(regptr_0);
	setupDACs();
	initTARGETregisters(regptr_0);
	printf("after INIT\r\n");

	GetTargetCStatus(regptr_0);

	GetTargetCControl(regptr_0);

	// Waiting on PL's clocks to be ready
	while ((regptr_0[TC_STATUS_REG] & LOCKED_MASK) != LOCKED_MASK)
	{
		sleep(1);
	}
	printf("after LOCKEDmask\r\n");

	GetTargetCStatus(regptr_0);

	GetTargetCControl(regptr_0);

	printf("PL's clock ready\r\n");

	SetTargetCRegisters(regptr_0);

	printf("sleep to set the debug core\r\n");
	GetTargetCStatus(regptr_0);

	GetTargetCControl(regptr_0);

	//testPattern(regptr_0);
}

void init_software()
{
	Xil_DCacheDisable();
}

int loop()
{
	flag_while_loop = true;
	dma_stm_en state_main = IDLE;
	//	pedestal_triggerMode_init();
	usleep(100);
	int pedestal_Avg = 100;
	int nmbr_Windows_Ped = 1;

	while (run_flag)
	{
		/* Simulate a infinity loop to trigger the watchdog  */

		if (flag_axidma_error)
		{
			end_main(GLOBAL_VAR | LOG_FILE | INTERRUPT | UDP, "AXI-DMA failed!");
			return -1;
		}
		switch (state_main)
		{
		case IDLE:
			if (stream_flag)
			{
				xil_printf("From IDLE to STREAM \n");

				state_main = STREAM;
			}

			break;
		case STREAM:
			if ((!stream_flag))
			{
				xil_printf("if ((!stream_flag)) \r\n");
				usleep(100);
				ControlRegisterWrite(SWRESET_MASK, DISABLE, regptr_0);
				ControlRegisterWrite(SWRESET_MASK, ENABLE, regptr_0);

				usleep(100);
				state_main = IDLE;
			}

			ControlRegisterWrite(SMODE_MASK, ENABLE, regptr_0); // mode for selecting the interrupt, 1 for dma
			usleep(100);

			ControlRegisterWrite(SS_TPG_MASK, ENABLE, regptr_0); // 0 for test pattern mode, 1 for sample mode (normal mode)
			usleep(100);

			ControlRegisterWrite(CPUMODE_MASK, ENABLE, regptr_0); // mode trigger, 0 for usermode (cpu mode), 1 for trigger mode

			usleep(100);

			xil_printf("flag_axidma_rx_done= %d \r\n", flag_axidma_rx_done);
			usleep(100);

			inboundRingManager.writePointer = DDR_incoming_waveform_ring_buffer;
			inboundRingManager.procPointer = inboundRingManager.writePointer;
			inboundRingManager.firstAllowedPointer = inboundRingManager.writePointer;
			inboundRingManager.lastAllowedPointer = inboundRingManager.writePointer + (INBOUND_RING_BUFFER_LENGTH_IN_PACKETS - 1);
			PrintInboundRingStatus(inboundRingManager);

			printf("after inboundRingManager init \r\n");
			usleep(100);

			XAxiDma_SimpleTransfer_hm((UINTPTR)inboundRingManager.writePointer, SIZE_DATA_ARRAY_BYT);
			usleep(100);

			triggerMode(ENABLE);

			Xil_DCacheInvalidateRange((UINTPTR)inboundRingManager.writePointer, SIZE_DATA_ARRAY_BYT);
			usleep(100);
			xil_printf(" pendingCountBefore: %d \r\n", inboundRingManager.pendingCount);
			usleep(100);
			printf("after inboundRingManager print, starting while loop \r\n");
			usleep(100);
			int i = 0;
			int trigger_freq = 10000;
			bool trigger_flag;
			//	 XTime_GetTime(&tStart);
			while (stream_flag)
			{
				if (inboundRingManager.pendingCount > 0)
				{
					if (pedestalTriggerModeFlag == true)
					{
						pedestal_triggerMode_getArrays(&(inboundRingManager));
					}
					if (pedestalTriggerModeFlag != true)
					{
						// xil_printf("%d\t", (uint32_t)inboundRingManager.writePointer->wdo_id);
					}
					// XAxiDma_SimpleTransfer_hm((UINTPTR)inboundRingManager.writePointer , SIZE_DATA_ARRAY_BYT);
					Xil_DCacheInvalidateRange((UINTPTR)inboundRingManager.writePointer, SIZE_DATA_ARRAY_BYT);

					updateInboundCircBuffer();
				}

				/* If needed, reload watchdog's counter */
				if (flag_scu_timer)
				{
					XScuWdt_RestartWdt(&WdtScuInstance);
					flag_scu_timer = false;
				}

				/* The DMA had a problem */
				if (flag_axidma_error)
				{
					printf("Error with DMA interrupt: TPG !\r\n");
					return XST_FAILURE;
				}
				//							printf("inboundRingManager.pendingCount %d \r\n", (uint16_t)(inboundRingManager.pendingCount));
				if (!trigger_flag)
				{
					if (i == trigger_freq)
					{
						PStrigger(ENABLE);
						trigger_flag = 1;
						i = 0;
					}
					else
					{
						i++;
					}
				}
			}

			stream_flag = FALSE;
			//	XTime_GetTime(&tEnd);
			usleep(100);
			printf("leaving trigger mode\r\n");
			xil_printf("p %d \r\n", (uint16_t)(inboundRingManager.processedCount));
			PrintInboundRingStatus(inboundRingManager);
			//	printf("Time1 %lld, Time2 %lld, Diff %lld \r\n", tStart, tEnd, tEnd-tStart);
			state_main = IDLE;
			clearInboundBuffer();

			printf("go back to idle\r\n");
			break;
		}
	}
}

int main()
{
	xil_printf("\n\r\n\r------START------\r\n");

	//    dma_stm_en state_main = IDLE;

	//  GetTargetCStatus(regptr_1);

	//  GetTargetCControl(regptr_1);
	printf("before init global\r\n");

	/* Initialize the global variables */
	if (init_global_var() == XST_SUCCESS)
		xil_printf("Global variables initialization pass!\r\n");
	else
	{
		end_main(GLOBAL_VAR, "Global variables initialization failed!");
		return -1;
	}
	SDcardAndFiles();
	/* Initialize the interrupts */
	if (interrupts_initialization() == XST_SUCCESS)
		xil_printf("Interrupts initialization pass!\r\n");
	else
	{
		end_main(GLOBAL_VAR | LOG_FILE, "Interrupts initialization failed!");
		return -1;
	}
	/* Initialize the LWip */
	lwip_init();

	init_software();
	init_FPGA();
	///  Setup DACs
	init_ASIC();

	/// Network interface
	networkInterface();
	setPCaddress();

	usleep(100);
	printf("Start while loop\r\n");
	loop();
	printf("Stop while loop\r\n");

	/* Close and clear everything */
	cleanup_interrupts(true);
	cleanup_udp();
	cleanup_global_var();
	printf("-------END-------\r\n");

	return 0;
}

void updateInboundCircBuffer()
{
	disable_interrupts();
	// xil_printf("inboundRingManager.pendingCount %d \r\n", (uint16_t)(inboundRingManager.pendingCount));
	inboundRingManager.pendingCount--; // updated in interrupt handler, so have to be careful here
	inboundRingManager.processedCount++;
	// Reset circ buffer if out of bounds
	if (inboundRingManager.procPointer < inboundRingManager.lastAllowedPointer)
	{
		(inboundRingManager.procPointer)++;
		(inboundRingManager.procLocation)++;
	}
	else
	{
		inboundRingManager.procPointer = inboundRingManager.firstAllowedPointer;
		inboundRingManager.procLocation = 0;
	}
	// xil_printf("inboundRingManager.pendingCount %d \r\n", (uint16_t)(inboundRingManager.pendingCount));
	// xil_printf("inboundRingManager.processedCount %d \r\n", (uint16_t)(inboundRingManager.processedCount));
	enable_interrupts();
	// xil_printf("after_int_inboundRingManager.pendingCount %d \r\n", (uint16_t)(inboundRingManager.pendingCount));
}

void end_main(clean_state_en state, char *error_txt)
{
	char text[100];

	sprintf((char *)text, "In main: %s", error_txt);
	if (state & GLOBAL_VAR)
		cleanup_global_var();
	if (state & INTERRUPT)
		cleanup_interrupts(false);
	if (state & UDP)
		cleanup_udp();
	if (state & LOG_FILE)
	{
		log_event(text, strlen(text));
	}
	else
		xil_printf("%s\r\n", text);

	xil_printf("-------END-------\r\n");
	sleep(1); // to see the xil_printf
	// SYSTEM RESET
	system_reset_hm();
	main();
}

void restart(void)
{
	printf("restarting");
	usleep(1);
	end_main(GLOBAL_VAR | LOG_FILE | INTERRUPT | UDP, "Restart!");
	main();
}

void setupDACs(void)
{
	//	/* Initialize the DAC (Vped, Comparator value) */
	if (gpio_init() == XST_SUCCESS)
		xil_printf("DAC initialization pass!\r\n");
	else
	{
		end_main(GLOBAL_VAR | LOG_FILE | INTERRUPT, "DAC initialization failed!");
	}

	if (set_DAC_CHANNEL(DAC_GRP_0, THRESHOLD_CMP_0) != XST_SUCCESS)
	{
		end_main(GLOBAL_VAR | LOG_FILE | INTERRUPT, "DAC: setting group threshold PMT 0 voltage failed!");
	}
	if (set_DAC_CHANNEL(DAC_GRP_1, THRESHOLD_CMP_1) != XST_SUCCESS)
	{
		end_main(GLOBAL_VAR | LOG_FILE | INTERRUPT, "DAC: setting group threshold PMT 1 voltage failed!");
	}
	if (set_DAC_CHANNEL(DAC_GRP_2, THRESHOLD_CMP_2) != XST_SUCCESS)
	{
		end_main(GLOBAL_VAR | LOG_FILE | INTERRUPT, "DAC: setting group threshold PMT 2 voltage failed!");
	}
	if (set_DAC_CHANNEL(DAC_GRP_3, THRESHOLD_CMP_3) != XST_SUCCESS)
	{
		end_main(GLOBAL_VAR | LOG_FILE | INTERRUPT, "DAC: setting group threshold PMT 3 voltage failed!");
	}
	if (set_DAC_CHANNEL(DAC_GRP_4, THRESHOLD_CMP_4) != XST_SUCCESS)
	{
		end_main(GLOBAL_VAR | LOG_FILE | INTERRUPT, "DAC: setting group threshold PMT 0 voltage failed!");
	}
	if (set_DAC_CHANNEL(DAC_GRP_5, THRESHOLD_CMP_5) != XST_SUCCESS)
	{
		end_main(GLOBAL_VAR | LOG_FILE | INTERRUPT, "DAC: setting group threshold PMT 1 voltage failed!");
	}
	if (set_DAC_CHANNEL(DAC_GRP_6, THRESHOLD_CMP_6) != XST_SUCCESS)
	{
		end_main(GLOBAL_VAR | LOG_FILE | INTERRUPT, "DAC: setting group threshold PMT 2 voltage failed!");
	}
	if (set_DAC_CHANNEL(DAC_GRP_7, THRESHOLD_CMP_7) != XST_SUCCESS)
	{
		end_main(GLOBAL_VAR | LOG_FILE | INTERRUPT, "DAC: setting group threshold PMT 2 voltage failed!");
	}
	usleep(30);
	if (set_DAC_CHANNEL_8574(VPED_ANALOG) != XST_SUCCESS)
	{
		end_main(GLOBAL_VAR | LOG_FILE | INTERRUPT, "DAC: setting Vped voltage failed!");
	}
}
void testPattern(int *regptr)
{
	//			 Test pattern
	if (test_TPG(regptr) == XST_SUCCESS)
		printf("TestPattern Generator pass!\r\n");
	else
	{
		end_main(GLOBAL_VAR | LOG_FILE | INTERRUPT | UDP, "TestPattern Generator failed!");
	}
	sleep(5);
}

void SDcardAndFiles(void)
{
	/* Mount SD Card and create log file */
	FRESULT result = mount_sd_card();
	if (result == FR_OK)
		xil_printf("Mounting SD card pass!\r\n");
	else
	{
		end_main(GLOBAL_VAR, "Mounting SD card failed!");
	}
	/* Create log file */
	if (create_logfile() == FR_OK)
		xil_printf("Log file creation pass!\r\n");
	else
	{
		end_main(GLOBAL_VAR, "Log file creation failed!");
	}

	/* Create time file */
	if (create_timefile() == FR_OK)
		xil_printf("Time file creation pass!\r\n");
	else
	{
		end_main(GLOBAL_VAR, "Time file creation failed!");
	}

	/* Initialize the devices timer, axidma, ... */
	if (devices_initialization() == XST_SUCCESS)
		xil_printf("Devices initialization pass!\r\n");
	else
	{
		end_main(GLOBAL_VAR | LOG_FILE, "Devices initialization failed!");
	}
}

void networkInterface(void)
{
	/* Initialize "echo_netif" to avoid warnings with function "xemac_add" */
	echo_netif = &server_netif;
	ip_addr_t ipaddr, netmask, gw;
	/* Add network interface to the netif_list, and set it as default */

	/* the mac address of the board. this should be unique per board */
	unsigned char mac_ethernet_address[] = {0x00, 0x0a, 0x35, 0x00, 0x01, 0x02};
	ipaddr.addr = 0;
	gw.addr = 0;
	netmask.addr = 0;
	if (!xemac_add(echo_netif, &ipaddr, &netmask, &gw, mac_ethernet_address, PLATFORM_EMAC_BASEADDR))
	{
		end_main(GLOBAL_VAR | LOG_FILE | INTERRUPT, "Error adding N/W interface");
	}

	/* specify that the network if is up */
	netif_set_default(echo_netif);
	netif_set_up(echo_netif);

	/* initliaze IP addresses to be used */
	IP4_ADDR(&(echo_netif->ip_addr), 192, 168, 1, 10);
	IP4_ADDR(&(echo_netif->netmask), 255, 255, 255, 0);
	IP4_ADDR(&(echo_netif->gw), 192, 168, 1, 1);
	ipaddr.addr = echo_netif->ip_addr.addr;
	gw.addr = echo_netif->gw.addr;
	netmask.addr = echo_netif->netmask.addr;
	print_ip_settings(&ipaddr, &netmask, &gw);
}
void setPCaddress(void)
{
	ip_addr_t pc_ipaddr;
	/* Set the PC address */
	IP4_ADDR(&pc_ipaddr, 192, 168, 1, 11);
	print_ip("\r\nPC IP: ", &pc_ipaddr);

	/* Set the UDP connections and callback for data and commands */
	if (setup_udp_settings(pc_ipaddr) < 0)
	{
		end_main(GLOBAL_VAR | LOG_FILE | INTERRUPT, "Error setting up the UDP interface");
	}
	else
		xil_printf("UDP started @ port %d for data and @ port %d for commands\n\r", PORT_DATA, PORT_CMD);
}
void initPedestals(void)
{
	// Initialize pedestal
	if (get_pedestal(50, 1, regptr_0) == XST_SUCCESS)
		printf("Pedestal initialization pass!\r\n");
	//	if(init_pedestals() == XST_SUCCESS) printf("Pedestal initialization pass!\r\n");

	else
	{
		end_main(GLOBAL_VAR | LOG_FILE | INTERRUPT | UDP, "Pedestal initialization failed!");
	}
}

void initTARGETregisters(int *regptr)
{
	ControlRegisterWrite((int)NULL, INIT, regptr);
	// software reset PL side
	ControlRegisterWrite(SWRESET_MASK, DISABLE, regptr);
	// Reset TargetC's registers
	ControlRegisterWrite(REGCLR_MASK, DISABLE, regptr);
	usleep(100000);
	ControlRegisterWrite(SWRESET_MASK, ENABLE, regptr);
	usleep(1000);
	ControlRegisterWrite(SS_TPG_MASK, ENABLE, regptr);
	usleep(1000);
}
//		void transferFunctionInit(void){
//
//				/* Initialize transfer function coefficients */
//				if(init_transfer_function() == XST_SUCCESS) printf("Transfer function initialization pass!\r\n");
//				else{
//					end_main(GLOBAL_VAR | LOG_FILE | INTERRUPT | UDP, "Transfer function initialization failed!");
//				}
//		}
//
