set top_filepath [file rootname [lindex [glob ./*.runs/impl_1/*.bit] 0]]
set target_bit "${top_filepath}.bit"
set target_ltx "${top_filepath}.ltx"

if {![file exists $target_ltx]} {
    set target_ltx ""
}

set_property PROGRAM.FILE $target_bit [current_hw_device]
set_property PROBES.FILE $target_bit [current_hw_device]
set_property FULL_PROBES.FILE $target_ltx [current_hw_device]

program_hw_devices [current_hw_device]
refresh_hw_device [current_hw_device]