library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.xgen_axistream_32.all;

entity AXI_STREAM_data_generator_AXI4_lite_v1_0_M00_AXIS is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line

		-- Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
		C_M_AXIS_TDATA_WIDTH	: integer	:= 32;
		-- Start count is the number of clock cycles the master will wait before initiating/issuing any transaction.
		C_M_START_COUNT	: integer	:= 32;
		FIFO_NBR_MAX :		integer := 1030     
	);
	port (
		-- Users to add ports here

		-- User ports ends
		-- Do not modify the ports beyond this line

		-- Global ports
		M_AXIS_ACLK	: in std_logic;
		-- 
		M_AXIS_ARESETN	: in std_logic;
		-- Master Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted. 
		M_AXIS_TVALID	: out std_logic;
		-- TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
		M_AXIS_TDATA	: out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
		-- TSTRB is the byte qualifier that indicates whether the content of the associated byte of TDATA is processed as a data byte or a position byte.
		M_AXIS_TSTRB	: out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
		-- TLAST indicates the boundary of a packet.
		M_AXIS_TLAST	: out std_logic;
		-- TREADY indicates that the slave can accept a transfer in the current cycle.
		M_AXIS_TREADY	: in std_logic;
		
		
		S_AXIS_TVALID	: in std_logic;
		-- TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
		S_AXIS_TDATA	: in  std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
		-- TLAST indicates the boundary of a packet.
		S_AXIS_TLAST	: in std_logic;
		-- TREADY indicates that the slave can accept a transfer in the current cycle.
		S_AXIS_TREADY	: out std_logic;
		
		
		
		out_slv_reg0  : in std_logic_vector (31 downto  0);
		out_slv_reg1  : in std_logic_vector (31 downto  0)
		
		
		
	);
end AXI_STREAM_data_generator_AXI4_lite_v1_0_M00_AXIS;

architecture implementation of AXI_STREAM_data_generator_AXI4_lite_v1_0_M00_AXIS is

signal  i_counter : integer := 0;
signal trigger : std_logic:='0' ;
signal out_slv_reg1_old  :  std_logic_vector (31 downto  0);
constant  out_slv_reg1_null  :  std_logic_vector (31 downto  0) := (others =>'0');



    signal rx_m2s : axisStream_32_m2s;
    signal rx_s2m : axisStream_32_s2m;



	signal tx_m2s : axisStream_32_m2s;
	signal tx_s2m : axisStream_32_s2m;
    signal cnt_stream_out : integer := 0;
    
    
    signal cnt_watchdog: integer := 0;
    
    type state_t is (idle , send_test_pattern, resend_data, wait_after_send);
    signal state : state_t:= idle;
    
    constant header1 : std_logic_vector(31 downto  0) := std_logic_vector(to_unsigned(1234 , 32));
    constant fodder1 : std_logic_vector(31 downto  0) := std_logic_vector(to_unsigned(5678 , 32));
begin

	S_AXIS_TREADY  <= rx_s2m.ready ;-- when FIFOvalid ='1' else '0';
	rx_m2s.data(S_AXIS_TDATA'range) <= S_AXIS_TDATA;
	rx_m2s.valid   <= S_AXIS_TVALID;
	rx_m2s.last    <= S_AXIS_TLAST;


	tx_s2m.ready <= M_AXIS_TREADY;
	M_AXIS_TDATA <= tx_m2s.data(M_AXIS_TDATA'range);
	M_AXIS_TVALID <= tx_m2s.valid;
	M_AXIS_TLAST <= tx_m2s.last;
	
	

m_axis_tstrb <= (others =>'1');

 process(m_axis_aclk) is 
  variable v_m_axis_tvalid : std_logic := '0' ;
  
  variable rx : axisStream_32_slave := axisStream_32_slave_null;
  variable rx_buff : std_logic_vector(31 downto 0)  := (others => '0');
  variable tx : axisStream_32_master := axisStream_32_master_null;
  
 begin 
 if rising_edge (m_axis_aclk) then
    pull(rx, rx_m2s);
	pull(tx, tx_s2m);
	cnt_watchdog  <= cnt_watchdog +1;
	
	if cnt_watchdog > 10000 then 
	 rx := axisStream_32_slave_null;
     rx_buff  := (others => '0');
     tx := axisStream_32_master_null;
     cnt_watchdog <= 0;
     state <= idle;
	end if;
	out_slv_reg1_old <= out_slv_reg1;
    case (state) is
    when idle => 
    
        if out_slv_reg1 /= out_slv_reg1_old and out_slv_reg1 /= out_slv_reg1_null and ready_to_send(tx)  then 
            state  <=send_test_pattern;
            send_data(tx, header1);
            cnt_watchdog <= 0;
        end if;
        if  isReceivingData(rx)  and ready_to_send(tx)  then
            state  <=resend_data;
            send_data(tx, header1);
        end if; 
            
    when  send_test_pattern=>
        if ready_to_send(tx)  then
        cnt_stream_out<= 0; 
       
        i_counter <= i_counter +1;
        if i_counter > FIFO_NBR_MAX then 
            i_counter <= 0 ;
            state <= idle;
            send_data(tx, fodder1);
            Send_end_Of_Stream(tx, true); --m_axis_tlast <= '1';
       else
            send_data(tx, std_logic_vector(to_unsigned(i_counter + to_integer(signed( out_slv_reg0 )), m_axis_tdata'length)));
        end if;
    end if;
    when  resend_data => 
        if  isReceivingData(rx) and ready_to_send(tx)  then 
        
        read_data(rx, rx_buff);
        
        cnt_stream_out <= cnt_stream_out + 1;
		if (cnt_stream_out > FIFO_NBR_MAX) then
		  state <= wait_after_send; 
		  cnt_stream_out<= 0;
		  send_data(tx, fodder1);
		  Send_end_Of_Stream(tx, true);
		else 
		  send_data(tx, rx_buff);
	    end if;
    end if;   
    when  wait_after_send=>

       
        if cnt_watchdog >= to_integer(signed( out_slv_reg0 )) then 
	       rx := axisStream_32_slave_null;
           rx_buff  := (others => '0');
           tx := axisStream_32_master_null;
           cnt_watchdog <= 0;
           state <= idle;
        elsif  isReceivingData(rx)  then 
            read_data(rx, rx_buff);
        end if;
     
    when others => 
    end case;


    
     

    
    if cnt_stream_out =1 then 
        cnt_watchdog <= 0;
    end if;
    


    push(tx, tx_m2s);
	push(rx, rx_s2m);
 end if;
 end process;
 
end implementation;
