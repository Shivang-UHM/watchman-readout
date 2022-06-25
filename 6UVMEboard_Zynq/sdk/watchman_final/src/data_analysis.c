/**
 * @file 	data_analysis.c
 * @author	Anthony Schluchin
 * @date	28th November 2018
 * @version 0.0
 */

#include "data_analysis.h"

/**************** Extern global variables ****************/
/*********************************************************/
/** @brief Array containing the pedestal correction for every sample */
uint32_t  pedestal[512][16][32];
/** @brief Lookup table to correct the transfer function */
extern uint16_t lookup_table[2048];
/** @brief Buffer used to send the data (50 bytes above it reserved for protocol header) */
extern char* frame_buf;
/* data structure from PL */
//extern InboundRingManager_t inboundRingManager;


/** @brief Array containing the pedestal correction for every sample, the pedestal values
 * in trigger Mode follow the way is done with real data to minimize the differences
 * in data acquisition time for the same window. pedestal_A is for windows that contain the whole pulse
 * and for the windows that are first of two windows.*/

extern uint32_t  pedestal_A[512][16][32];

/** @brief Array containing the pedestal correction for every sample, the pedestal values
 * in trigger Mode follow the way is done with real data to minimize the differences
 * in data acquisition time for the same window. pedestal_B is for windows that are the second ones
 * in a two-window pulse */

extern uint32_t  pedestal_B[512][16][32];

/** @brief Array containing the pedestal correction for every sample TARGETC_0 */
extern uint32_t  pedestal_0[512][32][32];
/** @brief Array containing the pedestal correction for every sample TARGETC_1 */
extern uint32_t  pedestal_1[512][16][32];


void print_out_data_axi(data_axi *writePointer ){
	printf("\r\n<print_out_data_axi>\r\n");
	for(int j=0; j<32; j++){
		for(int i=0; i<32; i++){
			printf("%d\t", (uint16_t)writePointer->data[j][i]);
		}

		printf("\r\n");
	}
	printf("</print_out_data_axi>\r\n");
}

/****************************************************************************/
/**
* @brief	Correct the data received from the PL side (pedestal subtraction &
* 			transfer function correction) and choose the gain stage (channel)
*
* @param	data: pointer on array to return the data corrected
* @param	pmt: PMT's ID (4 PMTs per ASIC, 16 ch per ASIC -> 4 ch per PMT)
* @param	nbr_wdo: number of window for the pulse
* @param	info: pointer to return info of pulse too long or not
*
* @return	ch: channel chose (gain stage chose)
*
* @note		-
*
****************************************************************************/
int correct_data(uint16_t* data, int pmt, char nbr_wdo, uint32_t* info, data_list* tmp_first_element){
	int ch = 4*pmt+3;
	int ch_last = ch-3;
	data_list* ptr;
	int wdo, sample;
	int index = 0;
	bool gain_good = false;
	bool too_long = false;
	uint16_t data_tmp;

	// Look for best gain stage (channel)
	while(!gain_good){
		gain_good = true;
		ptr = tmp_first_element;
		index = 0;
		for(wdo=0; wdo<nbr_wdo; wdo++){
			for(sample=0; sample<32; sample++){
				// Pedestal subtraction
				data_tmp = (uint16_t)ptr->data.data_struct.data[ch][sample] + VPED_DIGITAL - pedestal[ptr->data.data_struct.wdo_id][ch][sample];
				// Transfer function correction
				if(data_tmp > 2047) data_tmp = 2047;
				data[index] = lookup_table[data_tmp];
				// If pulse goes under threshold, take next gain stage
				if(data[index] < THRESHOLD_PULSE){
					if(ch > ch_last){
						ch--;
						gain_good = false;
						sample = 32;
						wdo = nbr_wdo;
					}
					else too_long = true;	// Amplitude too high with all gain stage -> consider pulse as "too long"
				}
				index++;
			}
			ptr = ptr->next;
		}
	}
	if(too_long) *info |= 0x1 << (TOO_LONG_SHIFT+pmt); // if all gain stage are saturated
	return ch;
}

/****************************************************************************/
/**
* @brief	Extract the minimum amplitude of the pulse, and the time when
* 			it was 20% of its value
*
* @param	data: pointer on the pulse's data
* @param	length: size of data
* @param	features: pointer on structure to return the amplitude and the time
*
* @return	None
*
* @note		-
*
****************************************************************************/
void extract_features(uint16_t* data, int length, features_ext* features){
	int vped = VPED_DIGITAL;
	int i, sample, amplitude;
	float amp_start, a, b;
	coordinates p1, p2;

	/* Get the minimum amplitude of the pulse */
	amplitude = vped;
	for(i=0; i<length; i++){
		if(data[i] < amplitude){
			amplitude = data[i];
			sample = i;
		}
	}

	features->amplitude = amplitude;

	/* Get the moment where the curve was at 20% of the difference between vped and the minimum amplitude */
	amp_start = vped - 0.2*(vped - features->amplitude);

	i=sample;
	while((float)data[i] < amp_start){
		i--;
		if(i < 0){
			i = 0;
			break;
		}
	}
	p1.x = (float)i;	// extrapolate the line between the two point surrounding the amplitude we're looking for
	p1.y = (float)data[i];
	i++;
	p2.x = (float)i;
	p2.y = (float)data[i];
	a = (p2.y - p1.y)/(p2.x - p1.x);
	b = p1.y - a*p1.x;
	features->time.time_fl = (amp_start - b)/a;
}




