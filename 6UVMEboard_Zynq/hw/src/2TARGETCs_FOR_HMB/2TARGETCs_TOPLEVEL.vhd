-------------------------------------------------------
--! @file 	TARGETC_TOPLEVEL.vhd
--!
--! @author	Jonathan Hendriks, Salvador Ventura, Shivang
--! @date	January 2022
--! @version 0.0
-------------------------------------------------------
--! @brief Top level for TARGETC Board for HMB calorimeter readout  IP component
--! Detailed description here, if any.
-------------------------------------------------------

--! Use standard Library
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--! Custom Library for TARGETC
use work.TARGETC_pkg.all;
--! Custom Library for AXI Lite interface
use work.AXI_Lite_pkg.all;


-------------------------------------------------------
--! Entity declaration for TARGETC_IP_Prototype .
-------------------------------------------------------
entity TwoTARGET_C_TopLevel_System is
	-- Generic Parameters :

	-- Port Parameters :
	port (


		SW_nRST:	out std_logic;
		--! @name Reference Clock
		RefCLK_i1 :		in std_logic;	--! Clock for the TARGETC PLL
		RefCLK_i2 :		in std_logic;	--! Clock for the TARGETC PLL

		--! @name Ports of Axi Slave Bus Interface TC_AXI
		tc_axi_aclk		: in std_logic;
		tc_axi_aresetn	: in std_logic;
		tc_axi_awaddr	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		tc_axi_awprot	: in std_logic_vector(2 downto 0);
		tc_axi_awvalid	: in std_logic;
		tc_axi_awready	: out std_logic;
		tc_axi_wdata	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		tc_axi_wstrb	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		tc_axi_wvalid	: in std_logic;
		tc_axi_wready	: out std_logic;
		tc_axi_bresp	: out std_logic_vector(1 downto 0);
		tc_axi_bvalid	: out std_logic;
		tc_axi_bready	: in std_logic;
		tc_axi_araddr	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		tc_axi_arprot	: in std_logic_vector(2 downto 0);
		tc_axi_arvalid	: in std_logic;
		tc_axi_arready	: out std_logic;
		tc_axi_rdata	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		tc_axi_rresp	: out std_logic_vector(1 downto 0);
		tc_axi_rvalid	: out std_logic;
		tc_axi_rready	: in std_logic;

                SSTIN :         out std_logic;

		MONTIMING_P:	in	std_logic;		
		MONTIMING_N:	in	std_logic;		
		SIN : 			out	STD_LOGIC;		--! SIN, Serial Input, Pin#35
		SCLK :	 		out	STD_LOGIC;	
		WL_CLK: 		out std_logic;		
		DO_A_B: 			in 	std_logic_vector(31 downto 0);	
        CNT_CLR_A_B:   out std_logic ;
		-- TARGET C 0

		A_PCLK :	 		out	STD_LOGIC;	
		A_SHOUT:			in 	std_logic;	

		A_HSCLK_P:		out std_logic;		
		A_HSCLK_N:		out std_logic;		

		A_WR_RS_S0:		out	std_logic;	
		A_WR_RS_S1:		out	std_logic;

		A_WR_CS_S0:		out	std_logic;
		A_WR_CS_S1:		out	std_logic;
		A_WR_CS_S2:		out	std_logic;
		A_WR_CS_S3:		out	std_logic;
		A_WR_CS_S4:		out	std_logic;
		A_WR_CS_S5:		out	std_logic;

		A_GCC_RESET:		out	std_logic;	


		A_RDAD_CLK:		out	std_logic;	
		A_RDAD_SIN:		out	std_logic;	
		A_RDAD_DIR:		out	std_logic;	

		A_SAMPLESEL_ANY:	out	std_logic;	


		A_SS_INCR:		out	std_logic;	


		A_DONE:			in	std_logic;	

		A_SS_RESET:		out	std_logic;	


		A_SS_LD_SIN:		out	std_logic;	
		A_SS_LD_DIR:		out	std_logic;	

		A_RAMP:			out	std_logic;	
		Cnt_AXIS_DATA:	in	std_logic_vector(9 downto 0);


--                   TARGETC 1

		B_PCLK :	 		out	STD_LOGIC;	
		B_SHOUT:			in 	std_logic;	

		B_HSCLK_P:		out std_logic;		
		B_HSCLK_N:		out std_logic;		

		B_WR_RS_S0:		out	std_logic;	
		B_WR_RS_S1:		out	std_logic;

		B_WR_CS_S0:		out	std_logic;
		B_WR_CS_S1:		out	std_logic;
		B_WR_CS_S2:		out	std_logic;
		B_WR_CS_S3:		out	std_logic;
		B_WR_CS_S4:		out	std_logic;
		B_WR_CS_S5:		out	std_logic;

		B_GCC_RESET:		out	std_logic;	


		B_RDAD_CLK:		out	std_logic;	
		B_RDAD_SIN:		out	std_logic;	
		B_RDAD_DIR:		out	std_logic;	

		B_SAMPLESEL_ANY:	out	std_logic;	

--		B_DO: 			in 	std_logic_vector(15 downto 0);	

		B_SS_INCR:		out	std_logic;	


		B_DONE:			in	std_logic;	

		B_SS_RESET:		out	std_logic;	



		B_SS_LD_SIN:		out	std_logic;	
		B_SS_LD_DIR:		out	std_logic;	

		B_RAMP:			out	std_logic;	

	


--		B_Cnt_AXIS_DATA:	in	std_logic_vector(9 downto 0);
		
	
		-- DATA TO STREAM
		TestStream : 		out std_logic;
		FIFOvalid:			out std_logic;
		FIFOdata:			out std_logic_vector(31 downto 0);
		StreamReady:		in	std_logic;
    --    NbrWindow:		    out std_logic_vector(31 downto 0);
        
	-- TRIGGER FROM BOARD NOT NEEDED FOR HMB CALORIMETERS EXTERNAL TRIGGER WILL BE PROVIDED
		-- Trigger
--		TrigA :			in std_logic;
--		TrigB :			in std_logic;
--		TrigC :			in std_logic;
--		TrigD :			in std_logic;

        -- window storage master control
--        WS_masterctrl_in :  in std_logic;
--        WS_masterctrl_out : out std_logic;
        
		-- Interrupt SIGNALS
		SSVALID_INTR:	out	std_logic;


        --MULTIPLE TC ctrl signals

 --signals for the HMB roundbuffer
         hmb_trigger :    in std_logic;
        delay_trigger:    in std_logic_vector(3 downto 0);
        sstin_updateBit:   in std_logic_vector(2 downto 0) ;
         mode :  	in std_logic ;
         windowstorage: in std_logic -- Digitization process  start n falling edge of windowstorage (user mode)


--		-- DEBUG OUTPUTs
--		BB1 :	out std_logic;
--		BB2 :	out std_logic;
--		BB3 :	out std_logic;
--		BB4 :	out std_logic;
--		BB5 :	out std_logic
	
	
		
	);
	
	
	     
	      
	      
