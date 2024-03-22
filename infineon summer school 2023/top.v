
module top
#(parameter period=500_000)
(
input clk_i,
input compute_req_in,
input rstn_i,
input [31:0] data_in,
output valid_out,
output [31:0] data_out
    );
    wire err,ready,sel_s,sel_c,en_s,en_c,write_s,write_c;
    wire [31:0]pwdata_s,pwdata_c,prdata;
    wire [7:0] addr_s,addr_c;
    
sampler #(.PERIOD(period)) Sampler(
.pclk_i(clk_i),
.presetn_i(rstn_i),
.pdata_i(data_in),
.prdata_i(prdata),
.pready_i(ready),
.pslverr_i(err),
.psel_o(sel_s),
.penable_o(en_s),
.paddr_o(addr_s),
.pwdata_o(pwdata_s),
.pwrite_o(write_s)
);

memory Memory(
.pclk_i(clk_i),
.presetn_i(rstn_i),
.psel_i(sel_s|sel_c),
.penable_i(en_s|en_c),
.paddr_i(addr_c|addr_s),
.pwdata_i(pwdata_s|pwdata_c),
.pwrite_i(write_s|write_c),
.prdata_o(prdata),
.pready_o(ready),
.pslverr_o(err)
);

computer Computer(
.pclk_i(clk_i),
.presetn_i(rstn_i),
.compute_req_i(compute_req_in),
.prdata_i(prdata),
.pready_i(ready),
.pslverr_i(err),
.psel_o(sel_c),
.penable_o(en_c),
.paddr_o(addr_c),
.pwdata_o(pwdata_c),
.pwrite_o(write_c),
.data_o(data_out),
.valid_o(valid_out)
);
endmodule
