-- -----------------------------------------------------------
--!@FILE: 	CPU_CONTROLLER.vhd
--!@AUTHOR: Jonathan Hendriks
--!@DATE: 	21st of January 2019
-- -----------------------------------------------------------
--!@DESCRIPTION:
--! CPU_CONTROLLER is the supervision over the round buffer. It
--! looks after two modes :
--! - Normal Mode, which is the user can ask for FSTWINDOW and
--!   NBRWINDOW both parameter set by the PS side thourgh AXI-Lite.
--! - Trigger Mode, which is used to catch any trigger on the Raw
--! trigger inputs.
-- -----------------------------------------------------------

-- Libraries
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.WindowCPU_PKG.all;
use work.TARGETC_pkg.all;

--Entity
entity CPU_CONTROLLERV3 is
--	Generic(
		-- NBR of windows menaing the number of CPUs
--		NBRWINDOWS : integer := 16
--	);
	Port (
	nrst : 			in	STD_Logic;

	--Time Input
	ClockBus:		in T_ClockBus;
	--Timecounter:	in std_logic_vector(63 downto 0);
	Timestamp:		in T_timestamp;

	-- Raw trigger from external board
	trigger : 		in std_logic_vector(3 downto 0);

	-- Interface to WindowCPU and WindowStore
	CPUBus:			out	std_logic_vector(10 downto 0);
	CPUTime:		out	T_timestamp;
--	TriggerInfo :	out std_logic_vector(11 downto 0);

	-- Storage pins of TargetC
	WR_RS_S:		out std_logic_vector(1 downto 0);
	WR_CS_S:		out std_logic_vector(5 downto 0);

	-- Control Signals
	CtrlBus_IxSL:	in 	T_CtrlBus_IxSL;
	--CtrlBus_OxSL:	out T_CtrlBus_OxSL;

	-- Address of current window and the old one
	ValidData:		out std_logic;
	ValidReal:		out std_logic;
	--CurAddr:		out	std_logic_vector(7 downto 0);
	-- RealAddrBit:		out std_logic_vector(NBRWINDOWS-1 downto 0);
	--OldAddr:		out	std_logic_vector(7 downto 0);
	--OldAddrBit:		out std_logic_vector(NBRWINDOWS-1 downto 0);

	-- Next and Prev address from Hamming code
	NextAddr_in : 	in std_logic_vector(7 downto 0);
	PrevAddr_in :	in std_logic_vector(7 downto 0);
	NextValid_in : 	in std_logic;
	PrevValid_in :	in std_logic;

    -- FIFO IN for Digiting
    DIG_Full	: out	std_logic;
    DIG_DataIn	: in	std_logic_vector(8 downto 0);
    DIG_WriteEn	: in	std_logic
	);

end CPU_CONTROLLERV3;

--Architecture
architecture Behavioral of CPU_CONTROLLERV3 is

--	component BlockDelay is
--		generic(
--			NBR : integer := 16
--		);
--		Port (
--		nrst : 		in	STD_Logic;
--		nclr :		in	std_logic;
--		clk:		in std_logic;

--		Scnt:		in	std_logic_vector(2 downto 0);

--		D : 		in	std_logic;
--		Q:			out	std_logic

--		);

--	end component BlockDelay;

--	component TRIGGER_CONTROLLER is
--		Generic(
--			LONG_TRIGGER: integer := 32
--		);
--		Port (
--		nrst : 			in	STD_Logic;
--		clk:			in	std_Logic;

--		trigger : 		in std_logic_vector(3 downto 0);

--		-- Interface to WindowCPU
--		TriggerInfo :		out std_logic_vector(11 downto 0)
--		);
--	end component;

--	component aFifoV2 is
--    generic (
--        DATA_WIDTH :integer := 8;
--        ADDR_WIDTH :integer := 4
--    );
--    port (
--    	rst :		in std_logic;
--        -- Reading port.
--        Data_out    :out std_logic_vector (DATA_WIDTH-1 downto 0);
--        Empty_out   :out std_logic;
--        ReadEn_in   :in  std_logic;
--        RClk        :in  std_logic;
--        -- Writing port.
--        Data_in     :in  std_logic_vector (DATA_WIDTH-1 downto 0);
--        Full_out    :out std_logic;
--        WriteEn_in  :in  std_logic;
--        WClk        :in  std_logic
--    );
--	end component aFifoV2;

