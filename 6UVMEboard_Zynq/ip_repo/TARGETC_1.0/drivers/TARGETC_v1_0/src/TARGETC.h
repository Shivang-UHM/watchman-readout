
#ifndef TARGETC_H
#define TARGETC_H


/****************** Include Files ********************/
#include "xil_types.h"
#include "xstatus.h"

#define TARGETC_S00_AXI_SLV_REG0_OFFSET 0
#define TARGETC_S00_AXI_SLV_REG1_OFFSET 4
#define TARGETC_S00_AXI_SLV_REG2_OFFSET 8
#define TARGETC_S00_AXI_SLV_REG3_OFFSET 12
#define TARGETC_S00_AXI_SLV_REG4_OFFSET 16
#define TARGETC_S00_AXI_SLV_REG5_OFFSET 20
#define TARGETC_S00_AXI_SLV_REG6_OFFSET 24
#define TARGETC_S00_AXI_SLV_REG7_OFFSET 28
#define TARGETC_S00_AXI_SLV_REG8_OFFSET 32
#define TARGETC_S00_AXI_SLV_REG9_OFFSET 36
#define TARGETC_S00_AXI_SLV_REG10_OFFSET 40
#define TARGETC_S00_AXI_SLV_REG11_OFFSET 44
#define TARGETC_S00_AXI_SLV_REG12_OFFSET 48
#define TARGETC_S00_AXI_SLV_REG13_OFFSET 52
#define TARGETC_S00_AXI_SLV_REG14_OFFSET 56
#define TARGETC_S00_AXI_SLV_REG15_OFFSET 60
#define TARGETC_S00_AXI_SLV_REG16_OFFSET 64
#define TARGETC_S00_AXI_SLV_REG17_OFFSET 68
#define TARGETC_S00_AXI_SLV_REG18_OFFSET 72
#define TARGETC_S00_AXI_SLV_REG19_OFFSET 76
#define TARGETC_S00_AXI_SLV_REG20_OFFSET 80
#define TARGETC_S00_AXI_SLV_REG21_OFFSET 84
#define TARGETC_S00_AXI_SLV_REG22_OFFSET 88
#define TARGETC_S00_AXI_SLV_REG23_OFFSET 92
#define TARGETC_S00_AXI_SLV_REG24_OFFSET 96
#define TARGETC_S00_AXI_SLV_REG25_OFFSET 100
#define TARGETC_S00_AXI_SLV_REG26_OFFSET 104
#define TARGETC_S00_AXI_SLV_REG27_OFFSET 108
#define TARGETC_S00_AXI_SLV_REG28_OFFSET 112
#define TARGETC_S00_AXI_SLV_REG29_OFFSET 116
#define TARGETC_S00_AXI_SLV_REG30_OFFSET 120
#define TARGETC_S00_AXI_SLV_REG31_OFFSET 124
#define TARGETC_S00_AXI_SLV_REG32_OFFSET 128
#define TARGETC_S00_AXI_SLV_REG33_OFFSET 132
#define TARGETC_S00_AXI_SLV_REG34_OFFSET 136
#define TARGETC_S00_AXI_SLV_REG35_OFFSET 140
#define TARGETC_S00_AXI_SLV_REG36_OFFSET 144
#define TARGETC_S00_AXI_SLV_REG37_OFFSET 148
#define TARGETC_S00_AXI_SLV_REG38_OFFSET 152
#define TARGETC_S00_AXI_SLV_REG39_OFFSET 156
#define TARGETC_S00_AXI_SLV_REG40_OFFSET 160
#define TARGETC_S00_AXI_SLV_REG41_OFFSET 164
#define TARGETC_S00_AXI_SLV_REG42_OFFSET 168
#define TARGETC_S00_AXI_SLV_REG43_OFFSET 172
#define TARGETC_S00_AXI_SLV_REG44_OFFSET 176
#define TARGETC_S00_AXI_SLV_REG45_OFFSET 180
#define TARGETC_S00_AXI_SLV_REG46_OFFSET 184
#define TARGETC_S00_AXI_SLV_REG47_OFFSET 188
#define TARGETC_S00_AXI_SLV_REG48_OFFSET 192
#define TARGETC_S00_AXI_SLV_REG49_OFFSET 196
#define TARGETC_S00_AXI_SLV_REG50_OFFSET 200
#define TARGETC_S00_AXI_SLV_REG51_OFFSET 204
#define TARGETC_S00_AXI_SLV_REG52_OFFSET 208
#define TARGETC_S00_AXI_SLV_REG53_OFFSET 212
#define TARGETC_S00_AXI_SLV_REG54_OFFSET 216
#define TARGETC_S00_AXI_SLV_REG55_OFFSET 220
#define TARGETC_S00_AXI_SLV_REG56_OFFSET 224
#define TARGETC_S00_AXI_SLV_REG57_OFFSET 228
#define TARGETC_S00_AXI_SLV_REG58_OFFSET 232
#define TARGETC_S00_AXI_SLV_REG59_OFFSET 236
#define TARGETC_S00_AXI_SLV_REG60_OFFSET 240
#define TARGETC_S00_AXI_SLV_REG61_OFFSET 244
#define TARGETC_S00_AXI_SLV_REG62_OFFSET 248
#define TARGETC_S00_AXI_SLV_REG63_OFFSET 252
#define TARGETC_S00_AXI_SLV_REG64_OFFSET 256
#define TARGETC_S00_AXI_SLV_REG65_OFFSET 260
#define TARGETC_S00_AXI_SLV_REG66_OFFSET 264
#define TARGETC_S00_AXI_SLV_REG67_OFFSET 268
#define TARGETC_S00_AXI_SLV_REG68_OFFSET 272
#define TARGETC_S00_AXI_SLV_REG69_OFFSET 276
#define TARGETC_S00_AXI_SLV_REG70_OFFSET 280
#define TARGETC_S00_AXI_SLV_REG71_OFFSET 284
#define TARGETC_S00_AXI_SLV_REG72_OFFSET 288
#define TARGETC_S00_AXI_SLV_REG73_OFFSET 292
#define TARGETC_S00_AXI_SLV_REG74_OFFSET 296
#define TARGETC_S00_AXI_SLV_REG75_OFFSET 300
#define TARGETC_S00_AXI_SLV_REG76_OFFSET 304
#define TARGETC_S00_AXI_SLV_REG77_OFFSET 308
#define TARGETC_S00_AXI_SLV_REG78_OFFSET 312
#define TARGETC_S00_AXI_SLV_REG79_OFFSET 316
#define TARGETC_S00_AXI_SLV_REG80_OFFSET 320
#define TARGETC_S00_AXI_SLV_REG81_OFFSET 324
#define TARGETC_S00_AXI_SLV_REG82_OFFSET 328
#define TARGETC_S00_AXI_SLV_REG83_OFFSET 332
#define TARGETC_S00_AXI_SLV_REG84_OFFSET 336
#define TARGETC_S00_AXI_SLV_REG85_OFFSET 340
#define TARGETC_S00_AXI_SLV_REG86_OFFSET 344
#define TARGETC_S00_AXI_SLV_REG87_OFFSET 348
#define TARGETC_S00_AXI_SLV_REG88_OFFSET 352
#define TARGETC_S00_AXI_SLV_REG89_OFFSET 356
#define TARGETC_S00_AXI_SLV_REG90_OFFSET 360
#define TARGETC_S00_AXI_SLV_REG91_OFFSET 364
#define TARGETC_S00_AXI_SLV_REG92_OFFSET 368
#define TARGETC_S00_AXI_SLV_REG93_OFFSET 372
#define TARGETC_S00_AXI_SLV_REG94_OFFSET 376
#define TARGETC_S00_AXI_SLV_REG95_OFFSET 380
#define TARGETC_S00_AXI_SLV_REG96_OFFSET 384
#define TARGETC_S00_AXI_SLV_REG97_OFFSET 388
#define TARGETC_S00_AXI_SLV_REG98_OFFSET 392
#define TARGETC_S00_AXI_SLV_REG99_OFFSET 396
#define TARGETC_S00_AXI_SLV_REG100_OFFSET 400
#define TARGETC_S00_AXI_SLV_REG101_OFFSET 404
#define TARGETC_S00_AXI_SLV_REG102_OFFSET 408
#define TARGETC_S00_AXI_SLV_REG103_OFFSET 412
#define TARGETC_S00_AXI_SLV_REG104_OFFSET 416
#define TARGETC_S00_AXI_SLV_REG105_OFFSET 420
#define TARGETC_S00_AXI_SLV_REG106_OFFSET 424
#define TARGETC_S00_AXI_SLV_REG107_OFFSET 428
#define TARGETC_S00_AXI_SLV_REG108_OFFSET 432
#define TARGETC_S00_AXI_SLV_REG109_OFFSET 436
#define TARGETC_S00_AXI_SLV_REG110_OFFSET 440
#define TARGETC_S00_AXI_SLV_REG111_OFFSET 444
#define TARGETC_S00_AXI_SLV_REG112_OFFSET 448
#define TARGETC_S00_AXI_SLV_REG113_OFFSET 452
#define TARGETC_S00_AXI_SLV_REG114_OFFSET 456
#define TARGETC_S00_AXI_SLV_REG115_OFFSET 460
#define TARGETC_S00_AXI_SLV_REG116_OFFSET 464
#define TARGETC_S00_AXI_SLV_REG117_OFFSET 468
#define TARGETC_S00_AXI_SLV_REG118_OFFSET 472
#define TARGETC_S00_AXI_SLV_REG119_OFFSET 476
#define TARGETC_S00_AXI_SLV_REG120_OFFSET 480
#define TARGETC_S00_AXI_SLV_REG121_OFFSET 484
#define TARGETC_S00_AXI_SLV_REG122_OFFSET 488
#define TARGETC_S00_AXI_SLV_REG123_OFFSET 492
#define TARGETC_S00_AXI_SLV_REG124_OFFSET 496
#define TARGETC_S00_AXI_SLV_REG125_OFFSET 500
#define TARGETC_S00_AXI_SLV_REG126_OFFSET 504
#define TARGETC_S00_AXI_SLV_REG127_OFFSET 508
#define TARGETC_S00_AXI_SLV_REG128_OFFSET 512
#define TARGETC_S00_AXI_SLV_REG129_OFFSET 516
#define TARGETC_S00_AXI_SLV_REG130_OFFSET 520
#define TARGETC_S00_AXI_SLV_REG131_OFFSET 524
#define TARGETC_S00_AXI_SLV_REG132_OFFSET 528
#define TARGETC_S00_AXI_SLV_REG133_OFFSET 532
#define TARGETC_S00_AXI_SLV_REG134_OFFSET 536
#define TARGETC_S00_AXI_SLV_REG135_OFFSET 540
#define TARGETC_S00_AXI_SLV_REG136_OFFSET 544
#define TARGETC_S00_AXI_SLV_REG137_OFFSET 548
#define TARGETC_S00_AXI_SLV_REG138_OFFSET 552
#define TARGETC_S00_AXI_SLV_REG139_OFFSET 556
#define TARGETC_S00_AXI_SLV_REG140_OFFSET 560
#define TARGETC_S00_AXI_SLV_REG141_OFFSET 564
#define TARGETC_S00_AXI_SLV_REG142_OFFSET 568
#define TARGETC_S00_AXI_SLV_REG143_OFFSET 572
#define TARGETC_S00_AXI_SLV_REG144_OFFSET 576
#define TARGETC_S00_AXI_SLV_REG145_OFFSET 580
#define TARGETC_S00_AXI_SLV_REG146_OFFSET 584
#define TARGETC_S00_AXI_SLV_REG147_OFFSET 588
#define TARGETC_S00_AXI_SLV_REG148_OFFSET 592
#define TARGETC_S00_AXI_SLV_REG149_OFFSET 596
#define TARGETC_S00_AXI_SLV_REG150_OFFSET 600
#define TARGETC_S00_AXI_SLV_REG151_OFFSET 604
#define TARGETC_S00_AXI_SLV_REG152_OFFSET 608


