`timescale 1ns / 1ps
module sampler_tb();

parameter PER = 50;

reg pclk_i_tb;
reg presetn_i_tb;
reg [31:0] pdata_i_tb;
reg [31:0] prdata_i_tb;
reg pready_i_tb;
reg pslverr_i_tb;
wire psel_o_tb;
wire penable_o_tb;
wire [7:0] paddr_o_tb;
wire [31:0] pwdata_o_tb;
wire pwrite_o_tb;

sampler #(.PERIOD(PER))
 DUT(
.pclk_i(pclk_i_tb),
.presetn_i(presetn_i_tb),
.pdata_i(pdata_i_tb),
.prdata_i(prdata_i_tb),
.pready_i(pready_i_tb),
.pslverr_i(pslverr_i_tb),
.psel_o(psel_o_tb),
.penable_o(penable_o_tb),
.paddr_o(paddr_o_tb),
.pwdata_o(pwdata_o_tb),
.pwrite_o(pwrite_o_tb)
);

initial begin
    pclk_i_tb = 0;
    forever #1 pclk_i_tb = ~pclk_i_tb;
end

initial begin
presetn_i_tb=0;
pdata_i_tb=0;
pready_i_tb=0;
@(posedge pclk_i_tb);
presetn_i_tb=1;
pdata_i_tb=2;
pready_i_tb=1;


end
endmodule
