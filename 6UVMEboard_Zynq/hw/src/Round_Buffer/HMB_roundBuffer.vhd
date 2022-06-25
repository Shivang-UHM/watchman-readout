---------------------------------------------------------------------------------
-- Company: IDLAB, Hawaii
-- Engineer: Salvador Ventura
-- 
-- Create Date: 05/06/2021
-- Design Name: 
-- Module Name: circularBuffer for HMB - 
-- Project Name: HMB
-- Target Devices: 
-- Tool Versions: 

-- Description: This module controls the writting and readout processes in TargetC in function of 
-- a trigger. 

-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
 use ieee.numeric_std.all;
--use ieee.numeric_std_unsigned.all;
-- use work.TARGETC_pkg.all; --not used in simulations

entity HMB_roundBuffer is

 
    port (
    
  clk :            in  std_logic;
  RST :             in  std_logic;  
  trigger :         in std_logic;
  full_fifo :        in std_logic;          
  mode:             in std_logic;
  enable_write :    out std_logic;
  TriggerInfo :    out std_logic_vector(11 downto 0);
  RD_add:           out std_logic_vector(8 downto 0);
  WR_RS:            out std_logic_vector(1 downto 0);
  WR_CS:            out std_logic_vector(5 downto 0);
  delay_trigger:    in std_logic_vector(3 downto 0);
  sstin_updateBit:   in std_logic_vector(2 downto 0); -- To control the cycle number where the address are updated
  sstin_cntr:            in std_logic_vector(2 downto 0)


   
);

end HMB_roundBuffer;
 
architecture structure of HMB_roundBuffer is
 



signal  wr_intl:         std_logic_vector(7 downto 0);
signal fifo_wr_en_intl: std_logic;
signal trigger_intl:  std_logic:='0';

type stmachine is (start ,roundBuffer_st, out_roundbuffer_st,wait_for_dig);
signal stm_circularBuffer: stmachine;

type stmachine_read is (idle_st ,first_window_offset_st , read_address_st);
signal stm_read: stmachine_read;


signal long_pulse_sig: std_logic;
signal cnt_wr_en: std_logic_vector(3 downto 0);
signal rd_add_intl: integer; -- unsigned(7 downto 0); 
signal wait_cntr: std_logic_vector(15 downto 0);
--attribute mark_debug : string;
type longPulse_type is(
   IDLE,
   LONGPULSE
);

signal longpulse_stm : longpulse_type := IDLE;
signal sstin_cntr_intl: std_logic_vector(2 downto 0);

signal add_offset_flag : std_logic := '0';

attribute mark_debug : string; 
attribute mark_debug of wait_cntr: signal is "true";
attribute mark_debug of rd_add_intl: signal is "true";
attribute mark_debug of trigger_intl: signal is "true";
attribute mark_debug of cnt_wr_en: signal is "true";
attribute mark_debug of wr_intl: signal is "true";
attribute mark_debug of fifo_wr_en_intl : signal is "true";
--attribute mark_debug of subBuffer_triggered: signal is "true";
--attribute mark_debug of trigger: signal is "true";
attribute mark_debug of WR_CS: signal is "true";
attribute mark_debug of WR_RS: signal is "true";
--attribute mark_debug of ptr_wr: signal is "true";
--attribute mark_debug of ptr_1st_window_of_subBuffer: signal is "true";
--attribute mark_debug of cycle_number_corrected: signal is "true";

attribute fsm_encoding : string;
attribute fsm_encoding of stm_circularBuffer   : signal is "sequential"; 
attribute fsm_encoding of stm_read   : signal is "sequential"; 
attribute fsm_encoding of longpulse_stm   : signal is "sequential";
 -- variable flagNumber : std_logic_vector(3 downto 0);

begin
  