--	component module_fifo_regs_no_flags is
--	  generic (
--	    g_WIDTH : natural := 32;
--	    g_DEPTH : integer := 32
--	    );
--	  port (
--	    i_rst_sync : in std_logic;
--	    i_clk      : in std_logic;

--	    -- FIFO Write Interface
--	    i_wr_en   : in  std_logic;
--	    i_wr_data : in  std_logic_vector(g_WIDTH-1 downto 0);
--	    o_full    : out std_logic;

--	    -- FIFO Read Interface
--	    i_rd_en   : in  std_logic;
--	    o_rd_data : out std_logic_vector(g_WIDTH-1 downto 0);
--	    o_empty   : out std_logic
--	    );
--	end component;

--	component LookupTable_LE is
--		generic(
--			MIN_LE_TIME : integer := 3	-- All times are x4 ns so 2 is equal to 8ns = 12 samples before rise of trigger
--		);
--		Port (
--			Clk:		in 	std_logic;
--			SCnt:		in 	std_logic_vector(2 downto 0);
--			prevWdo :	out	std_logic
--		);
--	end component LookupTable_LE;

--	component RisingEdge_DFlipFlop is
--	   port(
--	      Q : out std_logic;
--	      nQ: out std_logic;
--	      Clk :in std_logic;
--	      D :in  std_logic ;
--	      nrst : in std_logic
--	   );
--   end component RisingEdge_DFlipFlop;
   COMPONENT dig_sto_fifo_9W_16D
     PORT (
       wr_clk : IN STD_LOGIC;
       rd_clk : IN STD_LOGIC;
       din : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
       wr_en : IN STD_LOGIC;
       rd_en : IN STD_LOGIC;
       dout : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
       full : OUT STD_LOGIC;
       empty : OUT STD_LOGIC
     );
   END COMPONENT;
   
--   COMPONENT axi_wdo_addr_fifo
--     PORT (
--      -- rst : IN STD_LOGIC;
--       wr_clk : IN STD_LOGIC;
--       rd_clk : IN STD_LOGIC;
--       din : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
--       wr_en : IN STD_LOGIC;
--       rd_en : IN STD_LOGIC;
--       dout : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
--       full : OUT STD_LOGIC;
--       empty : OUT STD_LOGIC
--     );
--   END COMPONENT;
   
   
--COMPONENT trig0_fifo_10W_16D
--     PORT (
--       wr_clk : IN STD_LOGIC;
--       rd_clk : IN STD_LOGIC;
--       din : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
--       wr_en : IN STD_LOGIC;
--       rd_en : IN STD_LOGIC;
--       dout : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
--       full : OUT STD_LOGIC;
--       empty : OUT STD_LOGIC
--     );
--   END COMPONENT;
--  COMPONENT axi_trig_afifo_12W_32D
--     PORT (
--       wr_clk : IN STD_LOGIC;
--       rd_clk : IN STD_LOGIC;
--       din : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
--       wr_en : IN STD_LOGIC;
--       rd_en : IN STD_LOGIC;
--       dout : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
--       full : OUT STD_LOGIC;
--       empty : OUT STD_LOGIC
--     );
--   END COMPONENT;
	-- component LookupTable_TE is
	-- 	generic(
	-- 		MIN_TE_TIME : integer := 1
	-- 	);
	-- 	Port (
	-- 		Clk:		in 	std_logic;
	-- 		SCnt:		in 	std_logic_vector(3 downto 0);
	-- 		nextWdo :	out	std_logic
	-- 	);
	-- end component LookupTable_TE;

	type storagestate is (
		IDLE,
		READY,
		RESPREADY,

		EVALUATE,
		STABLE_EVAL,
		MARK_WINDOW,
		STABLE_MARK
	);
	signal storage_stm : storagestate := IDLE;

	type digstoragestate is (
		IDLE,
		READING,
		PREPARING,
		WRITING
	);
	signal digsto_stm : digstoragestate;

	signal CurAddr_s : std_logic_vector(7 downto 0);
    signal updateWR : std_logic_vector(7 downto 0);

	signal RealTimeAddr : std_logic_vector(7 downto 0);
	--signal busy_intl : std_logic;

	signal NextAddr_intl : std_logic_vector(7 downto 0);
	signal PrevAddr_intl : std_logic_vector(7 downto 0);
	signal OldAddr_intl : std_logic_vector(7 downto 0);
	--signal prev_OldAddr_intl : std_logic_vector(7 downto 0);
