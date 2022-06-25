-- (c) Copyright 1995-2022 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: user.org:user:TARGETC_axi_int:2.2
-- IP Revision: 2

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY HMBcal_2TCsBD_TARGETC_axi_int_0_0 IS
  PORT (
    SW_nRST : IN STD_LOGIC;
    TestStream : IN STD_LOGIC;
    FIFOvalid : IN STD_LOGIC;
    FIFOdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    StreamReady : OUT STD_LOGIC;
    Cnt_AXIS_DATA : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    CNT_CLR : IN STD_LOGIC;
    TID : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    NBRWINDOW : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    M_AXIS_ACLK : IN STD_LOGIC;
    M_AXIS_ARESETN : IN STD_LOGIC;
    M_AXIS_TVALID : OUT STD_LOGIC;
    M_AXIS_TDATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    M_AXIS_TSTRB : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    M_AXIS_TDEST : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    M_AXIS_TLAST : OUT STD_LOGIC;
    M_AXIS_TID : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    M_AXIS_TREADY : IN STD_LOGIC
  );
END HMBcal_2TCsBD_TARGETC_axi_int_0_0;

ARCHITECTURE HMBcal_2TCsBD_TARGETC_axi_int_0_0_arch OF HMBcal_2TCsBD_TARGETC_axi_int_0_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF HMBcal_2TCsBD_TARGETC_axi_int_0_0_arch: ARCHITECTURE IS "yes";
  COMPONENT axistream IS
    GENERIC (
      C_M_AXIS_TDATA_WIDTH : INTEGER;
      NBRWINDOW_MAX : INTEGER;
      FIFO_NBR_MAX : INTEGER
    );
    PORT (
      SW_nRST : IN STD_LOGIC;
      TestStream : IN STD_LOGIC;
      FIFOvalid : IN STD_LOGIC;
      FIFOdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      StreamReady : OUT STD_LOGIC;
      Cnt_AXIS_DATA : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
      CNT_CLR : IN STD_LOGIC;
      TID : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      NBRWINDOW : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      M_AXIS_ACLK : IN STD_LOGIC;
      M_AXIS_ARESETN : IN STD_LOGIC;
      M_AXIS_TVALID : OUT STD_LOGIC;
      M_AXIS_TDATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      M_AXIS_TSTRB : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      M_AXIS_TDEST : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
      M_AXIS_TLAST : OUT STD_LOGIC;
      M_AXIS_TID : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      M_AXIS_TREADY : IN STD_LOGIC
    );
  END COMPONENT axistream;
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
  ATTRIBUTE X_INTERFACE_INFO OF M_AXIS_TREADY: SIGNAL IS "xilinx.com:interface:axis:1.0 M00_AXIS TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF M_AXIS_TID: SIGNAL IS "xilinx.com:interface:axis:1.0 M00_AXIS TID";
  ATTRIBUTE X_INTERFACE_INFO OF M_AXIS_TLAST: SIGNAL IS "xilinx.com:interface:axis:1.0 M00_AXIS TLAST";
  ATTRIBUTE X_INTERFACE_INFO OF M_AXIS_TSTRB: SIGNAL IS "xilinx.com:interface:axis:1.0 M00_AXIS TSTRB";
  ATTRIBUTE X_INTERFACE_INFO OF M_AXIS_TDATA: SIGNAL IS "xilinx.com:interface:axis:1.0 M00_AXIS TDATA";
  ATTRIBUTE X_INTERFACE_PARAMETER OF M_AXIS_TVALID: SIGNAL IS "XIL_INTERFACENAME M00_AXIS, WIZ_DATA_WIDTH 32, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 2, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 1, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 1.25e+08, PHASE 0.000, CLK_DOMAIN HMBcal_2TCsBD_processing_system7_0_0_FCLK_CLK0, LAYERED_METADATA undef, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF M_AXIS_TVALID: SIGNAL IS "xilinx.com:interface:axis:1.0 M00_AXIS TVALID";
  ATTRIBUTE X_INTERFACE_PARAMETER OF M_AXIS_ARESETN: SIGNAL IS "XIL_INTERFACENAME M_AXIS_ARESETN, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF M_AXIS_ARESETN: SIGNAL IS "xilinx.com:signal:reset:1.0 M_AXIS_ARESETN RST";
  ATTRIBUTE X_INTERFACE_PARAMETER OF M_AXIS_ACLK: SIGNAL IS "XIL_INTERFACENAME M_AXIS_ACLK, ASSOCIATED_RESET M_AXIS_ARESETN, ASSOCIATED_BUSIF M00_AXIS, FREQ_HZ 1.25e+08, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN HMBcal_2TCsBD_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF M_AXIS_ACLK: SIGNAL IS "xilinx.com:signal:clock:1.0 M_AXIS_ACLK CLK";
BEGIN
  U0 : axistream
    GENERIC MAP (
      C_M_AXIS_TDATA_WIDTH => 32,
      NBRWINDOW_MAX => 8,
      FIFO_NBR_MAX => 1030
    )
    PORT MAP (
      SW_nRST => SW_nRST,
      TestStream => TestStream,
      FIFOvalid => FIFOvalid,
      FIFOdata => FIFOdata,
      StreamReady => StreamReady,
      Cnt_AXIS_DATA => Cnt_AXIS_DATA,
      CNT_CLR => CNT_CLR,
      TID => TID,
      NBRWINDOW => NBRWINDOW,
      M_AXIS_ACLK => M_AXIS_ACLK,
      M_AXIS_ARESETN => M_AXIS_ARESETN,
      M_AXIS_TVALID => M_AXIS_TVALID,
      M_AXIS_TDATA => M_AXIS_TDATA,
      M_AXIS_TSTRB => M_AXIS_TSTRB,
      M_AXIS_TDEST => M_AXIS_TDEST,
      M_AXIS_TLAST => M_AXIS_TLAST,
      M_AXIS_TID => M_AXIS_TID,
      M_AXIS_TREADY => M_AXIS_TREADY
    );
END HMBcal_2TCsBD_TARGETC_axi_int_0_0_arch;