--sstinCnt: counter
--generic map(NBITS=> 3)
-- port map (
--        CLK =>  clk,
--        RST =>  RST,
--        Q   =>  sstin_cntr_intl
        
--        );
    

  ----------------------------------
  -- State machine forsstin_cntr_intl handling the trigger and to generate the 
  -- wr/read addresses (signals WR_CS, WR_RS, RD_add and fifo_wr_en_intl). 
  
 p_sm:  process(clk,RST, mode,trigger_intl, full_fifo,sstin_cntr)
variable offset_v: integer ;
  begin 
 
if (RST = '0') or (mode='0') then
--        rd_add_intl <= 0;
        wr_intl <= (others=>'0');
	   	wait_cntr <=(others=>'0');
	   	add_offset_flag <= '0';

        
--        fifo_wr_en_intl <= '0';
   else 
       if rising_edge(clk) then
       case stm_circularBuffer is
       when start =>
            if (mode = '1') and (sstin_cntr=sstin_updateBit)  then
 
                stm_circularBuffer <= roundbuffer_st ;
            else
                stm_circularBuffer<= start;
            end if;
    
    when roundbuffer_st =>
	    	if (trigger_intl='0') then
					if (sstin_cntr=sstin_updateBit) then
						if (unsigned (wr_intl) < 5) then
							wr_intl <= std_logic_vector(unsigned(wr_intl) + 1);
							stm_circularBuffer <= roundbuffer_st;
						else
						   wr_intl <= (others => '0');
						   stm_circularBuffer <= roundbuffer_st;
						end if;
				   else
		   				stm_circularBuffer <= roundbuffer_st;
--		   				fifo_wr_en_intl <= '0';
	   					end if;

			 else 
--					   rd_add_intl <= std_logic_vector( unsigned (wr_intl) - unsigned(delay_trigger) );
		--			   rd_add_intl <= wr_intl - delay_trigger ;
--					   fifo_wr_en_intl <= '1';
--					   wr_intl <= std_logic_vector(unsigned(wr_intl) + 1);
--					   stm_circularBuffer <= out_roundbuffer_st;
			--		      if (unsigned (wr_intl) < 255) then   
--			  
							   wr_intl <= std_logic_vector(unsigned(wr_intl) + 1);
			  				   stm_circularBuffer <= out_roundbuffer_st;
			 -- 				end if;
			  		
					   
		   end if;
   
   
   
   
   when out_roundbuffer_st =>

	   if (sstin_cntr=sstin_updateBit) then
	   
	      -- add_offset_flag <= '1';
	       
		   if (unsigned (wr_intl) < 255) then   
--			   rd_add_intl <=  to_integer(unsigned(wr_intl)) - to_integer(unsigned(delay_trigger));
--			   fifo_wr_en_intl <= '1';
			   wr_intl <= std_logic_vector(unsigned(wr_intl) + 1);
			   stm_circularBuffer <= out_roundbuffer_st;

		   else
		   	    wr_intl <= X"FF"; -- 255
			   --wr_intl <= (others => '0');
			   add_offset_flag <= '0';
			   stm_circularBuffer <= wait_for_dig;
--			   fifo_wr_en_intl <= '0';
		   end if;
	   else
		  stm_circularBuffer   <= out_roundbuffer_st;
--		  fifo_wr_en_intl <= '0';
		  end if;
		  
		  
	when wait_for_dig=>
	
	   if (sstin_cntr=sstin_updateBit) then
	   		if (wait_cntr< X"3FFF") then                        --"3FFF" : (3FFF= 16383, 7FFF=32767) 
	   			wait_cntr <= std_logic_vector (unsigned( wait_cntr) + 1);
	   			stm_circularBuffer <= wait_for_dig;
	   		    wr_intl <= X"FF"; --255

	   		else
	   			wait_cntr <=(others=>'0');
	   			wr_intl <= (others => '0');
	   			stm_circularBuffer <= roundbuffer_st;

	   		end if;
	   		
		  
		  end if;
		  
		  
end case;
end if;
end if;

 end process p_sm;
 
 
 
 
 
