# ----------------------------------------------------------------------------
# TIMING Constraint File
# ----------------------------------------------------------------------------











































connect_debug_port u_ila_0/probe1 [get_nets [list HMBcal_2TCsBD_i/TARGETC_axi_int_0_StreamReady]]























create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 4096 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list HMBcal_2TCsBD_i/processing_system7_0/inst/FCLK_CLK0]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[0]} {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[1]} {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[2]} {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[3]} {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[4]} {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[5]} {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[6]} {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[7]} {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[8]} {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[9]} {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[10]} {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[11]} {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[12]} {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[13]} {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[14]} {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[15]} {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[16]} {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[17]} {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[18]} {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[19]} {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[20]} {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[21]} {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[22]} {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[23]} {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[24]} {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[25]} {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[26]} {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[27]} {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[28]} {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[29]} {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[30]} {HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOdata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 1 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0/StreamReady]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 1 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0/U0/TC_RoundBuffer/HMBroundBuff/trigger_intl]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_FIFOvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list HMBcal_2TCsBD_i/TwoTARGET_C_TopLevel_0_SW_nRST]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets u_ila_0_FCLK_CLK0]