//void updateInboundCircBuffer() {
//	disable_interrupts();
//    xil_printf("inboundRingManager.pendingCount %d \r\n", (uint16_t)(inboundRingManager.pendingCount));
//	inboundRingManager.pendingCount--; // updated in interrupt handler, so have to be careful here
//	inboundRingManager.processedCount++;
//	// Reset circ buffer if out of bounds
//	if(inboundRingManager.procPointer < inboundRingManager.lastAllowedPointer) {
//		(inboundRingManager.procPointer)++;
//		(inboundRingManager.procLocation)++;
//	} else {
//		inboundRingManager.procPointer  = inboundRingManager.firstAllowedPointer;
//		inboundRingManager.procLocation = 0;
//	}
//    xil_printf("inboundRingManager.pendingCount %d \r\n", (uint16_t)(inboundRingManager.pendingCount));
//    xil_printf("inboundRingManager.processedCount %d \r\n", (uint16_t)(inboundRingManager.processedCount));
//    enable_interrupts();
//    xil_printf("after_int_inboundRingManager.pendingCount %d \r\n", (uint16_t)(inboundRingManager.pendingCount));
//}


void udp_transfer_WM( volatile InboundRingManager_t *data_to_send )
{
 int index;
 data_axi *Data2send = data_to_send -> procPointer;
 uint16_t data_tmp;
 int window, sample, window_order;
 int i, j;
 int offset_avoid_negative = 200;
 int channelToSend=5;
 window = Data2send->wdo_id;
// window_order = Data2send-> info;
 xil_printf("windowNumber:%d \r\n",window);
//	xil_printf(".Pulse...\r\n");
	index = 0;
				frame_buf[index++] = 0x55;
				frame_buf[index++] = 0xAA;
				frame_buf[index++] = (char)window;
				frame_buf[index++] = (char)(window >> 8);

//				xil_printf("\r\n w=%d\r\n",window);
			//	xil_printf("%d,%d\r\n",window, window_order);

				for(i=0; i<16; i++){
					for(sample = 0; sample <32; sample++){
						/* Pedestal subtraction */
						data_tmp = (uint16_t)  (Data2send->data[i][sample]- pedestal_0[window][i][sample]+ offset_avoid_negative );
					//	data_tmp = (uint16_t)  (Data2send->data[channelToSend][sample]- pedestal_0[window][channelToSend][sample]+ offset_avoid_negative );
//						data_tmp = (uint16_t)  (pedestal_0[window][channelToSend][sample]);

//						data_tmp = (uint16_t)  (Data2send->data[15][sample]); //-  pedestal_A[window][15][sample]+ offset_avoid_negative);
						frame_buf[index++] = (char)data_tmp;
					    //xil_printf("int_number = %d\r\n ", (char)(int_number));

						frame_buf[index++] = (char)(data_tmp >> 8);
						//xil_printf("int_number >> 8 = %d\r\n", (char)((int_number >> 8)));
					}
				}
/*
					for(sample = 0; sample <32; sample++){
						 Pedestal subtraction
						data_tmp = (uint16_t)  (Data2send->data_1[channelToSend][sample]- pedestal_1[window][channelToSend][sample]+ offset_avoid_negative);
//						data_tmp = (uint16_t)  (pedestal_1[window][channelToSend][sample]+ offset_avoid_negative);

						//						data_tmp = (uint16_t)  (Data2send->data[15][sample]); //-  pedestal_A[window][15][sample]+ offset_avoid_negative);
						frame_buf[index++] = (char)data_tmp;
					    //xil_printf("int_number = %d\r\n ", (char)(int_number));

						frame_buf[index++] = (char)(data_tmp >> 8);
						//xil_printf("int_number >> 8 = %d\r\n", (char)((int_number >> 8)));
					}
*/


					//xil_printf("\r\n");
				//}
				//xil_printf("\r\n");
				frame_buf[index++] = 0x33;
			//    xil_printf("Test\r\n");
				frame_buf[index++] = 0xCC;
			//	xil_printf("PRINTINDEX %d\r\n", index);
				transfer_data(frame_buf, index);
			//	xil_printf("PRINT INDEX AFTER TRANSFER %d\r\n", index);
				usleep(1);
				index = 0;
								frame_buf[index++] = 0x55;
								frame_buf[index++] = 0xAA;
								frame_buf[index++] = (char)window;
								frame_buf[index++] = (char)(window >> 8);

				//				xil_printf("\r\n w=%d\r\n",window);
							//	xil_printf("%d,%d\r\n",window, window_order);

								for(i=16; i<32; i++){
									for(sample = 0; sample <32; sample++){
										/* Pedestal subtraction */
										data_tmp = (uint16_t)  (Data2send->data[i][sample]- pedestal_0[window][i][sample]+ offset_avoid_negative );
									//	data_tmp = (uint16_t)  (Data2send->data[channelToSend][sample]- pedestal_0[window][channelToSend][sample]+ offset_avoid_negative );
				//						data_tmp = (uint16_t)  (pedestal_0[window][channelToSend][sample]);

				//						data_tmp = (uint16_t)  (Data2send->data[15][sample]); //-  pedestal_A[window][15][sample]+ offset_avoid_negative);
										frame_buf[index++] = (char)data_tmp;
									    //xil_printf("int_number = %d\r\n ", (char)(int_number));

										frame_buf[index++] = (char)(data_tmp >> 8);
										//xil_printf("int_number >> 8 = %d\r\n", (char)((int_number >> 8)));
									}
								}
				/*
									for(sample = 0; sample <32; sample++){
										 Pedestal subtraction
										data_tmp = (uint16_t)  (Data2send->data_1[channelToSend][sample]- pedestal_1[window][channelToSend][sample]+ offset_avoid_negative);
				//						data_tmp = (uint16_t)  (pedestal_1[window][channelToSend][sample]+ offset_avoid_negative);

										//						data_tmp = (uint16_t)  (Data2send->data[15][sample]); //-  pedestal_A[window][15][sample]+ offset_avoid_negative);
										frame_buf[index++] = (char)data_tmp;
									    //xil_printf("int_number = %d\r\n ", (char)(int_number));

										frame_buf[index++] = (char)(data_tmp >> 8);
										//xil_printf("int_number >> 8 = %d\r\n", (char)((int_number >> 8)));
									}
				*/


									//xil_printf("\r\n");
								//}
								//xil_printf("\r\n");
								frame_buf[index++] = 0x33;
							//    xil_printf("Test\r\n");
								frame_buf[index++] = 0xCC;
							//	xil_printf("PRINTINDEX %d\r\n", index);
								transfer_data(frame_buf, index);
				free(Data2send);
//
//				if (window==40){
//					printf("\r\nwindow = %d\r\n", window);
//								xil_printf("wdo_time: %d\r\n", (uint)window);
//								xil_printf("PL_spare: %d\r\n", (uint)Data2send->PL_spare);
//								xil_printf("info: 0x%X\r\n", (uint)Data2send->info);
//								for(j=0; j<32; j++){
//									for(i=0; i<16; i++){
//										xil_printf("%d\t", (uint)Data2send->data_1[i][j]);
//									}
//									printf("\r\n");
//
//				}
//
//				}
}