--	signal Trig_OldAddr_intl : std_logic_vector(7 downto 0);
--	signal Ctrl_OldAddr_intl : std_logic_vector(7 downto 0);

--	signal cmdbus_intl : std_logic_vector(2 downto 0);
--	signal cmdwdo_en_intl: std_logic_vector(NBRWINDOWS-1 downto 0);

	signal FstWindow512 : std_logic_vector(8 downto 0);
	signal CntWindow512 : std_logic_vector(8 downto 0);

	signal DIG_Empty_intl, STO_ReadEn : std_logic;
	signal DIG_DataOut_intl : std_logic_vector(8 downto 0);

	-- Optimization for LUT reduction
	signal Cmp_s : std_logic := '0';

	signal CTRL_CPUBUS : std_logic_vector(10 downto 0);
	signal TRIG_CPUBUS : std_logic_vector(10 downto 0);
	signal DIGI_CPUBUS : std_logic_vector(10 downto 0);

	signal D_wr1_en,	D_wr1_dly, Wr1_en_dly : std_logic;
	signal D_wr2_en, 	D_wr2_dly, Wr2_en_dly : std_logic;
	signal Old_Wr_en : std_logic_vector(1 downto 0);
	signal prevTrigger : std_logic;

	signal TrigInfo_intl, TrigInfo_intl_dly, Old_TrigInfo : std_logic_vector(11 downto 0) :=(others => '0');
	signal Last_intl, Trig_intl : std_logic ;
	signal TriggerRegDly : std_logic_vector(1 downto 0);

	signal validreal_s, validdata_s, valid_1dly : std_logic;
	signal LE_intl, LE_intr, TE_intl : std_logic;
	signal notsamplecnt : std_logic_vector(2 downto 0);
	signal prev_TimeStamp:	T_Timestamp;

	signal Ctrl_Busy_s : std_logic;

	-- ADD-ON from SSTIN problem
	signal copy_CPUTime : T_Timestamp;
	signal Old_TrigInfo_copy : std_logic_vector(11 downto 0);


	-- Test FIFO TRIGGER
	signal prevTrig : std_logic_vector(1 downto 0);
	signal TrigAddr : std_logic_vector(9 downto 0);
	signal TrigData : std_logic_vector(9 downto 0);
	signal TrigWrite, TrigRead : std_logic;
	signal TrigFull, TrigEmpty : std_logic;

	type t_trigger_state_stm is(
		IDLE,
		READFIFO,
		EVALUATE,
		MARK_WINDOW
	);

	signal Trig_stm : t_trigger_state_stm;

	signal LE_RealAddr :  std_logic_vector(7 downto 0);
	signal LE_RealAddr0 :  std_logic_vector(7 downto 0);
	signal LE_RealAddr1 :  std_logic_vector(7 downto 0);

	signal TrigInfo: std_logic_vector(11 downto 0);
	signal TrigInfo0: std_logic_vector(11 downto 0);
	signal TrigInfo1: std_logic_vector(11 downto 0);
	signal TrigInfo2: std_logic_vector(11 downto 0);

	signal Delay_UpdateWR : std_logic_vector(3 downto 0);
	signal counterWR : std_logic_vector(3 downto 0);


	-- -------------------------------------------------------------
	-- Constraints on Signals
	-- -------------------------------------------------------------
	attribute DONT_TOUCH : string;

--	attribute DONT_TOUCH of Trig_OldAddr_intl : signal is "TRUE";
--	attribute DONT_TOUCH of Ctrl_OldAddr_intl : signal is "TRUE";
	attribute mark_debug : string;
	attribute mark_debug of ClockBus : signal is "TRUE";
	attribute mark_debug of nRST : signal is "TRUE";
	attribute mark_debug of TimeStamp : signal is "TRUE";

	--attribute DONT_TOUCH of OldAddr_intl : signal is "TRUE";
	--attribute DONT_TOUCH of CntWindow512 : signal is "TRUE";

	--attribute DONT_TOUCH of CTRL_CPUBUS : signal is "TRUE";