read_sm:  process(clk,RST, mode)
variable offset_v: integer ;
  begin 
 
if (RST = '0') or (mode='0') then
        offset_v := 0 ;
	 	fifo_wr_en_intl <= '0';
	 	rd_add_intl  <= 0;


   else 
       if rising_edge(clk) then
       case stm_read is
		   when idle_st =>
				if (trigger_intl = '0') then
					stm_read <= idle_st;
					rd_add_intl<=0;
					 offset_v := 0 ;

				else
					stm_read <= first_window_offset_st;
				end if;
				
 		when first_window_offset_st =>  			
				
            if ( (sstin_cntr="011") or (sstin_cntr= "111")  ) then
					offset_v := to_integer(unsigned(wr_intl & '0')) + to_integer(unsigned(delay_trigger));
				    rd_add_intl <= to_integer(unsigned(wr_intl & '0')) + to_integer(unsigned(delay_trigger)); -- - 1 ;
				    stm_read <= read_address_st;
				else
				    stm_read <= first_window_offset_st;
				end if;
						
				

		when read_address_st =>
	  	
			if ( (sstin_cntr="011") or (sstin_cntr= "111")  ) then
	
				if ( (rd_add_intl) < (10 + offset_v  ) ) then
					rd_add_intl <= rd_add_intl + 1 ;
					fifo_wr_en_intl <= '1';
					stm_read <=read_address_st;
					
				else
					fifo_wr_en_intl <= '0';
				    rd_add_intl  <= 0;
					stm_read<= idle_st;

				end if;
				
			else
		      	fifo_wr_en_intl <= '0';
		      	stm_read <=read_address_st;
                
                
                
        	end if;
     end case;

   end if;

 end if;
                

							
end process read_sm;

			
   			
   			


 WR_RS <= std_logic_vector(wr_intl(1 downto 0));
 WR_CS <= std_logic_vector(wr_intl(7 downto 2));

 enable_write <= fifo_wr_en_intl;
 TriggerInfo<= (others => '0');
 RD_ADD <= std_logic_vector(to_signed (rd_add_intl, RD_ADD'length));
 
 ----------------------------------
 -- Long pulses handling
 ----------------------------------
 long_pulses_stm:    process(clk,trigger, RST)
        
              
         begin
             if RST = '0' then
                 long_pulse_sig <= '0';
                 cnt_wr_en <= (others=>'0'); 
                 trigger_intl<='0';

             else
                 if rising_edge(clk) then 
                             case longpulse_stm is
                                  when IDLE =>            
                                 if trigger= '1' then           
                                     if cnt_wr_en < "0001" then  --- After x windows (cnt_wr_en < x) the pulse is considered 'long'.
                                         long_pulse_sig<= '0';
                                         cnt_wr_en <= std_logic_vector(unsigned(cnt_wr_en) + 1);
                                         trigger_intl<=trigger;
                                         longpulse_stm <= IDLE;
                                     else
                                         long_pulse_sig<='1';
                                         cnt_wr_en <= (others=>'0');
                                         longpulse_stm <= longpulse;  -- if the writeEn stays high for more than x clk periods the long_pulse signal goes high
                                         trigger_intl<= '0';
 
                                     end if;    
                                else
                                    long_pulse_sig <= '0';
                                    cnt_wr_en <= (others=>'0');
                                    longpulse_stm <= IDLE;
                                    trigger_intl<=trigger;
                                                 
                                end if;
                              when longpulse=>
                                 if trigger= '1' then           
                                     long_pulse_sig<= '1';
 
                                      longpulse_stm <= longpulse; 
                                      trigger_intl<='0';
 
                                 else
                                     long_pulse_sig<= '0';
                                     longpulse_stm <= IDLE;
                                     trigger_intl<=trigger;
 
                                 end if;
                             end case;        
                         
                         end if;
                     end if;
     end process;
 
 
 
 
 
end architecture;