void PrintInboundRingStatus(InboundRingManager_t inboundRing) {
	//char string[256];
	xil_printf(          "--------------------------- Inbound Ring status ---------------------------\r\n");
	xil_printf( "0x%08lx inboundRingManager.writePointer\r\n", (u32) inboundRing.writePointer);
	//usleep(100);

	xil_printf( "0x%08lx inboundRingManager.writePointer\r\n", (u32) inboundRing.writePointer);
	//usleep(100);

	//usleep(100);
	xil_printf( "  %08ld inboundRingManager.writeLocation\r\n", (u32) inboundRing.writeLocation);
	//usleep(100);

	xil_printf( "  %08d inboundRingManager.packetSize at write\r\n",(int) inboundRing.packetSize[inboundRing.writeLocation]);
	//usleep(100);
	xil_printf( "0x%08lx inboundRingManager.procPointer\r\n", (u32) inboundRing.procPointer);
     //usleep(100);
	xil_printf( "  %08ld inboundRingManager.procLocation\r\n", (u32) inboundRing.procLocation);
    //usleep(100);
	xil_printf( "  %08d inboundRingManager.packetSize at proc\r\n",(int) inboundRing.packetSize[inboundRing.procLocation]);
        //usleep(100);
	xil_printf( "0x%08lx inboundRingManager.firstAllowedPointer\r\n", (u32) inboundRing.firstAllowedPointer);
        //usleep(100);
	xil_printf( "0x%08lx inboundRingManager.lastAllowedPointer\r\n", (u32) inboundRing.lastAllowedPointer);
        //usleep(100);
	xil_printf( "  %08d inboundRingManager.pendingCount\r\n",(int) inboundRing.pendingCount);
        //usleep(100);
	xil_printf( "  %08d inboundRingManager.totalCount\r\n",(int) inboundRing.totalCount);
        //usleep(100);
	xil_printf( "  %08d inboundRingManager.processedCount\r\n",(int) inboundRing.processedCount);
        //usleep(100);
	return;
}