end TwoTARGET_C_TopLevel_System;

-------------------------------------------------------
--! @brief architecture definition of TARGETC_IP_Prototype
architecture arch_imp of TwoTARGET_C_TopLevel_System is

	-------------------------------------------------------
	-- Component Declaration
	-------------------------------------------------------

	--! Clock Management for the different CLK needed inside the ASIC
	component TC_ClockManagementV3 is
	port (
	-- TARGET C Ports for control and function
		nrst:			in	std_logic;
	--	clk1:			in 	std_logic;	-- Clock for the TARGETC SCLK
	--	clk2:			in 	std_logic;	-- Clock for the TARGETC SCLK

		axi_clk:		in	std_logic;
		WL_CLK_DIV:		in 	std_logic_vector(31 downto 0); -- Clock Divider Through DFF

		PLL_LOCKED:		out	std_logic;

		ClockBus:		out T_ClockBus;

		Timecounter:	out std_logic_vector(63 downto 0);
		Timestamp:		out T_timestamp;
		--GrayTimeCnt:	out std_logic_vector(63 downto 0);

		HSCLKdif:		in std_logic;		-- Pin#43 to Pin#44

		-- LVDS Differential Pair
		A_HSCLK_P    	:out std_logic;
		A_HSCLK_N 		:out std_logic;
		B_HSCLK_P 		:out std_logic;
		B_HSCLK_N 		:out std_logic;


		WLCLK:		out std_logic		-- Pin#57
--		WL_CLK_N:		out std_logic		-- Pin#58

--		SSTIN_P:		out std_logic;		-- Pin#125
--		SSTIN_N:		out std_logic		-- Pin#126

	);
	end component TC_ClockManagementV3;

	--! Communication with PS side through AXI Lite and Control Signals
	component TwoTC_Control is
	port (
	-- TARGET C Ports for control and functi

		AxiBusIn:		in AXI_Lite_Inputs;
		AxiBusOut:		out AXI_Lite_Outputs;
        WindowStorage:   in std_logic ;

		ClockBus:		in T_ClockBus;
		CtrlBus_OxMS:		out T_CtrlBus_OxMS;
		CtrlBus_IxMS:		in 	T_CtrlBus_IxMS
	);
	end component TwoTC_Control;

	--! Register Communication between FPGA and ASIC
	component TARGETX_DAC_CONTROL is
		generic (
			constant REGISTER_WIDTH : integer := 19-- needs to change, change the name of the file to TargetX DAC control this is actually 19 now
		 );
		Port (
				CLK : 				in  STD_LOGIC;
				PCLK_LATCH_PERIOD:	in	STD_LOGIC_VECTOR(15 downto 0);
				PCLK_TRANSITION_PERIOD:	in	STD_LOGIC_VECTOR(15 downto 0);

				LOAD_PERIOD : 		in  STD_LOGIC_VECTOR(15 downto 0);
				LATCH_PERIOD : 		in  STD_LOGIC_VECTOR(15 downto 0);
				-- UPDATE : 			in  STD_LOGIC;
				-- REG_DATA_IN : 		in  STD_LOGIC_VECTOR(18 downto 0);
				-- REG_DATA_OUT : 		out std_logic_vector(18 downto 0);
		       	-- busy		: 		out std_logic;

	            CtrlBus_IxSL:		in 	T_CtrlBus_IxSL; --Outputs from Control Master
	    		--CtrlBus_OxSL:		out	T_CtrlBus_OxSL; --Outputs from Control Master
				TC_BUS: 		out std_logic_vector(18 downto 0);
				BUSY:			out std_logic;

				SIN : out  STD_LOGIC;
		       	SCLK : out  STD_LOGIC;
		       	PCLK : out  STD_LOGIC;
		       	SHOUT: in	STD_LOGIC);
	end component TARGETX_DAC_CONTROL;

	component RoundBufferV6 is
