# source script/vio.bram.r.tcl

set OUT_FILE        "./script/temp/coe_readback.csv"
set VIO_CORE_NAME   "bram_top_inst/vio_bram_b_inst"
set ADDR_PROBE_NAME "bram_top_inst/bram_vio_addr"
set DOUT_PROBE_NAME "bram_top_inst/bram_vio_dout"
set TOTAL_ADDR      256

set VIO_CORE        [get_hw_vios -filter "CELL_NAME=~$VIO_CORE_NAME"]
set ADDR_PROBE      [get_hw_probes -of_objects $VIO_CORE $ADDR_PROBE_NAME]
set DOUT_PROBE      [get_hw_probes -of_objects $VIO_CORE $DOUT_PROBE_NAME]

if {[llength $ADDR_PROBE] == 0 || [llength $DOUT_PROBE] == 0} {
    puts {[ERROR]: One or more VIO probes not found}
    return
}

set ADDR_WIDTH      [get_property WIDTH $ADDR_PROBE]
set ADDR_CHAR_CNT   [expr {int(ceil(double($ADDR_WIDTH) / 4.0))}]

set_property CORE_REFRESH_RATE_MS 100 $VIO_CORE

set_property OUTPUT_VALUE_RADIX HEX $ADDR_PROBE
set_property INPUT_VALUE_RADIX HEX $DOUT_PROBE

puts "\[INFO\]: Address width is $ADDR_WIDTH, total depth is $TOTAL_ADDR"

file mkdir [file dirname $OUT_FILE]
set fp [open $OUT_FILE w]

puts "\[INFO\]: Reading BRAM via VIO..."
puts "\[INFO\]: Writing data to $OUT_FILE..."

for {set i 0} {$i < $TOTAL_ADDR} {incr i} {
    set addr_hex [format "%0${ADDR_CHAR_CNT}x" $i]
    set_property OUTPUT_VALUE $addr_hex $ADDR_PROBE
    commit_hw_vio $ADDR_PROBE
    
    refresh_hw_vio [get_hw_vios $VIO_CORE]
    
    set val [get_property INPUT_VALUE $DOUT_PROBE]
    
    puts "$addr_hex, $val"
    puts $fp "$addr_hex, $val"
}

close $fp
puts "\[INFO\]: Read complete. Data saved to $OUT_FILE"