begin


	notsamplecnt <= not(TimeStamp.samplecnt(2)) & TimeStamp.samplecnt(1 downto 0);

	-- Process of address change on rising_edge of SSTIN
	process(ClockBus.CLK125MHz,nrst)	-- Every 64 ns
	begin
		if nRST = '0' then
			validData_s <= '0';
			validReal_s <= '0';
			counterWR  <= (others=>'0');


			RealTimeAddr <= (others => '0');
			-- Init the CPUs
			CurAddr_s <= (others => '0');
		--	RealAddrBit <= (0 => '1', others => '0');

			--OldAddr_intl <= x"FF";
			--OldAddrBit <= (255 => '1', others => '0');

			Old_Wr_en <= (others => '1');
			Old_TrigInfo <= (others => '0');
			CPUTime <= (others=> (others => '0'));
			copy_CPUTime <= (others=> (others => '0'));
			prev_TimeStamp <= (others => (others => '0'));
		else
			if rising_edge(ClockBus.CLK125MHz) then

				valid_1dly <= not(validData_s);

				case TimeStamp.samplecnt is
					when "111" => --Time 0
						--valid <= '0';

						--RealTimeAddr <= NextAddr_intl;
						if NextValid_in = '1' then
							validReal_s <= '0';
							RealTimeAddr <= NextAddr_in;
		--					RealAddrBit <= (others => '0');
		--					RealAddrBit(to_integer(unsigned(NextAddr_in))) <= '1';
						end if;


						-- CurAddr_s 		<= NextAddr_intl;
						-- OldAddr_intl 	<= CurAddr_s;
						--
						-- OldAddrBit <= (others => '0');
						-- OldAddrBit(to_integer(unsigned(CurAddr_s))) <= '1';
						-- --OldAddrBit <= (oldidx => '1', others => '0');
						--
						-- RealAddrBit <= (others => '0');
						-- RealAddrBit(to_integer(unsigned(NextAddr_intl))) <= '1';
						--RealAddrBit <= (curidx => '1', others => '0');

						--Real Time Information
						prev_TimeStamp <= TimeStamp;
						--copy_CPUTime <= prev_TimeStamp;

						Old_TrigInfo <= TrigInfo_intl_dly;
						Old_Wr_en	<= not(wr2_en_dly) & not(wr1_en_dly);

					when "000" => --Time 1
						validReal_s <= '1'; -- After this the data is correct, time to stabilize
					when "010"	=> --Half way // Falling edge
				--	when "0001"	=>
						validData_s <= '0';

						--CurAddr_s 		<= NextAddr_intl;
						CurAddr_s		<= RealTimeAddr;
						OldAddr_intl 	<= CurAddr_s;

						--OldAddrBit <= (others => '0');
						--OldAddrBit(to_integer(unsigned(CurAddr_s))) <= '1';
						--OldAddrBit <= (oldidx => '1', others => '0');
                    when "011"=>
        --            when "0010"=>
                         
                              updateWR   <= CurAddr_s;   

                         
--                          if counterWR < std_logic_vector(unsigned(Delay_UpdateWR)) then  -- values for CtrlBus_IxSL.Delay_UpdateWR must be 8 to 15 
--                             counterWR <= std_logic_vector(unsigned(Delay_UpdateWR) + 1) ; 

--                          else 
--                              counterWR  <= (others=>'0');

--                          end if;
                      
                        

						--RealAddrBit <= (curidx => '1', others => '0');

						--Copy real time Information
						--CPUTime <= copy_CPUTime;
						CPUTime <= prev_TimeStamp;
						Old_TrigInfo_copy <= Old_TrigInfo;

					when "100" =>
						validData_s <= '1'; -- After this the data is correct, time to stabilize

					when others =>
				end case;

				if TriggerRegDly = "01" then
					Old_TrigInfo <= TrigInfo_intl_dly;
					--add on
					Old_Wr_en	<= not(wr2_en_dly) & not(wr1_en_dly);
				end if;
			end if;
		end if;
	end process;

	-- Address update
    --ValidData <= validData_s when CtrlBus_IxSL.CPUMode = '0'  else  '0';
	ValidData<= validData_s;
	ValidReal <= validReal_s;

	--CurAddr	<= CurAddr_s;
	--OldAddr <= OldAddr_intl;

	
	--Update TARGET C pins

  -- WR_RS_S <= updateWR(1 downto 0);  
  WR_RS_S  <=  updateWR(1 downto 0);
 
 
  WR_CS_S <= updateWR(7 downto 2);

    
             