--		generic(
--			NBRWINDOWS : integer := 128
--		);
		port(
			--nrst : 			in	std_Logic;
			ClockBus:		in T_ClockBus;
			Timecounter:	in std_logic_vector(63 downto 0);
			Timestamp:		in T_timestamp;
			--GrayTimeCnt:	in std_logic_vector(63 downto 0);

			trigger : 		in std_logic_vector(3 downto 0);

			WR_R:		out std_logic_vector(1 downto 0);
			WR_C:		out std_logic_vector(5 downto 0);

			CtrlBus_IxSL:		in 	T_CtrlBus_IxSL; --Outputs from Control Master
			--CtrlBus_OxSL:		out	T_CtrlBus_OxSL; --Outputs from Control Master

			RBNbrOfPackets: out std_logic_vector(7 downto 0);

			RDAD_ReadEn  :in  std_logic;
			RDAD_DataOut : out std_logic_vector(8 downto 0);
			RDAD_Empty	: out std_logic;

			AXI_ReadEn:	in	std_logic;
			AXI_Time_DataOut : out std_logic_vector(63 downto 0);
			AXI_WdoAddr_DataOut : out std_logic_vector(8 downto 0);
			AXI_TrigInfo_DataOut : out std_logic_vector(11 downto 0);
			AXI_Spare_DataOut :	out std_logic_vector(10 downto 0);
			AXI_Empty	: out std_logic;

			-- FIFO IN for Digiting
		    DIG_Full	: out	std_logic;
		    DIG_DataIn	: in	std_logic_vector(8 downto 0);
		    DIG_WriteEn	: in	std_logic;
		   
            --signals for the HMB roundbuffer
            hmb_trigger:  in std_logic;
            mode: 	in std_logic ;
          delay_trigger:    in std_logic_vector(3 downto 0);
            sstin_updateBit:   in std_logic_vector(2 downto 0); 		   		   
		   
	    -- Signal for trigger the acquisition for debugging
		    address_is_zero_out : out std_logic
		 
		);
	end component RoundBufferV6;
	

	component TwoTARGETC_RDAD_WL_SMPL is
		Port (
		--CLK : 			in  STD_LOGIC;
		--RST : 			in	STD_Logic;

		DISCH_PERIOD :	in	std_logic_vector(15 downto 0);
		INCR_WAIT_PERIOD:	in std_logic_vector(15 downto 0);

		ClockBus:		in T_ClockBus;
		--TimeCounter:	in std_logic_vector(63 downto 0);

		RDAD_CLK:		out	std_logic;		-- Pin#61
		RDAD_SIN:		out	std_logic;		-- Pin#62
		RDAD_DIR:		out	std_logic;		-- Pin#63

		-- Fifo from storage
		RDAD_ReadEn  :	out	std_logic;
		RDAD_DataOut : 	in	std_logic_vector(8 downto 0);
		--RDAD_CLK     :	out	std_logic;	-- RDAD CLK
		RDAD_Empty	: 	in 	std_logic;

		-- FIFO IN for Digiting
		DIG_Full	: in	std_logic;
		DIG_DataIn	: out	std_logic_vector(8 downto 0);
		DIG_WriteEn	: out	std_logic;

		RAMP:			out	std_logic;
		GCC_RESET:		out	std_logic;

		HSCLK : 			out  STD_LOGIC;

		DO_A_B : 			in std_logic_vector(31 downto 0);
		SS_INCR:		out std_logic;
		SS_RESET:		out std_logic;

		CtrlBus_IxSL:		in 	T_CtrlBus_IxSL; --Outputs from Control Master
		--CtrlBus_OxSL:		out	T_CtrlBus_OxSL; --Outputs from Control Master
		WindowBusy:		out std_logic;
		RAMP_CNT:		out std_logic;
		DO_BUS:			out eDO_BUS_TYPE_2TC;
		SSvalid:		out std_logic;

	--Channels
	A_CH0 :			out	std_logic_vector(11 downto 0);
	A_CH1 :			out	std_logic_vector(11 downto 0);
	A_CH2 :			out	std_logic_vector(11 downto 0);
	A_CH3 :			out	std_logic_vector(11 downto 0);
	
	A_CH4 :			out	std_logic_vector(11 downto 0);
	A_CH5 :			out	std_logic_vector(11 downto 0);
	A_CH6 :			out	std_logic_vector(11 downto 0);
	A_CH7 :			out	std_logic_vector(11 downto 0);

	A_CH8 :			out	std_logic_vector(11 downto 0);
	A_CH9 :			out	std_logic_vector(11 downto 0);
	A_CH10 :			out	std_logic_vector(11 downto 0);
	A_CH11 :			out	std_logic_vector(11 downto 0);

	A_CH12 :			out	std_logic_vector(11 downto 0);
	A_CH13 :			out	std_logic_vector(11 downto 0);
	A_CH14 :			out	std_logic_vector(11 downto 0);
	A_CH15 :			out	std_logic_vector(11 downto 0);

	B_CH0 :			out	std_logic_vector(11 downto 0);
	B_CH1 :			out	std_logic_vector(11 downto 0);
	B_CH2 :			out	std_logic_vector(11 downto 0);
	B_CH3 :			out	std_logic_vector(11 downto 0);

	B_CH4 :			out	std_logic_vector(11 downto 0);
	B_CH5 :			out	std_logic_vector(11 downto 0);
	B_CH6 :			out	std_logic_vector(11 downto 0);
	B_CH7 :			out	std_logic_vector(11 downto 0);

	B_CH8 :			out	std_logic_vector(11 downto 0);
	B_CH9 :			out	std_logic_vector(11 downto 0);
	B_CH10 :			out	std_logic_vector(11 downto 0);
	B_CH11 :			out	std_logic_vector(11 downto 0);

	B_CH12 :			out	std_logic_vector(11 downto 0);
	B_CH13 :			out	std_logic_vector(11 downto 0);
	B_CH14 :			out	std_logic_vector(11 downto 0);
	B_CH15 :			out	std_logic_vector(11 downto 0);

		--Request and Acknowledge -
		Handshake_IxSEND:	in 	T_Handshake_IxSEND;
		Handshake_Data:		out T_Handshake_SS_FIFO;
		Handshake_OxSEND:	out T_Handshake_OxSEND
	);
	end component TwoTARGETC_RDAD_WL_SMPL;

	component TwoTARGETCs_FifoManager is
		generic (
			C_M_AXIS_TDATA_WIDTH	: integer	:= 32
		);
		port (
			CtrlBus_IxSL:		in 	T_CtrlBus_IxSL; --Outputs from Control Master
			--CtrlBus_OxSL:		out	T_CtrlBus_OxSL; --Outputs from Control Master
			FIFOBusy:		out std_logic;

			ClockBus:		in T_ClockBus;

			--Request and Acknowledge - READOUT
			Handshake_IxRECV:	in 	T_Handshake_IxRECV;
			Handshake_Data:		in T_Handshake_SS_FIFO;
			Handshake_OxRECV:	out T_Handshake_OxRECV;

			--Header Information from FIFO
			FIFO_ReadEn:	out	std_logic;
			FIFO_Time : 	in 	std_logic_vector(63 downto 0);
			FIFO_WdoAddr : 	in 	std_logic_vector(8 downto 0);
			FIFO_TrigInfo : in 	std_logic_vector(11 downto 0);
			FIFO_Spare :	in 	std_logic_vector(10 downto 0);
			FIFO_Empty	: 	in 	std_logic;

			--Channels
        CH0 :			in	std_logic_vector(11 downto 0);
		CH1 :			in	std_logic_vector(11 downto 0);
		CH2 :			in	std_logic_vector(11 downto 0);
		CH3 :			in	std_logic_vector(11 downto 0);

		CH4 :			in	std_logic_vector(11 downto 0);
		CH5 :			in	std_logic_vector(11 downto 0);
		CH6 :			in	std_logic_vector(11 downto 0);
		CH7 :			in	std_logic_vector(11 downto 0);

		CH8 :			in	std_logic_vector(11 downto 0);
		CH9 :			in	std_logic_vector(11 downto 0);
		CH10 :			in	std_logic_vector(11 downto 0);
		CH11 :			in	std_logic_vector(11 downto 0);

		CH12 :			in	std_logic_vector(11 downto 0);
		CH13 :			in	std_logic_vector(11 downto 0);
		CH14 :			in	std_logic_vector(11 downto 0);
		CH15 :			in	std_logic_vector(11 downto 0);
		CH16 :			in	std_logic_vector(11 downto 0);
		CH17 :			in	std_logic_vector(11 downto 0);
		CH18 :			in	std_logic_vector(11 downto 0);
		CH19 :			in	std_logic_vector(11 downto 0);

		CH20 :			in	std_logic_vector(11 downto 0);
		CH21 :			in	std_logic_vector(11 downto 0);
		CH22 :			in	std_logic_vector(11 downto 0);
		CH23 :			in	std_logic_vector(11 downto 0);

		CH24 :			in	std_logic_vector(11 downto 0);
		CH25 :			in	std_logic_vector(11 downto 0);
		CH26 :			in	std_logic_vector(11 downto 0);
		CH27 :			in	std_logic_vector(11 downto 0);

		CH28 :			in	std_logic_vector(11 downto 0);
		CH29 :			in	std_logic_vector(11 downto 0);
		CH30 :			in	std_logic_vector(11 downto 0);
		CH31 :			in	std_logic_vector(11 downto 0);
			
			-- DATA TO STREAM
			FIFOvalid:			out std_logic;
			FIFOdata:			out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
			StreamReady:		in	std_logic
		);
	end component TwoTARGETCs_FifoManager;
	--! Input LVDS_25 Buffer to single ended signal
	component IBUFDS is
	generic(
		IOSTANDARD : string := "LVDS_25");
	port(
		O : 		out std_logic ;
		I : 		in std_logic ;
		IB : 		in std_logic
		);
	end component;

	component DebugCore is
	port(
		O : 		out std_logic ;
		sel:		in	std_logic_vector(2 downto 0);
		I : 		in std_logic_vector(7 downto 0)
		);
	end component;
	
	component SyncBit is 
                  generic (
                     SYNC_STAGES_G  : integer := 2;
                     CLK_POL_G      : std_logic := '1';
                     RST_POL_G      : std_logic := '1';
                     INIT_STATE_G   : std_logic := '0';
                     GATE_DELAY_G   : time := 1 ns
                  );
                  port ( 
                     -- Clock and reset
                     clk         : in  std_logic;
                     rst         : in  std_logic := '0';
                     -- Incoming bit, asynchronous
                     asyncBit    : in  std_logic;
                     -- Outgoing bit, synced to clk
                     syncBit     : out std_logic
                  ); 
               end component;


	-------------------------------------------------------
	-- Signal Declaration
	-------------------------------------------------------

	signal ClockBus_intl:	T_ClockBus;	--! internal clock signal
	signal SSTIN_intl : std_logic;
	signal CtrlBusIn_intl:		T_CtrlBus_IxMS_Intl;
	signal CtrlBusOut_intl:		T_CtrlBus_OxMS_Intl;

	signal WR_CS_S_intl:	std_logic_vector(5 downto 0);
	signal WR_RS_S_intl:	std_logic_vector(1 downto 0);

	signal hsclk_dif :		std_logic;
    signal PCLK_intl: std_logic;
    signal RDAD_CLK_intl: std_logic ;
	signal  RDAD_SIN_intl: std_logic;
	signal RDAD_DIR_intl: std_logic;
	signal RAMP_intl: std_logic;
	signal GCC_RESET_intl: std_logic;
	signal  DO_intl: std_logic_vector(15 downto 0);
	signal SS_INCR_intl: std_logic;
	signal SS_RESET_intl: std_logic;

	-- Dummy Signals
	signal tc_axi_intr:		std_logic;

	signal RDAD_ReadEn_intl  :  std_logic;
	signal RDAD_DataOut_intl : std_logic_vector(8 downto 0);
    signal RDAD_Empty_intl     :  std_logic;

    signal DIG_DataIn_intl	: std_logic_vector(8 downto 0);
    signal DIG_WriteEn_intl	: std_logic;
    signal DIG_Full_intl	: std_logic;

    signal timecounter_intl : std_logic_vector(63 downto 0);
	signal GrayTimeCnt_intl:	std_logic_vector(63 downto 0);
	signal timestamp_intl:		T_timestamp;

