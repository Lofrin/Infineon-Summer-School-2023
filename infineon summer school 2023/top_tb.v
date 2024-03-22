`timescale 1ns / 1ps
module top_tb();

parameter PER=50;

reg clk_tb, rst_tb,compute_req_tb;
reg [31:0] data_i_tb;
wire [31:0] data_o_tb;
wire valid_tb;
initial begin
    clk_tb=0;
    forever #1 clk_tb=~clk_tb;
end

top #(.period(PER)) DUT(
.clk_i(clk_tb),
.compute_req_in(compute_req_tb),
.rstn_i(rst_tb),
.data_in(data_i_tb),
.valid_out(valid_tb),
.data_out(data_o_tb)
);

initial begin
rst_tb=0;
data_i_tb=0;
compute_req_tb=0;
#10;
rst_tb=1;
end

initial begin
data_i_tb=1;
forever #100 data_i_tb=data_i_tb+1;
end

initial begin

end
endmodule
