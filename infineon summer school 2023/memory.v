module memory(
input pclk_i,
input presetn_i,
input psel_i,
input penable_i,
input [7:0] paddr_i,
input [31:0] pwdata_i,
input pwrite_i,
output [31:0] prdata_o,
output pready_o,
output pslverr_o
);

reg [31:0] mem [0:255];
wire w_en;
wire r_en;

assign w_en= pwrite_i & psel_i & penable_i & pready_o;
assign r_en= (~pwrite_i) & psel_i & penable_i;

localparam idle = 2'b00;
localparam setup = 2'b01;
localparam transfer = 2'b10;

reg [1:0] state, state_next;


//citire asincrona
assign  prdata_o = (r_en) ? mem[paddr_i] : 0;

//scriere sincrona
always@(posedge pclk_i)begin
	if(w_en)mem[paddr_i]<=pwdata_i;
end

//automat APB

 always@(posedge pclk_i) begin
    if(~presetn_i)
        state <= idle;
    else
        state <= state_next;
end
 always@(*) begin
    state_next = state;
    
    case(state)
        default: state_next = idle;
	idle:  if (psel_i & (~penable_i)) state_next=setup; 
	setup: if (psel_i & penable_i) state_next=transfer;
	transfer: begin 
	       if (psel_i & (~penable_i)) state_next=setup; 
	       if (~psel_i) state_next=idle;
		  end
	endcase
	
end
assign pready_o = ~(state==setup);
assign pslverr_o=0;
endmodule