--	signal nTrigA, nTrigB, nTrigC, nTrigD : std_logic;

	signal trigger_intl : std_logic_vector(3 downto 0);
	signal TriggerInfor_intl : std_logic_vector(11 downto 0);

	signal 	FIFO_ReadEn_intl : std_logic;
	signal 	FIFO_Time_intl : std_logic_Vector(63 downto 0);
	signal 	FIFO_WdoAddr_intl : std_logic_vector(8 downto 0);
	signal 	FIFO_TrigInfo_intl: std_logic_vector(11 downto 0);
	signal 	FIFO_Spare_intl:	std_logic_vector(10 downto 0);
	signal 	FIFO_Empty_intl:	std_logic;

	signal Handshake_IxSEND_intl : T_Handshake_IxSEND;
	signal Handshake_SS_FIFO: T_Handshake_SS_FIFO;
	signal Handshake_OxSEND_intl : T_Handshake_OxSEND;

	signal A_CH0_intl : std_logic_vector(11 downto 0);
	signal A_CH1_intl : std_logic_vector(11 downto 0);
	signal A_CH2_intl : std_logic_vector(11 downto 0);
	signal A_CH3_intl : std_logic_vector(11 downto 0);

	signal A_CH4_intl : std_logic_vector(11 downto 0);
	signal A_CH5_intl : std_logic_vector(11 downto 0);
	signal A_CH6_intl : std_logic_vector(11 downto 0);
	signal A_CH7_intl : std_logic_vector(11 downto 0);

	signal A_CH8_intl : std_logic_vector(11 downto 0);
	signal A_CH9_intl : std_logic_vector(11 downto 0);
	signal A_CH10_intl : std_logic_vector(11 downto 0);
	signal A_CH11_intl : std_logic_vector(11 downto 0);

	signal A_CH12_intl : std_logic_vector(11 downto 0);
	signal A_CH13_intl : std_logic_vector(11 downto 0);
	signal A_CH14_intl : std_logic_vector(11 downto 0);
	signal A_CH15_intl : std_logic_vector(11 downto 0);
	
	signal B_CH0_intl : std_logic_vector(11 downto 0);
	signal B_CH1_intl : std_logic_vector(11 downto 0);
	signal B_CH2_intl : std_logic_vector(11 downto 0);
	signal B_CH3_intl : std_logic_vector(11 downto 0);

	signal B_CH4_intl : std_logic_vector(11 downto 0);
	signal B_CH5_intl : std_logic_vector(11 downto 0);
	signal B_CH6_intl : std_logic_vector(11 downto 0);
	signal B_CH7_intl : std_logic_vector(11 downto 0);

	signal B_CH8_intl : std_logic_vector(11 downto 0);
	signal B_CH9_intl : std_logic_vector(11 downto 0);
	signal B_CH10_intl : std_logic_vector(11 downto 0);
	signal B_CH11_intl : std_logic_vector(11 downto 0);

	signal B_CH12_intl : std_logic_vector(11 downto 0);
	signal B_CH13_intl : std_logic_vector(11 downto 0);
	signal B_CH14_intl : std_logic_vector(11 downto 0);
	signal B_CH15_intl : std_logic_vector(11 downto 0);
    signal DO_A_B_intl: std_logic_vector(31 downto 0);

	--DEBUG Signals
	signal MONTIMING_s : std_logic;
    signal MONTIMING_inverted : std_logic;
	signal Debug_intl : std_logic_vector(7 downto 0);
	signal Debug_RoundBuffer : std_logic_vector(7 downto 0);
    -- Signal for trigger the acquisition for debugging
    
    signal address_is_zero_intl :  std_logic;
    signal cnt_clr_intl :  std_logic;

	-- -------------------------------------------------------------
	-- Constraints on Signals
	-- -------------------------------------------------------------
	attribute DONT_TOUCH : string;
	attribute DONT_TOUCH of TC_RoundBuffer: label is "TRUE";
	
	attribute mark_debug : string; 
    attribute mark_debug of WR_CS_S_intl: signal is "true";
    attribute mark_debug of WR_RS_S_intl: signal is "true";
