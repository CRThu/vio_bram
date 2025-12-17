open_hw_manager
connect_hw_server
open_hw_target
set device          [lindex [get_hw_devices] 0]
if {[llength $device] == 0} {
    puts {[ERROR]: device not found}
    return
}
current_hw_device $device
refresh_hw_device [current_hw_device]