-----------------------------------------------------------------------------------------WR_CS_S



    DIG_STO_AFIFO : dig_sto_fifo_9W_16D
      PORT MAP (
      --  rst => nrst,
        
        dout => DIG_DataOut_intl,
        empty => DIG_Empty_intl,
        rd_en => STO_ReadEn,
        rd_clk => ClockBus.CLK125MHz,

        
        din => DIG_DataIn,
        full => DIG_Full,
        wr_en => DIG_WriteEn,
        wr_clk => ClockBus.WL_CLK

      );
    



	-- Process for Next and Prev Address
	process(ClockBus.CLK125MHz,nrst)
	begin
		if nrst = '0' then
			NextAddr_intl	<= x"01";
			PrevAddr_intl	<= x"FF";
		else
			if rising_edge(ClockBus.CLK125MHz) then
				if PrevValid_in = '1' then
					PrevAddr_intl <=	PrevAddr_in;
				end if;

				if NextValid_in = '1' then
					NextAddr_intl <=	NextAddr_in;
				end if;
			end if;
		end if;
	end process;

	-- Process for Trigger Information and Control
	process(ClockBus.CLK125MHz,nrst)
	begin
		if nrst='0' then
				TRIG_CPUBUS <= CMD_NOP & x"00";
				--Trig_OldAddr_intl <= OldAddr_intl;
				--Trig_intl_dly <= '0';
				TriggerRegDly <= (others => '0');
		else
			if rising_edge(ClockBus.CLK125MHz) then

				TriggerRegDly <= TriggerRegDly(0) & Trig_intl;
				--Trig_intl_dly <= Trig_intl;
				-- if valid = '1' then
				--
				-- 	Trig_OldAddr_intl <= OldAddr_intl;
				--
				-- 	if OldAddr_intl /= Trig_OldAddr_intl then
				if valid_1dly = '1' then
						--Send the command
						if Old_TrigInfo /= "000000000000" then
							case Old_Wr_en is
								when "00" =>
									TRIG_CPUBUS <= CMD_BOTH_MARKED & OldAddr_intl;
								when "01" =>
									TRIG_CPUBUS <= CMD_WR2_MARKED & OldAddr_intl;
								when "10" =>
									TRIG_CPUBUS <= CMD_WR1_MARKED & OldAddr_intl;
								when "11" =>
									--TRIG_CPUBUS <= CMD_NOP & OldAddr_intl;
									TRIG_CPUBUS <= DIGI_CPUBUS;
								when others =>
							end case;
						else
							--TRIG_CPUBUS <= CMD_NOP & x"00";
							TRIG_CPUBUS <= DIGI_CPUBUS;
						end if;
				else
					-- 	--TRIG_CPUBUS <= CMD_NOP & x"00";
					--TRIG_CPUBUS <= DIGI_CPUBUS;
						if LE_intl = '1' and TriggerRegDly = "01" then
							TRIG_CPUBUS <= CMD_WR2_MARKED & OldAddr_intl;
						else
							TRIG_CPUBUS <= DIGI_CPUBUS;
						end if;
					--end if;
				end if;
			end if;
		end if;
	end process;


	-- Minimal State Machine For Windows select and liberate CPU
	process(ClockBus.CLK125MHz, nRST)	-- Every 64 ns
	begin
	if nRST = '0' then
			storage_stm <= IDLE;

			FstWindow512 <= (others => '0');
			CntWindow512 <= (others => '0');

		--	busy_intl <= '0';
			CTRL_CPUBUS <= CMD_NOP & x"00";

			--Ctrl_OldAddr_intl <= OldAddr_intl;

		else
			if rising_edge(ClockBus.CLK125MHz) then
				-- if valid = '1' then
				--
				-- 	Ctrl_OldAddr_intl <= OldAddr_intl;

					-- Normal Storage Case from PS
					case storage_stm is
						when IDLE =>
							CTRL_CPUBUS <= DIGI_CPUBUS;
							Ctrl_Busy_s <=  '0';
							storage_stm <= READY;
					--		busy_intl <= '0';
						when READY =>
							CTRL_CPUBUS <= DIGI_CPUBUS;
					--		busy_intl <= '0';
							if(CtrlBus_IxSL.WindowStorage = '1') then  
								-- First Window && Counter is on 512 windows (9bits)
								FstWindow512 	<= CtrlBus_IxSL.FSTWINDOW(8 downto 0);
								CntWindow512	<= CtrlBus_IxSL.NBRWINDOW(8 downto 0);

								Ctrl_Busy_s <=  '1';

								storage_stm <= RESPREADY;
							else
								storage_stm <= READY;
							end if;

						when RESPREADY =>
							CTRL_CPUBUS <= DIGI_CPUBUS; -- Digitization starts at falling edge of windowstorage signal
							if(CtrlBus_IxSL.WindowStorage = '0') then
								--storage_stm <= STORAGE;
					--			busy_intl <= '1';
								storage_stm <= EVALUATE;

							else
					--			busy_intl <= '0';
								storage_stm <= RESPREADY;
							end if;

						when EVALUATE =>

							-- Waiting to have the next window
							--if NextAddr_intl = FstWindow512(8 downto 1) then
							if OldAddr_intl = FstWindow512(8 downto 1) and (valid_1dly = '1') then

								--Ctrl_OldAddr_intl <= OldAddr_intl;

								if FstWindow512(0) = '0' then                              --  If the window number is even

									--Optimization for LUT reduction
									--if CntWindow512 = "000000001" then
									if Cmp_s = '1' then  --                                   If not the last one
										-- CTRL_CPUBUS.cmd <= CMD_WR1_MARKED;
										-- CTRL_CPUBUS.addr <= OldAddr_intl;
										--CTRL_CPUBUS <= CMD_WR1_MARKED & OldAddr_intl;
										
	--									CTRL_CPUBUS(10 downto 8) <= CMD_WR1_MARKED;
									    CTRL_CPUBUS(10 downto 8) <= CMD_WR1_MARKED;                      

										CntWindow512 <= std_logic_vector(unsigned(CntWindow512) - 1);              ---Count just one
									else
										-- CTRL_CPUBUS.cmd <= CMD_BOTH_MARKED;
										-- CTRL_CPUBUS.addr <= OldAddr_intl;
										--CTRL_CPUBUS <= CMD_BOTH_MARKED & OldAddr_intl;
										
										
