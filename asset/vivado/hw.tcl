#!/usr/bin/env vivado -mode batch -source

# ref: http://www.fpgadeveloper.com/2016/11/tcl-automation-tips-for-vivado-xilinx-sdk.html

set origin_dir .
set jobs 24
set proj_name [lindex $argv 0]

open_project $origin_dir/ip/ip.xpr
ipx::open_ipxact_file $origin_dir/../dist/component.xml
ipx::merge_project_changes files          [ipx::current_core]
ipx::merge_project_changes hdl_parameters [ipx::current_core]
ipx::merge_project_changes ports          [ipx::current_core]
set_property core_revision 7 [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
update_ip_catalog -rebuild -repo_path $origin_dir/../dist
close_project

open_project $origin_dir/$proj_name/$proj_name.xpr
open_bd_design \
  $origin_dir/$proj_name/$proj_name.srcs/sources_1/bd/design_1/design_1.bd

set_property synth_checkpoint_mode Hierarchical \
  [get_files $origin_dir/$proj_name/$proj_name.srcs/sources_1/bd/design_1/design_1.bd]
generate_target all \
  [get_files  $origin_dir/$proj_name/$proj_name.srcs/sources_1/bd/design_1/design_1.bd]
export_ip_user_files \
  -of_objects [get_files $origin_dir/$proj_name/$proj_name.srcs/sources_1/bd/design_1/design_1.bd] \
  -no_script -sync -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] \
  $origin_dir/$proj_name/$proj_name.srcs/sources_1/bd/design_1/design_1.bd]
launch_runs -jobs $jobs { \
  design_1_processing_system7_0_0_synth_1 \
  design_1_axi_dma_0_0_synth_1 \
  design_1_axi_top_0_0_synth_1 \
  design_1_xlconcat_0_0_synth_1 \
  design_1_rst_ps7_0_100M_0_synth_1 \
  design_1_xbar_0_synth_1 \
  design_1_xbar_1_synth_1 \
  design_1_xbar_2_synth_1 \
  design_1_auto_pc_0_synth_1 \
  design_1_auto_pc_1_synth_1 \
  design_1_auto_us_0_synth_1 \
  design_1_auto_us_1_synth_1 \
  design_1_s00_mmu_0_synth_1 \
  design_1_s01_mmu_0_synth_1 \
  design_1_auto_pc_2_synth_1 \
  design_1_auto_us_2_synth_1 \
  design_1_auto_us_3_synth_1 \
  design_1_auto_pc_3_synth_1 \
  design_1_auto_pc_4_synth_1 \
  design_1_auto_pc_5_synth_1 \
}
export_simulation \
  -of_objects [get_files $origin_dir/$proj_name/$proj_name.srcs/sources_1/bd/design_1/design_1.bd] \
  -directory $origin_dir/$proj_name/$proj_name.ip_user_files/sim_scripts \
  -ip_user_files_dir $origin_dir/$proj_name/$proj_name.ip_user_files \
  -ipstatic_source_dir $origin_dir/$proj_name/$proj_name.ip_user_files/ipstatic \
  -lib_map_path [list \
    {modelsim=$origin_dir/$proj_name/$proj_name.cache/compile_simlib/modelsim} \
    {questa=$origin_dir/$proj_name/$proj_name.cache/compile_simlib/questa} \
    {ies=$origin_dir/$proj_name/$proj_name.cache/compile_simlib/ies} \
    {vcs=$origin_dir/$proj_name/$proj_name.cache/compile_simlib/vcs} \
    {riviera=$origin_dir/$proj_name/$proj_name.cache/compile_simlib/riviera} \
  ] \
  -use_ip_compiled_libs -force -quiet
launch_runs impl_1 -to_step write_bitstream -jobs $jobs
wait_on_run impl_1

# update_ip_catalog -rebuild -scan_changes
# upgrade_ip -vlnv user.org:user:axi_top:1.0 [get_ips design_1_axi_top_0_0] -log ip_upgrade.log
# export_ip_user_files -of_objects [get_ips design_1_axi_top_0_0] -no_script -sync -force -quiet
# generate_target all \
#   [get_files $origin_dir/$proj_name/$proj_name.srcs/sources_1/bd/design_1/design_1.bd]
# export_ip_user_files \
#   -of_objects [get_files $origin_dir/$proj_name/$proj_name.srcs/sources_1/bd/design_1/design_1.bd] \
#   -no_script -sync -force -quiet
# export_simulation \
#   -of_objects [get_files $origin_dir/$proj_name/$proj_name.srcs/sources_1/bd/design_1/design_1.bd] \
#   -directory $origin_dir/$proj_name/$proj_name.ip_user_files/sim_scripts \
#   -ip_user_files_dir $origin_dir/$proj_name/$proj_name.ip_user_files \
#   -ipstatic_source_dir $origin_dir/$proj_name/$proj_name.ip_user_files/ipstatic \
#   -lib_map_path [list \
#     {modelsim=$origin_dir/$proj_name/$proj_name.cache/compile_simlib/modelsim} \
#     {questa=$origin_dir/$proj_name/$proj_name.cache/compile_simlib/questa} \
#     {ies=$origin_dir/$proj_name/$proj_name.cache/compile_simlib/ies} \
#     {vcs=$origin_dir/$proj_name/$proj_name.cache/compile_simlib/vcs} \
#     {riviera=$origin_dir/$proj_name/$proj_name.cache/compile_simlib/riviera} \
#   ] \
#   -use_ip_compiled_libs -force -quiet
#
# reset_run   synth_1
# launch_runs synth_1
# wait_on_run synth_1
#
# reset_run   impl_1
# launch_runs impl_1 -to_step write_bitstream
# wait_on_run impl_1

# Export project to SDK
set bit_filename      [lindex [glob -dir $origin_dir/$proj_name/$proj_name.runs/impl_1 *.bit] 0]
set bit_filename_only [lindex [split $bit_filename /] end]
set top_module_name   [lindex [split $bit_filename_only .] 0]
set export_dir        $origin_dir/$proj_name/$proj_name.sdk
file mkdir $export_dir

write_sysdef -force \
  -hwdef $origin_dir/$proj_name/$proj_name.runs/impl_1/$top_module_name.hwdef \
  -bitfile $origin_dir/$proj_name/$proj_name.runs/impl_1/$top_module_name.bit \
  -meminfo $origin_dir/$proj_name/$proj_name.runs/impl_1/$top_module_name.mmi \
$export_dir/$top_module_name.hdf

