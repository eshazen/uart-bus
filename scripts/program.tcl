# program from bitfile
open_hw
connect_hw_server -url localhost:3121
current_hw_target [get_hw_targets *]
open_hw_target
current_hw_device [lindex [get_hw_devices] 0]
set_property PROGRAM.FILE top.bit [lindex [get_hw_devices] 0]
program_hw_devices [lindex [get_hw_devices] 0]
