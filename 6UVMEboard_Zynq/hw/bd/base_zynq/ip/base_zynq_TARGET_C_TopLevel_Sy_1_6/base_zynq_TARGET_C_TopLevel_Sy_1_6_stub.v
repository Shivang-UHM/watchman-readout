// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Thu Jul  8 11:41:57 2021
// Host        : idlab2 running 64-bit Ubuntu 20.04.2 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home2/salvador/github/watchman-readout/6UVMEboard_Zynq/hw/bd/base_zynq/ip/base_zynq_TARGET_C_TopLevel_Sy_1_6/base_zynq_TARGET_C_TopLevel_Sy_1_6_stub.v
// Design      : base_zynq_TARGET_C_TopLevel_Sy_1_6
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "TARGET_C_TopLevel_System,Vivado 2020.2" *)
module base_zynq_TARGET_C_TopLevel_Sy_1_6(SW_nRST, RefCLK_i1, RefCLK_i2, tc_axi_aclk, 
  tc_axi_aresetn, tc_axi_awaddr, tc_axi_awprot, tc_axi_awvalid, tc_axi_awready, tc_axi_wdata, 
  tc_axi_wstrb, tc_axi_wvalid, tc_axi_wready, tc_axi_bresp, tc_axi_bvalid, tc_axi_bready, 
  tc_axi_araddr, tc_axi_arprot, tc_axi_arvalid, tc_axi_arready, tc_axi_rdata, tc_axi_rresp, 
  tc_axi_rvalid, tc_axi_rready, SIN, SCLK, PCLK, SHOUT, HSCLK_P, HSCLK_N, WR_RS_S0, WR_RS_S1, WR_CS_S0, 
  WR_CS_S1, WR_CS_S2, WR_CS_S3, WR_CS_S4, WR_CS_S5, GCC_RESET, WL_CLK, RDAD_CLK, RDAD_SIN, RDAD_DIR, 
  SAMPLESEL_ANY, DO, SS_INCR, DONE, SS_RESET, SS_LD_SIN, SS_LD_DIR, RAMP, SSTIN, MONTIMING_P, 
  MONTIMING_N, Cnt_AXIS_DATA, CNT_CLR, TestStream, FIFOvalid, FIFOdata, StreamReady, TrigA, TrigB, 
  TrigC, TrigD, SSVALID_INTR, hmb_trigger, delay_trigger, sstin_updateBit)
/* synthesis syn_black_box black_box_pad_pin="SW_nRST,RefCLK_i1,RefCLK_i2,tc_axi_aclk,tc_axi_aresetn,tc_axi_awaddr[31:0],tc_axi_awprot[2:0],tc_axi_awvalid,tc_axi_awready,tc_axi_wdata[31:0],tc_axi_wstrb[3:0],tc_axi_wvalid,tc_axi_wready,tc_axi_bresp[1:0],tc_axi_bvalid,tc_axi_bready,tc_axi_araddr[31:0],tc_axi_arprot[2:0],tc_axi_arvalid,tc_axi_arready,tc_axi_rdata[31:0],tc_axi_rresp[1:0],tc_axi_rvalid,tc_axi_rready,SIN,SCLK,PCLK,SHOUT,HSCLK_P,HSCLK_N,WR_RS_S0,WR_RS_S1,WR_CS_S0,WR_CS_S1,WR_CS_S2,WR_CS_S3,WR_CS_S4,WR_CS_S5,GCC_RESET,WL_CLK,RDAD_CLK,RDAD_SIN,RDAD_DIR,SAMPLESEL_ANY,DO[15:0],SS_INCR,DONE,SS_RESET,SS_LD_SIN,SS_LD_DIR,RAMP,SSTIN,MONTIMING_P,MONTIMING_N,Cnt_AXIS_DATA[9:0],CNT_CLR,TestStream,FIFOvalid,FIFOdata[31:0],StreamReady,TrigA,TrigB,TrigC,TrigD,SSVALID_INTR,hmb_trigger,delay_trigger[3:0],sstin_updateBit[2:0]" */;
  output SW_nRST;
  input RefCLK_i1;
  input RefCLK_i2;
  input tc_axi_aclk;
  input tc_axi_aresetn;
  input [31:0]tc_axi_awaddr;
  input [2:0]tc_axi_awprot;
  input tc_axi_awvalid;
  output tc_axi_awready;
  input [31:0]tc_axi_wdata;
  input [3:0]tc_axi_wstrb;
  input tc_axi_wvalid;
  output tc_axi_wready;
  output [1:0]tc_axi_bresp;
  output tc_axi_bvalid;
  input tc_axi_bready;
  input [31:0]tc_axi_araddr;
  input [2:0]tc_axi_arprot;
  input tc_axi_arvalid;
  output tc_axi_arready;
  output [31:0]tc_axi_rdata;
  output [1:0]tc_axi_rresp;
  output tc_axi_rvalid;
  input tc_axi_rready;
  output SIN;
  output SCLK;
  output PCLK;
  input SHOUT;
  output HSCLK_P;
  output HSCLK_N;
  output WR_RS_S0;
  output WR_RS_S1;
  output WR_CS_S0;
  output WR_CS_S1;
  output WR_CS_S2;
  output WR_CS_S3;
  output WR_CS_S4;
  output WR_CS_S5;
  output GCC_RESET;
  output WL_CLK;
  output RDAD_CLK;
  output RDAD_SIN;
  output RDAD_DIR;
  output SAMPLESEL_ANY;
  input [15:0]DO;
  output SS_INCR;
  input DONE;
  output SS_RESET;
  output SS_LD_SIN;
  output SS_LD_DIR;
  output RAMP;
  output SSTIN;
  input MONTIMING_P;
  input MONTIMING_N;
  input [9:0]Cnt_AXIS_DATA;
  output CNT_CLR;
  output TestStream;
  output FIFOvalid;
  output [31:0]FIFOdata;
  input StreamReady;
  input TrigA;
  input TrigB;
  input TrigC;
  input TrigD;
  output SSVALID_INTR;
  input hmb_trigger;
  input [3:0]delay_trigger;
  input [2:0]sstin_updateBit;
endmodule