--    attribute mark_debug of tc_axi_aclk: signal is "true";
--    attribute mark_debug of tc_axi_aresetn: signal is "true";
begin


	TC_ClockMgmt_inst : TC_ClockManagementV3
	port map(
		nrst				=> CtrlBusOut_intl.SW_nRST,
		--rst				=> tc_axi_aresetn,
--		clk1		 		=> RefCLK_i1,
--		clk2		 		=> RefCLK_i2,
		axi_clk				=> tc_axi_aclk,
		WL_CLK_DIV 		=> CtrlBusOut_intl.WL_CLK_DIV,
		PLL_LOCKED		=> CtrlBusIn_intl.PLL_LOCKED,
		--PLL_LOCKED		=> Test,

		ClockBus	=> ClockBus_intl,

		timecounter	=> timecounter_intl,
		TimeStamp => TimeStamp_intl,
		--GrayTimeCnt		=> GrayTimeCnt_intl,

		HSCLKdif		=> HSCLK_dif,
		-- LVDS Differential Pair

		A_HSCLK_P 		=> A_HSCLK_P,
		A_HSCLK_N 		=> A_HSCLK_N,
		B_HSCLK_P 		=> B_HSCLK_P,
		B_HSCLK_N 		=> B_HSCLK_N,

		WLCLK		=> WL_CLK
--		WL_CLK_N 		=> WL_CLK_N

--		SSTIN_P 		=> SSTIN_P,
--		SSTIN_N 		=> SSTIN_N
	);

	TC_Control_inst : TwoTC_Control
	port map(
		AxiBusIn.ACLK		=> tc_axi_aclk,
		AxiBusIn.ARESETN	=> tc_axi_aresetn,
		AxiBusIn.AWADDR		=> tc_axi_awaddr,
		AxiBusIn.AWPROT		=> tc_axi_awprot,
		AxiBusIn.AWVALID	=> tc_axi_awvalid,
		AxiBusIn.WDATA		=> tc_axi_wdata,
		AxiBusIn.WSTRB		=> tc_axi_wstrb,
		AxiBusIn.WVALID		=> tc_axi_wvalid,
		AxiBusIn.BREADY		=> tc_axi_bready,
		AxiBusIn.ARADDR		=> tc_axi_araddr,
		AxiBusIn.ARPROT		=> tc_axi_arprot,
		AxiBusIn.ARVALID	=> tc_axi_arvalid,
		AxiBusIn.RREADY		=> tc_axi_rready,

		AxiBusOut.AWREADY	=> tc_axi_awready,
		AxiBusOut.WREADY	=> tc_axi_wready,
		AxiBusOut.BRESP		=> tc_axi_bresp,
		AxiBusOut.BVALID	=> tc_axi_bvalid,
		AxiBusOut.ARREADY	=> tc_axi_arready,
		AxiBusOut.RDATA		=> tc_axi_rdata,
		AxiBusOut.RRESP		=> tc_axi_rresp,
		AxiBusOut.RVALID	=> tc_axi_rvalid,
		AxiBusOut.intr		=> tc_axi_intr,
        
		ClockBus			=> ClockBus_intl,
		WindowStorage =>  WindowStorage,
--        WS_master_ctrl      => WS_masterctrl_in,
		CtrlBus_OxMS			=> CtrlBusOut_intl,
		CtrlBus_IxMS			=> CtrlBusIn_intl
	);



	TC_SerialRegCtrl_inst : TARGETX_DAC_CONTROL
		generic map(
		REGISTER_WIDTH =>19
		)
		Port map(
		CLK 		=> ClockBus_intl.SCLK,
		PCLK_LATCH_PERIOD 		=> x"0005",	--With SCLK (brut) 50 MHz, 20ns * 5 = 100ns High period
		PCLK_TRANSITION_PERIOD 	=> x"0003",
		LOAD_PERIOD 	=> (others => '0'),
		LATCH_PERIOD 	=> (others => '0'),
		-- UPDATE 			=> CtrlBusOut_intl.WRITEREG,
		-- REG_DATA_IN 	=> CtrlBusOut_intl.TC_BUS,
		-- REG_DATA_OUT 	=> CtrlBusIn_intl.TC_BUS,
		-- busy		 	=> CtrlBusIn_intl.BUSY,
		CtrlBus_IxSL			=> CtrlBusOut_intl,
		--CtrlBus_OxSL			=> CtrlBusIn_intl,
		TC_BUS				=> CtrlBusIn_intl.TC_BUS,
		BUSY				=> CtrlBusIn_intl.BUSY,

		SIN 	=> SIN,
		SCLK 	=> SCLK,
		PCLK 	=> PCLK_intl,
		SHOUT	=> A_SHOUT
	);

	TC_RoundBuffer : RoundBufferV6
