
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

#include "default_readout.h"



int default_readout(){
	xil_printf("\n\r\n\r------START------\r\n");
	    data_list* tmp_ptr_main  = (data_list *)malloc(sizeof(data_list));
	    if(!tmp_ptr_main){
	    	printf("malloc for tmp_ptr failed in function, %s!\r\n", __func__);
	        return XST_FAILURE;
	     }

	//    dma_stm_en state_main = IDLE;

	    GetTargetCStatus(regptr_0);
	//  GetTargetCStatus(regptr_1);

	    GetTargetCControl(regptr_0);
	//  GetTargetCControl(regptr_1);
	  	printf("before init global\r\n");

		/* Initialize the global variables */
		if(init_global_var() == XST_SUCCESS) xil_printf("Global variables initialization pass!\r\n");
		else{
			end_main(GLOBAL_VAR, "Global variables initialization failed!");
			return -1;
		}
		SDcardAndFiles();
		/* Initialize the interrupts */
		if(interrupts_initialization() == XST_SUCCESS) xil_printf("Interrupts initialization pass!\r\n");
		else{
			end_main(GLOBAL_VAR | LOG_FILE, "Interrupts initialization failed!");
			return -1;
		}
		/* Initialize the LWip */
		lwip_init();

		disable_interrupts();
		/* now enable interrupts */
		enable_interrupts();
	///  Setup DACs
		setupDACs();
	/// Network interface
		networkInterface();
		setPCaddress();


		initTARGETregisters(regptr_0);
	//	initTARGETregisters(regptr_1);
		printf("after INIT\r\n");

		GetTargetCStatus(regptr_0);
	//	GetTargetCStatus(regptr_1);

		GetTargetCControl(regptr_0);
	//	GetTargetCControl(regptr_1);

		// Waiting on PL's clocks to be ready
		while((regptr_0[TC_STATUS_REG] & LOCKED_MASK) != LOCKED_MASK){
			sleep(1);
		}

		// Waiting on PL's clocks to be ready
	//	while((regptr_1[TC_STATUS_REG] & LOCKED_MASK) != LOCKED_MASK){
	//		sleep(1);
	//	}
		printf("after LOCKEDmask\r\n");


		GetTargetCStatus(regptr_0);
	//	GetTargetCStatus(regptr_1);

		GetTargetCControl(regptr_0);
	//	GetTargetCControl(regptr_1);

		printf("PL's clock ready\r\n");
		// Initialize TargetC's registers
		SetTargetCRegisters(regptr_0);
	//	usleep(10);
	//	SetTargetCRegisters(regptr_1);

		printf("sleep to set the debug core\r\n");
		GetTargetCStatus(regptr_0);
	//	GetTargetCStatus(regptr_1);

		GetTargetCControl(regptr_0);
	//	GetTargetCControl(regptr_1);
	//	usleep(100);
		Xil_DCacheDisable();
		testPattern(regptr_0);
	//	testPattern(regptr_1);

	//	ControlRegisterWrite(SS_TPG_MASK,ENABLE, regptr_0);
	//	usleep(100);
	//	ControlRegisterWrite(SS_TPG_MASK,ENABLE, regptr_1);
		usleep(100);

	// 	initPedestals();

		flag_while_loop = true;
		dma_stm_en state_main = IDLE;
	//	pedestal_triggerMode_init();
		usleep(100);
		int pedestal_Avg=100;
		int nmbr_Windows_Ped=1;
	//    if(get_pedestal(pedestal_Avg,nmbr_Windows_Ped, regptr_0) == XST_SUCCESS) printf("Pedestal pass! pedestal_Avg= %d,nmbrWindows_Ped = %d, \r\n", pedestal_Avg, nmbr_Windows_Ped);
	//    int window,channel,sample;
	//    for(window = 0; window< 1; window++ ){
	//    	for(channel = 0; channel< 32; channel++ ){
	//    		for(sample = 0; sample< 32; sample++ ){
	//    			//pedestal_0[window][channel][sample] = 0;
	//    			printf("Channel = %u, %d\r\n",channel, pedestal_0[window][channel][sample]);
	//
	//    	}
	//    	}
	//  }

	    printf("Start while loop\r\n");

		while (run_flag){
			/* Simulate a infinity loop to trigger the watchdog  */
			if(simul_err_watchdog_flag){
				while(1);
			}

			/* Simulate a function which has a problem */
			if(simul_err_function_prob_flag){
				end_main(GLOBAL_VAR | LOG_FILE | INTERRUPT | UDP, "Error function problem ask from user (simulation of function return error!)");
				return -1;
			}

			/* Simulate a exception */
			if(simul_err_exception_flag){
				char* ptr = (char *)pcb_cmd;
				for(int g=0; g<sizeof(struct udp_pcb); g++) ptr[g] = 0;
				udp_send(pcb_cmd, buf_cmd);
			}

			/* Simulate a assertion */
			if(simul_err_assertion_flag){
				Xil_Assert(__FILE__, __LINE__);
			}

			/* If needed, update timefile */
			if(flag_ttcps_timer){
				update_timefile();
				flag_ttcps_timer = false;
			}

			/* If needed, reload watchdog's counter */
			if(flag_scu_timer){
				XScuWdt_RestartWdt(&WdtScuInstance);
				flag_scu_timer = false;
			}

			if(flag_axidma_error){
				end_main(GLOBAL_VAR | LOG_FILE | INTERRUPT | UDP, "AXI-DMA failed!");
				return -1;
			}
			switch(state_main){
				case IDLE:
					if(stream_flag){
						xil_printf("From IDLE to STREAM \n");

						state_main = STREAM;
					}
					if(get_transfer_fct_flag && (!stream_flag) && empty_flag){
						ControlRegisterWrite(CPUMODE_MASK,DISABLE, regptr_0);
						state_main = GET_TRANSFER_FCT;
					}
					if(get_windows_flag && (!stream_flag) && empty_flag){
						ControlRegisterWrite(CPUMODE_MASK,DISABLE, regptr_0);
						state_main = GET_WINDOWS;
					}
					if(pedestal_flag && (!stream_flag) && empty_flag){
						ControlRegisterWrite(CPUMODE_MASK,DISABLE, regptr_0);
					//	ControlRegisterWrite(CPUMODE_MASK,DISABLE, regptr_1);
						state_main = GET_PEDESTAL;
					}
					if(restart_flag){
									ControlRegisterWrite(CPUMODE_MASK,DISABLE, regptr_0);
					//				ControlRegisterWrite(CPUMODE_MASK,DISABLE, regptr_1);
									printf("restarting at idle\r\n");
									state_main = RESTART;
								}
					if(get_windows_raw_flag && (!stream_flag) && empty_flag){
							ControlRegisterWrite(CPUMODE_MASK,DISABLE, regptr_0);
					//		ControlRegisterWrite(CPUMODE_MASK,DISABLE, regptr_1);

							state_main = GET_WINDOWS_RAW;
						}
					if(dividePedestalsFlag){
						state_main = DIVIDE_PEDESTALS;
						}
					break;
				case STREAM:
					if((!stream_flag)){
						usleep(100);
			     		ControlRegisterWrite(SWRESET_MASK,DISABLE, regptr_0);
						ControlRegisterWrite(SWRESET_MASK,ENABLE, regptr_0);
					//	ControlRegisterWrite(SWRESET_MASK,DISABLE, regptr_1);
					//	ControlRegisterWrite(SWRESET_MASK,ENABLE, regptr_1);
						usleep(100);
						state_main = IDLE;
					}

					ControlRegisterWrite(SMODE_MASK ,ENABLE, regptr_0); // mode for selecting the interrupt, 1 for dma
					usleep(100);

					ControlRegisterWrite(SS_TPG_MASK ,ENABLE, regptr_0); // 0 for test pattern mode, 1 for sample mode (normal mode)
					usleep(100);

					ControlRegisterWrite(CPUMODE_MASK,ENABLE, regptr_0); // mode trigger, 0 for usermode (cpu mode), 1 for trigger mode

					usleep(100);

			//		ControlRegisterWrite(SMODE_MASK ,ENABLE, regptr_1); // mode for selecting the interrupt, 1 for dma
			//		usleep(100);

			//		ControlRegisterWrite(SS_TPG_MASK ,ENABLE, regptr_1); // 0 for test pattern mode, 1 for sample mode (normal mode)
			//		usleep(100);

			//		ControlRegisterWrite(CPUMODE_MASK,ENABLE, regptr_1); // mode trigger, 0 for usermode (cpu mode), 1 for trigger mode

			//		usleep(100);

					xil_printf("flag_axidma_rx_done= %d \r\n",flag_axidma_rx_done);
					usleep(100);



					// setup inbound and outbound circular waveform/packet buffers
					memset((void *) (&inboundRingManager), 0, sizeof(inboundRingManager));
					inboundRingManager.writePointer        = DDR_incoming_waveform_ring_buffer;
					inboundRingManager.procPointer         = inboundRingManager.writePointer;
					inboundRingManager.firstAllowedPointer = inboundRingManager.writePointer;
					inboundRingManager.lastAllowedPointer  = inboundRingManager.writePointer + (INBOUND_RING_BUFFER_LENGTH_IN_PACKETS - 1);
					PrintInboundRingStatus(inboundRingManager);

					printf("after inboundRingManager init \r\n");
					usleep(100);
					clearInboundBuffer();
					usleep(100);
					// INIT PEDESTALS

					//PrintInboundRingStatus(inboundRingManager);
					//usleep(100);


					XAxiDma_SimpleTransfer_hm((UINTPTR)inboundRingManager.writePointer , SIZE_DATA_ARRAY_BYT);
					usleep(100);
				     triggerMode(ENABLE);
				     //ControlRegisterWrite(WINDOW_MASK,ENABLE, regptr_0); //  register for starting the round buffer in trigger mode
	//				 ControlRegisterWrite(WINDOW_MASK,ENABLE, regptr_1); //  register for starting the round buffer in trigger mode

					 Xil_DCacheInvalidateRange((UINTPTR)inboundRingManager.writePointer , SIZE_DATA_ARRAY_BYT);
					 usleep(100);
				     xil_printf(" pendingCountBefore: %d \r\n",inboundRingManager.pendingCount);
				     usleep(100);
					printf("after inboundRingManager print, starting while loop \r\n");
					 usleep(100);
	                 int i = 0;
	                 int trigger_freq=10000;
	                 bool trigger_flag;
				//	 XTime_GetTime(&tStart);
					 while(stream_flag) {
							if(inboundRingManager.pendingCount > 0) {
								if (pedestalTriggerModeFlag == true) {
	                            pedestal_triggerMode_getArrays(&(inboundRingManager));
								}
								if (pedestalTriggerModeFlag != true) {
									udp_transfer_WM( &(inboundRingManager));
								}

								Xil_DCacheInvalidateRange((UINTPTR)inboundRingManager.writePointer , SIZE_DATA_ARRAY_BYT);
							     updateInboundCircBuffer();
							     PrintInboundRingStatus(inboundRingManager);


							//     Xil_DCacheInvalidateRange((UINTPTR)inboundRingManager.writePointer , SIZE_DATA_ARRAY_BYT);
							//     ControlRegisterWrite(PSBUSY_MASK,DISABLE);

								/* Wait on DMA transfer to be done */
						//	timeout = 200000;
							}

	//							/* If needed, update timefile */
	//							if(flag_ttcps_timer){
	//								update_timefile();
	//								flag_ttcps_timer = false;
	//							}

								/* If needed, reload watchdog's counter */
								if(flag_scu_timer){
									XScuWdt_RestartWdt(&WdtScuInstance);
									flag_scu_timer = false;
								}

								/* The DMA had a problem */
								if(flag_axidma_error){
									printf("Error with DMA interrupt: TPG !\r\n");
									return XST_FAILURE;

						    	}
	//							printf("inboundRingManager.pendingCount %d \r\n", (uint16_t)(inboundRingManager.pendingCount));
	                            if (!trigger_flag){
								if (i==trigger_freq){
									PStrigger(ENABLE);
									trigger_flag=1;
									i=0;
								}
								else {
									 i++;
								}

	                            }

							}



					stream_flag= FALSE;
				//	XTime_GetTime(&tEnd);
					usleep(100);
					printf("leaving trigger mode\r\n");
				    xil_printf("p %d \r\n", (uint16_t)(inboundRingManager.processedCount));
					PrintInboundRingStatus(inboundRingManager);
				//	printf("Time1 %lld, Time2 %lld, Diff %lld \r\n", tStart, tEnd, tEnd-tStart);
					state_main = IDLE;
					clearInboundBuffer();

					break;
				case GET_TRANSFER_FCT:
					if(send_data_transfer_fct(regptr_0) == XST_SUCCESS) printf("Recover data pass!\r\n");
					else{
						end_main(GLOBAL_VAR | LOG_FILE | INTERRUPT | UDP, "Recover data failed!");
						return -1;
					}
					get_transfer_fct_flag = false;
					state_main = IDLE;
					break;
				case GET_WINDOWS:
	//				xil_printf("Getting windows\r\n");
					if(PulseSweep(regptr_0) != XST_SUCCESS){// printf("Get a 15 windows pass!\r\n");
					//else{
						end_main(GLOBAL_VAR | LOG_FILE | INTERRUPT | UDP, "Get a 15 windows failed!");
					return -1;
					}
					get_windows_flag = false;
					state_main = IDLE;
					break;
				case GET_WINDOWS_RAW:
					xil_printf("NADA\r\n");
					//if(get_windows_raw() != XST_SUCCESS){// printf("Get a 15 windows pass!\r\n");
					//else{
					//	end_main(GLOBAL_VAR | LOG_FILE | INTERRUPT | UDP, "Get a 15 windows failed!");
					//return -1;
					//}
					get_windows_flag = false;
					state_main = IDLE;
					break;
				case GET_PEDESTAL:
					if(get_pedestal(pedestalAvg,nmbrWindowsPed, regptr_0) == XST_SUCCESS) printf("Pedestal pass! pedestalAvg= %d,nmbrWindowsPed = %d, \r\n", pedestalAvg, nmbrWindowsPed);
				//	if(get_pedestal(pedestalAvg,nmbrWindowsPed, regptr_1) == XST_SUCCESS) printf("Pedestal pass-2! pedestalAvg= %d,nmbrWindowsPed = %d, \r\n", pedestalAvg, nmbrWindowsPed);
					else{
						end_main(GLOBAL_VAR | LOG_FILE | INTERRUPT | UDP, "Get pedestal failed!");
						return -1;
					}
					pedestal_flag = false;
					state_main = IDLE;
					xil_printf("exiting pedestal mode\r\n");
					break;
				case DIVIDE_PEDESTALS:
				    if(dividePedestalsFlag) {
				     divideByAverageNumber();
				     usleep(10);
				     dividePedestalsFlag=false;

				    printf("Restarting");
				    }
					break;
				case RESTART:
				    if(restart_flag) {
					restart_flag = false;
				    restart();

				    printf("Restarting");
				    }
					break;
				default:
					state_main = IDLE;
					break;
			}
		}

		/* Close and clear everything */
		cleanup_interrupts(true);
		cleanup_udp();
		cleanup_global_var();
		printf("-------END-------\r\n");

		return 0;
}
