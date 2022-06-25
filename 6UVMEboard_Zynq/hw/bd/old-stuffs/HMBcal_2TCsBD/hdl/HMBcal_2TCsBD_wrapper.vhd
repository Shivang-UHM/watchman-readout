--Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
--Date        : Sun Apr 10 16:33:54 2022
--Host        : idlab2 running 64-bit Ubuntu 20.04.4 LTS
--Command     : generate_target HMBcal_2TCsBD_wrapper.bd
--Design      : HMBcal_2TCsBD_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity HMBcal_2TCsBD_wrapper is
  port (
    A_DONE : in STD_LOGIC;
    A_DO_1 : in STD_LOGIC;
    A_DO_10 : in STD_LOGIC;
    A_DO_11 : in STD_LOGIC;
    A_DO_12 : in STD_LOGIC;
    A_DO_13 : in STD_LOGIC;
    A_DO_14 : in STD_LOGIC;
    A_DO_15 : in STD_LOGIC;
    A_DO_16 : in STD_LOGIC;
    A_DO_2 : in STD_LOGIC;
    A_DO_3 : in STD_LOGIC;
    A_DO_4 : in STD_LOGIC;
    A_DO_5 : in STD_LOGIC;
    A_DO_6 : in STD_LOGIC;
    A_DO_7 : in STD_LOGIC;
    A_DO_8 : in STD_LOGIC;
    A_DO_9 : in STD_LOGIC;
    A_GCC_RESET : out STD_LOGIC;
    A_HSCLK_N : out STD_LOGIC;
    A_HSCLK_P : out STD_LOGIC;
    A_PCLK : out STD_LOGIC;
    A_RAMP : out STD_LOGIC;
    A_RDAD_CLK : out STD_LOGIC;
    A_RDAD_DIR : out STD_LOGIC;
    A_RDAD_SIN : out STD_LOGIC;
    A_SAMPLESEL_ANY : out STD_LOGIC;
    A_SHOUT : in STD_LOGIC;
    A_SS_INCR : out STD_LOGIC;
    A_SS_LD_DIR : out STD_LOGIC;
    A_SS_LD_SIN : out STD_LOGIC;
    A_SS_RESET : out STD_LOGIC;
    A_WR_CS_S0 : out STD_LOGIC;
    A_WR_CS_S1 : out STD_LOGIC;
    A_WR_CS_S2 : out STD_LOGIC;
    A_WR_CS_S3 : out STD_LOGIC;
    A_WR_CS_S4 : out STD_LOGIC;
    A_WR_CS_S5 : out STD_LOGIC;
    A_WR_RS_S0 : out STD_LOGIC;
    A_WR_RS_S1 : out STD_LOGIC;
    B_DONE : in STD_LOGIC;
    B_DO_1 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_DO_10 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_DO_11 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_DO_12 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_DO_13 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_DO_14 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_DO_15 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_DO_16 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_DO_2 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_DO_3 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_DO_4 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_DO_5 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_DO_6 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_DO_7 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_DO_8 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_DO_9 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_GCC_RESET : out STD_LOGIC;
    B_HSCLK_N : out STD_LOGIC;
    B_HSCLK_P : out STD_LOGIC;
    B_PCLK : out STD_LOGIC;
    B_RAMP : out STD_LOGIC;
    B_RDAD_CLK : out STD_LOGIC;
    B_RDAD_DIR : out STD_LOGIC;
    B_RDAD_SIN : out STD_LOGIC;
    B_SAMPLESEL_ANY : out STD_LOGIC;
    B_SHOUT : in STD_LOGIC;
    B_SS_INCR : out STD_LOGIC;
    B_SS_LD_DIR : out STD_LOGIC;
    B_SS_LD_SIN : out STD_LOGIC;
    B_SS_RESET : out STD_LOGIC;
    B_WR_CS_S0 : out STD_LOGIC;
    B_WR_CS_S1 : out STD_LOGIC;
    B_WR_CS_S2 : out STD_LOGIC;
    B_WR_CS_S3 : out STD_LOGIC;
    B_WR_CS_S4 : out STD_LOGIC;
    B_WR_CS_S5 : out STD_LOGIC;
    B_WR_RS_S0 : out STD_LOGIC;
    B_WR_RS_S1 : out STD_LOGIC;
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_cas_n : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    MONTIMING_N : in STD_LOGIC;
    MONTIMING_P : in STD_LOGIC;
    SCLK : out STD_LOGIC;
    SIN : out STD_LOGIC;
    SSTIN_N : out STD_LOGIC_VECTOR ( 0 to 0 );
    SSTIN_P : out STD_LOGIC_VECTOR ( 0 to 0 );
    WL_CLK_N : out STD_LOGIC_VECTOR ( 0 to 0 );
    WL_CLK_P : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
end HMBcal_2TCsBD_wrapper;

architecture STRUCTURE of HMBcal_2TCsBD_wrapper is
  component HMBcal_2TCsBD is
  port (
    A_DONE : in STD_LOGIC;
    A_DO_1 : in STD_LOGIC;
    A_DO_2 : in STD_LOGIC;
    A_DO_3 : in STD_LOGIC;
    A_DO_4 : in STD_LOGIC;
    A_DO_5 : in STD_LOGIC;
    A_DO_6 : in STD_LOGIC;
    A_DO_7 : in STD_LOGIC;
    A_DO_8 : in STD_LOGIC;
    A_DO_9 : in STD_LOGIC;
    A_DO_10 : in STD_LOGIC;
    A_DO_11 : in STD_LOGIC;
    A_DO_12 : in STD_LOGIC;
    A_DO_13 : in STD_LOGIC;
    A_DO_14 : in STD_LOGIC;
    A_DO_15 : in STD_LOGIC;
    A_DO_16 : in STD_LOGIC;
    A_GCC_RESET : out STD_LOGIC;
    A_HSCLK_N : out STD_LOGIC;
    A_HSCLK_P : out STD_LOGIC;
    A_PCLK : out STD_LOGIC;
    A_RAMP : out STD_LOGIC;
    A_RDAD_CLK : out STD_LOGIC;
    A_RDAD_DIR : out STD_LOGIC;
    A_RDAD_SIN : out STD_LOGIC;
    A_SAMPLESEL_ANY : out STD_LOGIC;
    A_SHOUT : in STD_LOGIC;
    A_SS_INCR : out STD_LOGIC;
    A_SS_LD_DIR : out STD_LOGIC;
    A_SS_LD_SIN : out STD_LOGIC;
    A_SS_RESET : out STD_LOGIC;
    A_WR_CS_S0 : out STD_LOGIC;
    A_WR_CS_S1 : out STD_LOGIC;
    A_WR_CS_S2 : out STD_LOGIC;
    A_WR_CS_S3 : out STD_LOGIC;
    A_WR_CS_S4 : out STD_LOGIC;
    A_WR_CS_S5 : out STD_LOGIC;
    A_WR_RS_S0 : out STD_LOGIC;
    A_WR_RS_S1 : out STD_LOGIC;
    B_DONE : in STD_LOGIC;
    B_DO_1 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_DO_2 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_DO_3 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_DO_4 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_DO_5 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_DO_6 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_DO_7 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_DO_8 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_DO_9 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_DO_10 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_DO_11 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_DO_12 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_DO_13 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_DO_14 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_DO_15 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_DO_16 : in STD_LOGIC_VECTOR ( 0 to 0 );
    B_GCC_RESET : out STD_LOGIC;
    B_HSCLK_N : out STD_LOGIC;
    B_HSCLK_P : out STD_LOGIC;
    B_PCLK : out STD_LOGIC;
    B_RAMP : out STD_LOGIC;
    B_RDAD_CLK : out STD_LOGIC;
    B_RDAD_DIR : out STD_LOGIC;
    B_RDAD_SIN : out STD_LOGIC;
    B_SAMPLESEL_ANY : out STD_LOGIC;
    B_SHOUT : in STD_LOGIC;
    B_SS_INCR : out STD_LOGIC;
    B_SS_LD_DIR : out STD_LOGIC;
    B_SS_LD_SIN : out STD_LOGIC;
    B_SS_RESET : out STD_LOGIC;
    B_WR_CS_S0 : out STD_LOGIC;
    B_WR_CS_S1 : out STD_LOGIC;
    B_WR_CS_S2 : out STD_LOGIC;
    B_WR_CS_S3 : out STD_LOGIC;
    B_WR_CS_S4 : out STD_LOGIC;
    B_WR_CS_S5 : out STD_LOGIC;
    B_WR_RS_S0 : out STD_LOGIC;
    B_WR_RS_S1 : out STD_LOGIC;
    MONTIMING_N : in STD_LOGIC;
    MONTIMING_P : in STD_LOGIC;
    SCLK : out STD_LOGIC;
    SIN : out STD_LOGIC;
    SSTIN_N : out STD_LOGIC_VECTOR ( 0 to 0 );
    SSTIN_P : out STD_LOGIC_VECTOR ( 0 to 0 );
    WL_CLK_N : out STD_LOGIC_VECTOR ( 0 to 0 );
    WL_CLK_P : out STD_LOGIC_VECTOR ( 0 to 0 );
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    DDR_cas_n : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 )
  );
  end component HMBcal_2TCsBD;
