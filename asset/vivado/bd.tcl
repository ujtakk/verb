# Define your own block design

create_bd_design "design_1"

# create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
# create_bd_cell -type ip -vlnv user.org:user:axi_top:1.0 axi_top_0

# apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 \
#   -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" } [get_bd_cells processing_system7_0]

# set_property -dict [list CONFIG.PCW_USE_M_AXI_GP1 {1}] [get_bd_cells processing_system7_0]
# set_property -dict [list CONFIG.PCW_USE_S_AXI_HP0 {1}] [get_bd_cells processing_system7_0]
# set_property -dict [list CONFIG.PCW_USE_S_AXI_HP1 {1}] [get_bd_cells processing_system7_0]

# apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/axi_top_0/m_axi_lite" Clk "Auto" }  [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
# apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/axi_top_0/m_axi" Clk "Auto" }       [get_bd_intf_pins processing_system7_0/S_AXI_HP1]
# apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto" }  [get_bd_intf_pins axi_top_0/s_axi]
# apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto" }  [get_bd_intf_pins axi_top_0/s_axi_lite]

# connect_bd_net [get_bd_pins axi_top_0/m_axi_aresetn] [get_bd_pins rst_ps7_0_100M/peripheral_aresetn]
# connect_bd_net [get_bd_pins axi_top_0/s_axi_aresetn] [get_bd_pins rst_ps7_0_100M/peripheral_aresetn]

# set_property HDL_ATTRIBUTE.DEBUG true [get_bd_intf_nets {axi_top_0_m_axi }]
# set_property HDL_ATTRIBUTE.DEBUG true [get_bd_intf_nets {axi_mem_intercon_1_M00_AXI }]

# apply_bd_automation -rule xilinx.com:bd_rule:debug \
#   -dict [list \
#     [get_bd_intf_nets axi_top_0_m_axi] \
#     { AXI_R_ADDRESS "Data and Trigger" AXI_R_DATA "Data and Trigger" \
#       AXI_W_ADDRESS "Data and Trigger" AXI_W_DATA "Data and Trigger" AXI_W_RESPONSE "Data and Trigger" \
#       CLK_SRC "/processing_system7_0/FCLK_CLK0" SYSTEM_ILA "Auto" APC_EN "0" \
#     } \
#     [get_bd_intf_nets axi_mem_intercon_1_M00_AXI] \
#     { AXI_R_ADDRESS "Data and Trigger" AXI_R_DATA "Data and Trigger" \
#       AXI_W_ADDRESS "Data and Trigger" AXI_W_DATA "Data and Trigger" AXI_W_RESPONSE "Data and Trigger" \
#       CLK_SRC "/processing_system7_0/FCLK_CLK0" SYSTEM_ILA "Auto" APC_EN "0" \
#     } \
#   ]

regenerate_bd_layout
save_bd_design

