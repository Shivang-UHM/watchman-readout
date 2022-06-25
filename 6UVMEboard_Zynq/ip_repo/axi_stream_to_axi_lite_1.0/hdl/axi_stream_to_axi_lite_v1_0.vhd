library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.xgen_axistream_32.all;


entity axi_stream_to_axi_lite_v1_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 4
	);
	port (
		-- Users to add ports here

		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic;
		
	    S01_valid     : in  std_logic;
		S01_data      : in  std_logic_vector(31 downto 0);
		S01_Ready     : out std_logic;
		
		PL_Reset : out std_logic 
	);
end axi_stream_to_axi_lite_v1_0;

architecture arch_imp of axi_stream_to_axi_lite_v1_0 is
	signal rx_m2s : axisStream_32_m2s;
	signal rx_s2m : axisStream_32_s2m;
	signal 	slv_reg0_out	:  std_logic_vector(31 downto 0);
	signal  slv_reg1_in     :  std_logic_vector(31 downto 0) ;
	signal  slv_reg2_out    :  std_logic_vector(31 downto 0) ;
	
	signal  reg_addr        :  std_logic_vector(15 downto 0) ;
	signal  reg_value    :  std_logic_vector(15 downto 0) ;
	
	
type registerT is record 
    address : std_logic_vector(15 downto 0);
    value   : std_logic_vector(15 downto 0);

  end record;

  constant registerT_null : registerT := (
    address => (others => '0'),
    value   => (others => '0')

  );

signal reg : registerT := registerT_null;

  procedure read_data_s(self : in registerT;signal value :out  std_logic_vector ; addr :in integer) is 
    variable m1 : integer := 0;
    variable m2 : integer := 0;
    variable m : integer := 0;
  begin
    m1 := value'length;
    m2 := self.value'length;

    if (m1 < m2) then 
      m := m1;
    else 
      m := m2;
    end if;

    if to_integer(signed(self.address)) = addr then
      value(m - 1 downto 0) <= self.value(  m - 1 downto 0);
    end if; 
  end procedure;
	
    
    type word32_a is array(integer range <> ) of std_logic_vector (31 downto 0);
    
    signal mem : word32_a(0 to 2000) := (others =>( others => '0')); 
   
    signal  max_count :  std_logic_vector(15 downto 0) ;
    signal  reset_in :  std_logic_vector(15 downto 0) ;
    signal  done_readout :  std_logic_vector(15 downto 0) ;
    
    signal  pl_reset_slv:  std_logic_vector(15 downto 0) ;
    
    type state_t is (idle , data_stream, readout,reset);
    
    signal state : state_t:=idle;
    
begin

-- Instantiation of Axi Bus Interface S00_AXI
axi_stream_to_axi_lite_v1_0_S00_AXI_inst : entity work.axi_stream_to_axi_lite_v1_0_S00_AXI
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
		S_AXI_ACLK	=> s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	=> s00_axi_wdata,
		S_AXI_WSTRB	=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	=> s00_axi_rdata,
		S_AXI_RRESP	=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready,
		slv_reg0_out => slv_reg0_out, 
		slv_reg1_in => slv_reg1_in,
		slv_reg2_out => slv_reg2_out
	);

	-- Add user logic here
	S01_Ready <= rx_s2m.ready ;-- when FIFOvalid ='1' else '0';
	rx_m2s.data(S01_data'range) <= S01_data;
	rx_m2s.valid <= S01_valid;
	rx_m2s.last <= '0';
	
	reg.address   <= slv_reg2_out(31 downto 16);
	reg.value     <= slv_reg2_out(15 downto 0);

process(s00_axi_aclk) is 
		variable rx : axisStream_32_slave := axisStream_32_slave_null;
		variable rx_buff : std_logic_vector(31 downto 0)  := (others => '0');
		variable counter : integer := 0 ;
begin
    if rising_edge(s00_axi_aclk) then 
        pull(rx, rx_m2s);
        reset_in  <= (others =>'0');
        done_readout  <= (others =>'0');
        PL_Reset <= '0';
       -- pl_reset_slv <= (others => '0');
        read_data_s(reg , reset_in, 100);
        read_data_s(reg ,done_readout ,101);
        read_data_s(reg , max_count , 102);
        
        read_data_s(reg ,pl_reset_slv , 99);

        PL_Reset <= pl_reset_slv(0);
        
        if reset_in(0) = '1' then 
            counter := 0;
            rx :=  axisStream_32_slave_null;
            state <= reset;
            PL_Reset <='1'; 
        end if;
  
      case state is 
        when idle => 
            if isReceivingData(rx) then
                state <= data_stream;
            end if;  
        when data_stream =>
            if isReceivingData(rx) then  
                read_data(rx, rx_buff);
                mem(counter) <= rx_buff;
                counter := counter +1;
            end if;
      
            if counter >= TO_INTEGER (unsigned( max_count) ) then 
                state <= readout;
            end if;     
          
        when  readout => 
            if done_readout(0) = '1' then 
                state <= idle;
                counter := 0;
            end if;  
      
        when reset =>
          mem(counter) <= (others =>'0');
          counter := counter +1;
          if counter >=mem'length then 
            state <= idle;
          end if; 
        
      
        when others => 
            state <= idle;
        
      end case;


      if  mem'length >  TO_INTEGER (unsigned( slv_reg0_out) ) then 
        slv_reg1_in <= mem( TO_INTEGER (unsigned( slv_reg0_out) )) ;
      end if;
      
    push(rx, rx_s2m);
    end if;
end process;

	-- User logic ends

end arch_imp;