begin
HMBcal_2TCsBD_i: component HMBcal_2TCsBD
     port map (
      A_DONE => A_DONE,
      A_DO_1 => A_DO_1,
      A_DO_10 => A_DO_10,
      A_DO_11 => A_DO_11,
      A_DO_12 => A_DO_12,
      A_DO_13 => A_DO_13,
      A_DO_14 => A_DO_14,
      A_DO_15 => A_DO_15,
      A_DO_16 => A_DO_16,
      A_DO_2 => A_DO_2,
      A_DO_3 => A_DO_3,
      A_DO_4 => A_DO_4,
      A_DO_5 => A_DO_5,
      A_DO_6 => A_DO_6,
      A_DO_7 => A_DO_7,
      A_DO_8 => A_DO_8,
      A_DO_9 => A_DO_9,
      A_GCC_RESET => A_GCC_RESET,
      A_HSCLK_N => A_HSCLK_N,
      A_HSCLK_P => A_HSCLK_P,
      A_PCLK => A_PCLK,
      A_RAMP => A_RAMP,
      A_RDAD_CLK => A_RDAD_CLK,
      A_RDAD_DIR => A_RDAD_DIR,
      A_RDAD_SIN => A_RDAD_SIN,
      A_SAMPLESEL_ANY => A_SAMPLESEL_ANY,
      A_SHOUT => A_SHOUT,
      A_SS_INCR => A_SS_INCR,
      A_SS_LD_DIR => A_SS_LD_DIR,
      A_SS_LD_SIN => A_SS_LD_SIN,
      A_SS_RESET => A_SS_RESET,
      A_WR_CS_S0 => A_WR_CS_S0,
      A_WR_CS_S1 => A_WR_CS_S1,
      A_WR_CS_S2 => A_WR_CS_S2,
      A_WR_CS_S3 => A_WR_CS_S3,
      A_WR_CS_S4 => A_WR_CS_S4,
      A_WR_CS_S5 => A_WR_CS_S5,
      A_WR_RS_S0 => A_WR_RS_S0,
      A_WR_RS_S1 => A_WR_RS_S1,
      B_DONE => B_DONE,
      B_DO_1(0) => B_DO_1(0),
      B_DO_10(0) => B_DO_10(0),
      B_DO_11(0) => B_DO_11(0),
      B_DO_12(0) => B_DO_12(0),
      B_DO_13(0) => B_DO_13(0),
      B_DO_14(0) => B_DO_14(0),
      B_DO_15(0) => B_DO_15(0),
      B_DO_16(0) => B_DO_16(0),
      B_DO_2(0) => B_DO_2(0),
      B_DO_3(0) => B_DO_3(0),
      B_DO_4(0) => B_DO_4(0),
      B_DO_5(0) => B_DO_5(0),
      B_DO_6(0) => B_DO_6(0),
      B_DO_7(0) => B_DO_7(0),
      B_DO_8(0) => B_DO_8(0),
      B_DO_9(0) => B_DO_9(0),
      B_GCC_RESET => B_GCC_RESET,
      B_HSCLK_N => B_HSCLK_N,
      B_HSCLK_P => B_HSCLK_P,
      B_PCLK => B_PCLK,
      B_RAMP => B_RAMP,
      B_RDAD_CLK => B_RDAD_CLK,
      B_RDAD_DIR => B_RDAD_DIR,
      B_RDAD_SIN => B_RDAD_SIN,
      B_SAMPLESEL_ANY => B_SAMPLESEL_ANY,
      B_SHOUT => B_SHOUT,
      B_SS_INCR => B_SS_INCR,
      B_SS_LD_DIR => B_SS_LD_DIR,
      B_SS_LD_SIN => B_SS_LD_SIN,
      B_SS_RESET => B_SS_RESET,
      B_WR_CS_S0 => B_WR_CS_S0,
      B_WR_CS_S1 => B_WR_CS_S1,
      B_WR_CS_S2 => B_WR_CS_S2,
      B_WR_CS_S3 => B_WR_CS_S3,
      B_WR_CS_S4 => B_WR_CS_S4,
      B_WR_CS_S5 => B_WR_CS_S5,
      B_WR_RS_S0 => B_WR_RS_S0,
      B_WR_RS_S1 => B_WR_RS_S1,
      DDR_addr(14 downto 0) => DDR_addr(14 downto 0),
      DDR_ba(2 downto 0) => DDR_ba(2 downto 0),
      DDR_cas_n => DDR_cas_n,
      DDR_ck_n => DDR_ck_n,
      DDR_ck_p => DDR_ck_p,
      DDR_cke => DDR_cke,
      DDR_cs_n => DDR_cs_n,
      DDR_dm(3 downto 0) => DDR_dm(3 downto 0),
      DDR_dq(31 downto 0) => DDR_dq(31 downto 0),
      DDR_dqs_n(3 downto 0) => DDR_dqs_n(3 downto 0),
      DDR_dqs_p(3 downto 0) => DDR_dqs_p(3 downto 0),
      DDR_odt => DDR_odt,
      DDR_ras_n => DDR_ras_n,
      DDR_reset_n => DDR_reset_n,
      DDR_we_n => DDR_we_n,
      FIXED_IO_ddr_vrn => FIXED_IO_ddr_vrn,
      FIXED_IO_ddr_vrp => FIXED_IO_ddr_vrp,
      FIXED_IO_mio(53 downto 0) => FIXED_IO_mio(53 downto 0),
      FIXED_IO_ps_clk => FIXED_IO_ps_clk,
      FIXED_IO_ps_porb => FIXED_IO_ps_porb,
      FIXED_IO_ps_srstb => FIXED_IO_ps_srstb,
      MONTIMING_N => MONTIMING_N,
      MONTIMING_P => MONTIMING_P,
      SCLK => SCLK,
      SIN => SIN,
      SSTIN_N(0) => SSTIN_N(0),
      SSTIN_P(0) => SSTIN_P(0),
      WL_CLK_N(0) => WL_CLK_N(0),
      WL_CLK_P(0) => WL_CLK_P(0)
    );
end STRUCTURE;
