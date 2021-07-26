transcript off
echo "------- START OF MACRO -------"
onerror abort

vcom transmitter.vhd
vcom tb_transmitter.vhd
vsim tb_transmitter

restart -force
noview *

add wave resetN
add wave clk
add wave write_din
add wave din
add wave txrx
add wave                 /tb_transmitter/eut/present_state
add wave                 /tb_transmitter/eut/clr_dcount
add wave                 /tb_transmitter/eut/ena_dcount
add wave -radix unsigned /tb_transmitter/eut/dcount
add wave                 /tb_transmitter/eut/eoc
add wave                 /tb_transmitter/eut/te
add wave -radix unsigned /tb_transmitter/eut/tcount
add wave                 /tb_transmitter/eut/t1
add wave                 dout
add wave -radix ascii    dout

run 450000 ns

wave zoomfull
echo "------- END OF MACRO -------"
echo "The time now is $now [ string trim $resolution 01 ] "