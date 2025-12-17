# source D:/Projects/vio_bram_test/vio_bram_test/tcl/vio.bram.w.tcl

set FILE            "./script/temp/coe_out.csv"
set VIO_CORE_NAME   "bram_top_inst/vio_bram_b_inst"
set ADDR_PROBE_NAME "bram_top_inst/bram_vio_addr"
set DATA_PROBE_NAME "bram_top_inst/bram_vio_din"
set WREN_PROBE_NAME "bram_top_inst/bram_vio_we"

set VIO_CORE        [get_hw_vios -filter "CELL_NAME=~$VIO_CORE_NAME"]
set ADDR_PROBE      [get_hw_probes -of_objects $VIO_CORE $ADDR_PROBE_NAME]
set DATA_PROBE      [get_hw_probes -of_objects $VIO_CORE $DATA_PROBE_NAME]
set WREN_PROBE      [get_hw_probes -of_objects $VIO_CORE $WREN_PROBE_NAME]

set ADDR_WIDTH      [get_property WIDTH $ADDR_PROBE]
set DATA_WIDTH      [get_property WIDTH $DATA_PROBE]
set ADDR_CHAR_CNT   [expr {int(ceil(double($ADDR_WIDTH) / 4.0))}]
set DATA_CHAR_CNT   [expr {int(ceil(double($DATA_WIDTH) / 4.0))}]

if {[llength $ADDR_PROBE] == 0 || [llength $DATA_PROBE] == 0 || [llength $WREN_PROBE] == 0} {
    puts {[ERROR]: One or more VIO probes not found}
    return
}

puts {[INFO]: Reading data from $FILE...}
set fp [open $FILE r]

set_property CORE_REFRESH_RATE_MS 100 $VIO_CORE

set_property OUTPUT_VALUE_RADIX HEX $ADDR_PROBE
set_property OUTPUT_VALUE_RADIX HEX $DATA_PROBE
set_property OUTPUT_VALUE_RADIX HEX $WREN_PROBE

foreach line [split [read $fp] "\n"] {
    if {[regexp {^\s*(\w+)\s*,\s*(\w+)\s*$} $line junk addr val]} {
        puts "Running line: $line:"
        puts "tcl: set_property OUTPUT_VALUE [format "%0${ADDR_CHAR_CNT}s" $addr] $ADDR_PROBE"
        puts "tcl: set_property OUTPUT_VALUE [format "%0${DATA_CHAR_CNT}s" $val] $DATA_PROBE"

        set_property OUTPUT_VALUE [format "%0${ADDR_CHAR_CNT}s" $addr] $ADDR_PROBE
        set_property OUTPUT_VALUE [format "%0${DATA_CHAR_CNT}s" $val] $DATA_PROBE
        commit_hw_vio $ADDR_PROBE $DATA_PROBE

        set_property OUTPUT_VALUE 1 $WREN_PROBE
        commit_hw_vio $WREN_PROBE
        set_property OUTPUT_VALUE 0 $WREN_PROBE
        commit_hw_vio $WREN_PROBE
    }
}

close $fp