/**************************** Type Definitions *****************************/
/**
 *
 * Write a value to a TARGETC register. A 32 bit write is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is written.
 *
 * @param   BaseAddress is the base address of the TARGETCdevice.
 * @param   RegOffset is the register offset from the base to write to.
 * @param   Data is the data written to the register.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void TARGETC_mWriteReg(u32 BaseAddress, unsigned RegOffset, u32 Data)
 *
 */
#define TARGETC_mWriteReg(BaseAddress, RegOffset, Data) \
  	Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))

/**
 *
 * Read a value from a TARGETC register. A 32 bit read is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is read from the register. The most significant data
 * will be read as 0.
 *
 * @param   BaseAddress is the base address of the TARGETC device.
 * @param   RegOffset is the register offset from the base to write to.
 *
 * @return  Data is the data from the register.
 *
 * @note
 * C-style signature:
 * 	u32 TARGETC_mReadReg(u32 BaseAddress, unsigned RegOffset)
 *
 */
#define TARGETC_mReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))

/************************** Function Prototypes ****************************/
/**
 *
 * Run a self-test on the driver/device. Note this may be a destructive test if
 * resets of the device are performed.
 *
 * If the hardware system is not built correctly, this function may never
 * return to the caller.
 *
 * @param   baseaddr_p is the base address of the TARGETC instance to be worked on.
 *
 * @return
 *
 *    - XST_SUCCESS   if all self-test code passed
 *    - XST_FAILURE   if any self-test code failed
 *
 * @note    Caching must be turned off for this function to work.
 * @note    Self test may fail if data memory and device are not on the same bus.
 *
 */
XStatus TARGETC_Reg_SelfTest(void * baseaddr_p);

#endif // TARGETC_H
