`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/16/2025 04:19:25 PM
// Design Name: 
// Module Name: bram_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bram_top(
input clk,
input rst,
input en,
input we,
input [7 : 0] addr,
input [31 : 0] din,
output [31 : 0] dout
);

wire bram_vio_we;
wire[15:0] bram_vio_addr;
wire[31:0] bram_vio_din,bram_vio_dout;

blk_mem_gen_0 blk_mem_gen_0_inst (
  .clka(clk),
  .rsta(rst),
  .ena(en),
  .wea(we),
  .addra(addr),
  .dina(din),
  .douta(dout),
  
  .clkb(clk),
  .rstb(1'b0),
  .enb(1),
  .web(bram_vio_we),
  .addrb(bram_vio_addr),
  .dinb(bram_vio_din),
  .doutb(bram_vio_dout)
);

vio_bram_b vio_bram_b_inst(
    .clk        (clk),              // clk
    .probe_in0  (bram_vio_dout),    // [31 : 0]
    .probe_out0 (bram_vio_we),      // [0 : 0]
    .probe_out1 (bram_vio_addr),    // [15 : 0]
    .probe_out2 (bram_vio_din)      // [31 : 0]
);

endmodule