--		generic map(
--			NBRWINDOWS => 256
--		)
		port map(
			--nrst 		=> CtrlBusOut_intl.SW_nRST,
			ClockBus	=> 	ClockBus_intl,
			Timecounter	=> timecounter_intl,
			TimeStamp => TimeStamp_intl,
			--GrayTimeCnt => GrayTimeCnt_intl,

			trigger		=> trigger_intl,

			WR_R		=> WR_RS_S_intl,
			WR_C	=> WR_CS_S_intl,

			CtrlBus_IxSL		=> CtrlBusOut_intl,
			--CtrlBus_OxSL		=> CtrlBusIn_intl,
			RBNbrOfPackets	=> CtrlBusIn_intl.RBNbrOfPackets,

			RDAD_ReadEn  => RDAD_ReadEn_intl,
			RDAD_DataOut => RDAD_DataOut_intl,
			RDAD_Empty	=> RDAD_Empty_intl,

			-- FIFO <-> AXI Connection
			AXI_ReadEn				=> FIFO_ReadEn_intl,
			AXI_Time_DataOut		=> FIFO_Time_intl,
			AXI_WdoAddr_DataOut		=> FIFO_WdoAddr_intl,
			AXI_TrigInfo_DataOut	=> FIFO_TrigInfo_intl,
			AXI_Spare_DataOut 		=> FIFO_Spare_intl,
			AXI_Empty				=> FIFO_Empty_intl,

			-- FIFO IN for Digiting
			DIG_Full	=> DIG_Full_intl,
			DIG_DataIn	=> DIG_DataIn_intl,
			DIG_WriteEn	=> DIG_WriteEn_intl,
			
			
			 --signals for the HMB roundbuffer
			 hmb_trigger => hmb_trigger,
			 mode => mode,
        delay_trigger => delay_trigger,
        sstin_updateBit => sstin_updateBit, 
			
			
			
	  -- Signal for trigger the acquisition for debugging
            address_is_zero_out => address_is_zero_intl
            
            
            
		);

	TC_RDAD_WL_SS :	 TwoTARGETC_RDAD_WL_SMPL
	Port map(
		--RST 	=> CtrlBusOut_intl.SW_nRST,

		DISCH_PERIOD	=> x"0064",
		INCR_WAIT_PERIOD => x"0032",

		ClockBus	=> ClockBus_intl,
		--TimeCounter	=> timecounter_intl,
		RDAD_CLK		=> RDAD_CLK_intl,
		RDAD_SIN		=> RDAD_SIN_intl,
		RDAD_DIR		=> RDAD_DIR_intl,

		-- Fifo from storage
		RDAD_ReadEn	=> RDAD_ReadEn_intl,
		RDAD_DataOut => RDAD_DataOut_intl,
		RDAD_Empty	=> RDAD_Empty_intl,

		-- FIFO IN for Digiting
		DIG_Full	=> DIG_Full_intl,
		DIG_DataIn		=> DIG_DataIn_intl,
		DIG_WriteEn	=> DIG_WriteEn_intl,

		RAMP			=> RAMP_intl,
		GCC_RESET		=> GCC_RESET_intl,

		HSCLK		=> HSCLK_dif,

		-- Data Readout
		DO_A_B 		=> DO_A_B_intl,
		SS_INCR	=> SS_INCR_intl,
		SS_RESET => SS_RESET_intl,

		CtrlBus_IxSL		=> CtrlBusOut_intl,
		--CtrlBus_OxSL		=> CtrlBusIn_intl,
		WindowBusy	=> CtrlBusIn_intl.WindowBusy,
		RAMP_CNT	=> CtrlBusIn_intl.RAMP_CNT,
		DO_BUS		=> CtrlBusIn_intl.DO_BUS,
		SSvalid		=> CtrlBusIn_intl.SSvalid,
		--Channels
		A_CH0 	=> A_CH0_intl,
		A_CH1 	=> A_CH1_intl,
		A_CH2 	=> A_CH2_intl,
		A_CH3 	=> A_CH3_intl,

		A_CH4 	=> A_CH4_intl,
		A_CH5 	=> A_CH5_intl,
		A_CH6 	=> A_CH6_intl,
		A_CH7 	=> A_CH7_intl,

		A_CH8 	=> A_CH8_intl,
		A_CH9 	=> A_CH9_intl,
		A_CH10 	=> A_CH10_intl,
		A_CH11 	=> A_CH11_intl,

		A_CH12 	=> A_CH12_intl,
		A_CH13 	=> A_CH13_intl,
		A_CH14 	=> A_CH14_intl,
		A_CH15 	=> A_CH15_intl,

		B_CH0 	=> B_CH0_intl,
		B_CH1 	=> B_CH1_intl,
		B_CH2 	=> B_CH2_intl,
		B_CH3 	=> B_CH3_intl,

		B_CH4 	=> B_CH4_intl,
		B_CH5 	=> B_CH5_intl,
		B_CH6 	=> B_CH6_intl,
		B_CH7 	=> B_CH7_intl,

		B_CH8 	=> B_CH8_intl,
		B_CH9 	=> B_CH9_intl,
		B_CH10 	=> B_CH10_intl,
		B_CH11 	=> B_CH11_intl,

		B_CH12 	=> B_CH12_intl,
		B_CH13 	=> B_CH13_intl,
		B_CH14 	=> B_CH14_intl,
		B_CH15 	=> B_CH15_intl,

		Handshake_IxSEND	=> Handshake_IxSEND_intl,
		Handshake_Data 		=> Handshake_SS_FIFO,
		Handshake_OxSEND	=> Handshake_OxSEND_intl
	);

	FIFOMANAGER : TwoTARGETCs_FifoManager
		generic map(
			C_M_AXIS_TDATA_WIDTH =>  32
		)
		port map(
			CtrlBus_IxSL		=> CtrlBusOut_intl,
			--CtrlBus_OxSL		=> CtrlBusIn_intl,
			FIFOBusy => 	CtrlBusIn_intl.FIFOBusy,

			ClockBus	 => ClockBus_intl,

			--Request and Acknowledge - READOUT
			Handshake_IxRECV=> Handshake_OxSEND_intl,
			Handshake_Data 		=> Handshake_SS_FIFO,
			Handshake_OxRECV=> Handshake_IxSEND_intl,

			--Header Information from FIFO
			FIFO_ReadEn			=> FIFO_ReadEn_intl,
			FIFO_Time			=> FIFO_Time_intl,
			FIFO_WdoAddr		=> FIFO_WdoAddr_intl,
			FIFO_TrigInfo		=> FIFO_TrigInfo_intl,
			FIFO_Spare	 		=> FIFO_Spare_intl,
			FIFO_Empty			=> FIFO_Empty_intl,

			--Channels
		            CH0 => A_CH0_intl,
             		CH1 => A_CH1_intl,
             		CH2 => A_CH2_intl,
             		CH3 => A_CH3_intl,
             
             		CH4 => A_CH4_intl,
             		CH5 => A_CH5_intl,
             		CH6 => A_CH6_intl,
             		CH7 => A_CH7_intl,
             
             		CH8  => A_CH8_intl,
             		CH9  => A_CH9_intl,
             		CH10 => A_CH10_intl,
             		CH11 => A_CH11_intl,
             
             		CH12 => A_CH12_intl,
             		CH13 => A_CH13_intl,
             		CH14 => A_CH14_intl,
             		CH15 => A_CH15_intl,
                   
             	    CH16 => B_CH0_intl,
             	    CH17 => B_CH1_intl,
             	    CH18 => B_CH2_intl,
             	    CH19 => B_CH3_intl,
                    
             		CH20 => B_CH4_intl,
             		CH21 => B_CH5_intl,
             		CH22 => B_CH6_intl,
             		CH23 => B_CH7_intl,
                    
             		CH24 => B_CH8_intl,
             		CH25 => B_CH9_intl,
             		CH26 => B_CH10_intl,
             		CH27 => B_CH11_intl,
                    
             		CH28 => B_CH12_intl,
             		CH29 => B_CH13_intl,
             		CH30 => B_CH14_intl,
             		CH31 => B_CH15_intl,


			-- DATA TO STREAM
			FIFOvalid	=> FIFOValid,
			FIFOdata	=> FIFOdata,
			StreamReady	=> StreamReady
		);

	A_SAMPLESEL_ANY <= CtrlBusOut_intl.SmplSl_Any;
	B_SAMPLESEL_ANY <= CtrlBusOut_intl.SmplSl_Any;

	--REGCLR <= CtrlBusOut_intl.REGCLR;

	A_WR_RS_S0	<= WR_RS_S_intl(0);
	A_WR_RS_S1	<= WR_RS_S_intl(1);

	A_WR_CS_S0	<= WR_CS_S_intl(0);
	A_WR_CS_S1	<= WR_CS_S_intl(1);
	A_WR_CS_S2	<= WR_CS_S_intl(2);
	A_WR_CS_S3	<= WR_CS_S_intl(3);
	A_WR_CS_S4	<= WR_CS_S_intl(4);
	A_WR_CS_S5	<= WR_CS_S_intl(5);

	B_WR_RS_S0	<= WR_RS_S_intl(0);
	B_WR_RS_S1	<= WR_RS_S_intl(1);
	
	B_WR_CS_S0	<= WR_CS_S_intl(0);
	B_WR_CS_S1	<= WR_CS_S_intl(1);
	B_WR_CS_S2	<= WR_CS_S_intl(2);
	B_WR_CS_S3	<= WR_CS_S_intl(3);
	B_WR_CS_S4	<= WR_CS_S_intl(4);
	B_WR_CS_S5	<= WR_CS_S_intl(5);

	A_SS_LD_SIN <= '0';
	A_SS_LD_DIR <= '0';
	B_SS_LD_SIN <= '0';
	B_SS_LD_DIR <= '0';
	--DOE <= '1';


	CtrlBusIn_intl.Cnt_AXIS <=Cnt_AXIS_DATA;  -- Signal driven only by TC0

	cnt_clr_intl <= CtrlBusOut_intl.WindowStorage;
	
