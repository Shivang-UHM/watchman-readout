library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AXI_STREAM_data_generator_v1_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Master Bus Interface M00_AXIS
		C_M00_AXIS_TDATA_WIDTH	: integer	:= 32;
		C_M00_AXIS_START_COUNT	: integer	:= 32
	);
	port (
		-- Users to add ports here

		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Master Bus Interface M00_AXIS
		m00_axis_aclk	: in std_logic;
		m00_axis_aresetn	: in std_logic;
		m00_axis_tvalid	: out std_logic := '0';
		m00_axis_tdata	: out std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');
		m00_axis_tstrb	: out std_logic_vector((C_M00_AXIS_TDATA_WIDTH/8)-1 downto 0) := (others => '0');
		m00_axis_tlast	: out std_logic := '0';
		m00_axis_tready	: in std_logic := '0'
	);
end AXI_STREAM_data_generator_v1_0;

architecture arch_imp of AXI_STREAM_data_generator_v1_0 is


signal  i_counter : integer := 0;
begin


m00_axis_tstrb <= (others =>'1');

 process(m00_axis_aclk) is 
  variable v_m00_axis_tvalid : std_logic := '0' ;
 begin 
 if rising_edge (m00_axis_aclk) then
    if m00_axis_tready = '1' then 
        v_m00_axis_tvalid := '0';
        m00_axis_tlast  <= '0';
    end if;
    
    if v_m00_axis_tvalid = '0' then 
     v_m00_axis_tvalid := '1';
     m00_axis_tdata <= std_logic_vector(to_unsigned(i_counter, m00_axis_tdata'length));
     i_counter <= i_counter +1;
     if i_counter >= 1029 then 
        i_counter <= 0 ;
        m00_axis_tlast <= '1';
     end if;
    end if;
    

    
    
    m00_axis_tvalid <= v_m00_axis_tvalid; 
 end if;
 end process;

end arch_imp;