--										CTRL_CPUBUS(10 downto 8) <= CMD_BOTH_MARKED;
										CTRL_CPUBUS(10 downto 8) <= CMD_BOTH_MARKED;

										CntWindow512 <= std_logic_vector(unsigned(CntWindow512) - 2);                 -- Count two 
									end if;
								else

									-- --Optimization for LUT reduction
									-- CTRL_CPUBUS.cmd <= CMD_WR2_MARKED;
									-- CTRL_CPUBUS.addr <= OldAddr_intl;
									--CTRL_CPUBUS <= CMD_WR2_MARKED & OldAddr_intl;
									
									
--									CTRL_CPUBUS(10 downto 8) <= CMD_WR2_MARKED;
									CTRL_CPUBUS(10 downto 8) <= CMD_WR2_MARKED;


									CntWindow512 <= std_logic_vector(unsigned(CntWindow512) - 1);

								end if;

								CTRL_CPUBUS(7 downto 0) <= OldAddr_intl;

								--storage_stm <= MARK_WINDOW;
								storage_stm <= STABLE_EVAL;
							else
								CTRL_CPUBUS <= DIGI_CPUBUS;
								storage_stm <= EVALUATE;
							end if;
						when STABLE_EVAL =>
							storage_stm <= MARK_WINDOW;

						when MARK_WINDOW =>
							--cmdwdo_en_intl <= (others => '0');

							if (to_integer(unsigned(CntWindow512)) /= 0) then

								--if OldAddr_intl /= Ctrl_OldAddr_intl then
								if (valid_1dly = '1') then
								--Ctrl_OldAddr_intl <= OldAddr_intl;

									if Cmp_s = '1' then                                        --- if it is the last window
										-- CTRL_CPUBUS.cmd <= CMD_WR1_MARKED;
										-- CTRL_CPUBUS.addr <= OldAddr_intl;
										--CTRL_CPUBUS <= CMD_WR1_MARKED & OldAddr_intl;
										CTRL_CPUBUS(10 downto 8) <= CMD_WR1_MARKED;
										CntWindow512 <= std_logic_vector(unsigned(CntWindow512) - 1);
									else
										--CTRL_CPUBUS <= CMD_BOTH_MARKED & OldAddr_intl;
										CTRL_CPUBUS(10 downto 8) <= CMD_BOTH_MARKED;
										CntWindow512 <= std_logic_vector(unsigned(CntWindow512) - 2);
									end if;
									CTRL_CPUBUS(7 downto 0) <= OldAddr_intl;     
									storage_stm <= STABLE_MARK;
								else
									--CTRL_CPUBUS <= CMD_NOP & x"00";
									CTRL_CPUBUS <= DIGI_CPUBUS;
								end if;
							else
								--CTRL_CPUBUS <= CMD_NOP & x"00";
								CTRL_CPUBUS <= DIGI_CPUBUS;
					--			busy_intl <= '0';
								storage_stm <= IDLE;
							end if;
						when STABLE_MARK =>
							storage_stm <= MARK_WINDOW;
						when others =>
					end case;
				--end if;
			end if;
		end if;
	end process;

	process(ClockBus.CLK125MHz, nRST)	-- Every 64 ns
	begin
		if nRST = '0' then
				digsto_stm <= IDLE;

				DIGI_CPUBUS <= CMD_NOP & x"00";
		else
			if rising_edge(ClockBus.CLK125MHz) then
			-- State Machine for Reading the windows digitized
				case digsto_stm is
					when IDLE =>
						DIGI_CPUBUS <= CMD_NOP & x"00";

						if DIG_Empty_intl = '0' then
							digsto_stm <= READING;
							STO_ReadEn <= '1';
						else
							digsto_stm <= IDLE;
							STO_ReadEn <= '0';
						end if;
					when READING =>

						digsto_stm <= PREPARING;
						STO_ReadEn <= '0';

					when PREPARING =>
						--TRIG_NOP_flg or CTRL_NOP_flg;


						if DIG_DataOut_intl(0) = '0' then
							DIGI_CPUBUS <= CMD_WR1_EN_DIS & DIG_DataOut_intl(8 downto 1);
						else
							DIGI_CPUBUS <= CMD_WR2_EN_DIS & DIG_DataOut_intl(8 downto 1);
						end if;
						digsto_stm <= WRITING;
					when  WRITING =>
						if ((DIGI_CPUBUS = TRIG_CPUBUS) and (CtrlBus_IxSL.CPUMode = '1')) or ((DIGI_CPUBUS = CTRL_CPUBUS) and (CtrlBus_IxSL.CPUMode = '0')) then
							digsto_stm <= IDLE;

							DIGI_CPUBUS <= CMD_NOP & x"00";
						else
							digsto_stm <= WRITING;
						end if;
					when others =>
						digsto_stm <= IDLE;
						STO_ReadEn <= '0';
				end case;
			end if;
		end if;
	end process;

--CPUMode
	-- CPUBus <=	TRIG_CPUBUS	when CtrlBus_IxSL.CPUMode = '1' else
	-- 			CTRL_CPUBUS;

	process(ClockBus.CLK125MHz, nRST)	-- Every 64 ns
	begin
	if nRST = '0' then

		CPUBus <= CMD_NOP & x"00";

		else
			if rising_edge(ClockBus.CLK125MHz) then
				if  CtrlBus_IxSL.CPUMode = '1' then
					CPUBus <= TRIG_CPUBUS;
				else
					CPUBus <= CTRL_CPUBUS;
				end if;
			end if;
		end if;
	end process;

	Cmp_s <= '1' when CntWindow512 = "000000001" else '0';


end Behavioral;
