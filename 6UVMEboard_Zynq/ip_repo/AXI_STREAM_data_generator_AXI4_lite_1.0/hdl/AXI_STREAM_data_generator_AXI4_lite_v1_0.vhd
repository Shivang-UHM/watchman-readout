library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AXI_STREAM_data_generator_AXI4_lite_v1_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 9;

		-- Parameters of Axi Master Bus Interface M00_AXIS
		C_M00_AXIS_TDATA_WIDTH	: integer	:= 32;
		C_M00_AXIS_START_COUNT	: integer	:= 32
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

		-- Ports of Axi Master Bus Interface M00_AXIS
		m00_axis_aclk	: in std_logic;
		m00_axis_aresetn	: in std_logic;
		m00_axis_tvalid	: out std_logic;
		m00_axis_tdata	: out std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
		m00_axis_tstrb	: out std_logic_vector((C_M00_AXIS_TDATA_WIDTH/8)-1 downto 0);
		m00_axis_tlast	: out std_logic;
		m00_axis_tready	: in std_logic;
		
		S01_AXIS_TVALID	: in std_logic;
		-- TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
		S01_AXIS_TDATA	: in  std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
		-- TLAST indicates the boundary of a packet.
		S01_AXIS_TLAST	: in std_logic;
		-- TREADY indicates that the slave can accept a transfer in the current cycle.
		S01_AXIS_TREADY	: out std_logic;
		
		
		interrupt_out   : out std_logic
	);
end AXI_STREAM_data_generator_AXI4_lite_v1_0;

architecture arch_imp of AXI_STREAM_data_generator_AXI4_lite_v1_0 is
    signal out_slv_reg0 : std_logic_vector(31  downto 0);
    signal out_slv_reg1 : std_logic_vector(31  downto 0);
    signal i_m00_axis_tvalid	:  std_logic;
	
 	
begin

-- Instantiation of Axi Bus Interface S00_AXI
AXI_STREAM_data_generator_AXI4_lite_v1_0_S00_AXI_inst : entity work.AXI_STREAM_data_generator_AXI4_lite_v1_0_S00_AXI
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
		out_slv_reg0 => out_slv_reg0,
		out_slv_reg1 => out_slv_reg1
	);

-- Instantiation of Axi Bus Interface M00_AXIS
AXI_STREAM_data_generator_AXI4_lite_v1_0_M00_AXIS_inst : entity work.AXI_STREAM_data_generator_AXI4_lite_v1_0_M00_AXIS
	generic map (
		C_M_AXIS_TDATA_WIDTH	=> C_M00_AXIS_TDATA_WIDTH,
		C_M_START_COUNT	=> C_M00_AXIS_START_COUNT
	)
	port map (
		M_AXIS_ACLK	=> m00_axis_aclk,
		M_AXIS_ARESETN	=> m00_axis_aresetn,
		M_AXIS_TVALID	=> i_m00_axis_tvalid,
		M_AXIS_TDATA	=> m00_axis_tdata,
		M_AXIS_TSTRB	=> m00_axis_tstrb,
		M_AXIS_TLAST	=> m00_axis_tlast,
		M_AXIS_TREADY	=> m00_axis_tready,
		
		S_AXIS_TVALID	=> S01_AXIS_TVALID,	
		
		S_AXIS_TDATA	=> S01_AXIS_TDATA,
		
		S_AXIS_TLAST	=> S01_AXIS_TLAST,
		
		S_AXIS_TREADY	=> S01_AXIS_TREADY,
		
		
		out_slv_reg0 => out_slv_reg0,
		out_slv_reg1 => out_slv_reg1
	);

    m00_axis_tvalid <= i_m00_axis_tvalid;

process(m00_axis_aclk) is 
begin 
if rising_edge (m00_axis_aclk) then 
    --interrupt_out <= out_slv_reg1(0);
    interrupt_out <=i_m00_axis_tvalid	; 
    
end if;
end process;
	-- Add user logic here
    
	-- User logic ends

end arch_imp;