SyncBitCNT_CLR: SyncBit
       generic map (
          SYNC_STAGES_G  => 2,
          CLK_POL_G      => '1',
          RST_POL_G      => '1',
          INIT_STATE_G   => '0',
          GATE_DELAY_G   => 1 ns
       )
       
       port map ( 
          -- Clock and reset
          clk  => tc_axi_aclk,
          rst   => tc_axi_aresetn,
          -- Incoming bit, asynchronous
          asyncBit =>  cnt_clr_intl,
          -- Outgoing bit, synced to clk
          syncBit   => CNT_CLR_A_B
       );     

    
    
    
	--NbrWindow	<= CtrlBusOut_intl.NBRWINDOW;
	SW_nRST <= CtrlBusOut_intl.SW_nRST;

	-- Interrupt Interface
	SSVALID_INTR <= CtrlBusIn_intl.SSVALID when CtrlBusOut_intl.SAMPLEMODE = '0' else '0';

	-- Timing Buffer
	IBUFDS_MonTiming : IBUFDS
	generic map(
		IOSTANDARD  => "LVDS_25"
	)
	port map(
		I	=> MONTIMING_P,
		IB	=> MONTIMING_N,

		O	=> MONTIMING_s
	);
-- MONTIMING INVERTED ON THE TARGETC, changed in firmware on 08/15/2019
    MONTIMING_inverted <= not MONTIMING_s;


-- FANNING OUT SIGNALS
    A_PCLK<=PCLK_intl;
    B_PCLK<=PCLK_intl;
    
	A_RDAD_CLK<=RDAD_CLK_intl;
	B_RDAD_CLK<=RDAD_CLK_intl;
	A_RDAD_SIN<=RDAD_SIN_intl;
	B_RDAD_SIN<=RDAD_SIN_intl;
	A_RDAD_DIR<=RDAD_DIR_intl;
	B_RDAD_DIR<=RDAD_DIR_intl;
	
	A_RAMP<=RAMP_intl;
	B_RAMP<=RAMP_intl;
	
	A_GCC_RESET<=GCC_RESET_intl;
	B_GCC_RESET<=GCC_RESET_intl;
	
	
	A_SS_INCR<=SS_INCR_intl;
	B_SS_INCR<=SS_INCR_intl;

	A_SS_RESET<=SS_RESET_intl;
	B_SS_RESET<=SS_RESET_intl;
	
	DO_A_B_intl<=DO_A_B;
	

--    signal PCLK_intl: std_logic;
--    signal RDAD_CLK_intl: std_logic ;
--	signal  RDAD_SIN_intl: std_logic;
--	signal RDAD_DIR_intl: std_logic;
--	signal RAMP_intl: std_logic;
--	signal GCC_RESET_intl: std_logic;
--	signal  DO_intl: std_logic_vector(15 downto 0);
--	signal SS_INCR_intl: std_logic;
--	signal SS_RESET_intl: std_logic;

	-- TRIGGER FROM BOARD NOT NEEDED FOR HMB CALORIMETERS EXTERNAL TRIGGER WILL BE PROVIDED
	-- Trigger signal to RoundBuffer
--	nTrigA <= not TrigA;
--	nTrigB <= not TrigB;	-- Signal are inverted Pulse is negative and not positiv
--	nTrigC <= not TrigC;
--	nTrigD <= not TrigD;
--
--	--Trigger_intl <= nTrigD & nTrigC & nTrigB & nTrigA;
--	Trigger_intl <= TrigD & TrigC & TrigB & TrigA;  --FOR POSITIVE PULSES
--
	TestStream <= CtrlBusOut_intl.TestStream;


 -- Debug pins for FMC board

-- For triggering a signal every time WR_CS and WR_RS are equal to zero 


-- Debug pins

--process (WR_CS_S_intl, WR_RS_S_intl)
--begin
--      if (WR_CS_S_intl = "000000" and WR_RS_S_intl= "00") then
--              BB2 <= '0';
--      else
--              BB2 <= '1';
--      end if;
--end process;


----process (address_is_zero_intl)
----begin
----	if (address_is_zero_intl = '1' ) then
----		BB5 <= '0';
------		BB2 <= '0';
----	else
----		BB5 <= '1';
----	--	BB2 <= '1';
----	end if;
----end process;

	
 SSTIN <= ClockBus_intl.SSTIN;
--   -- BB2 <= CtrlBusIn_intl.RAMP_CNT;
--	BB4 <= CtrlBusIn_intl.SSvalid;
--	BB3 <= MONTIMING_inverted;







--	-- Debug pins
--	BB1 <= ClockBus_intl.SSTIN;
----	BB2 <= DO(0);
--	BB3 <= CtrlBusIn_intl.RAMP_CNT;
--	BB4 <= CtrlBusIn_intl.SSvalid;
--	BB5 <= MONTIMING_s;




end arch_imp;
