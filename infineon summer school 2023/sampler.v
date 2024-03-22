
module sampler
#(parameter PERIOD=500_000)
(
input pclk_i,
input presetn_i,
input [31:0] pdata_i,
input [31:0] prdata_i,
input pready_i,
input pslverr_i,
output psel_o,
output penable_o,
output [7:0] paddr_o,
output [31:0] pwdata_o,
output pwrite_o
    );
    
    wire sample_s;
    reg [18:0] t_counter=PERIOD;
    reg [7:0] ad_counter=0;
    
    localparam idle = 2'b00;
    localparam setup = 2'b01;
    localparam transfer = 2'b10;
    
    reg [1:0] state, state_next;

    assign sample_s = (t_counter==0);
    

always@(posedge pclk_i) begin
    if(~presetn_i)begin
        state <= idle;
        t_counter<=PERIOD; 
       
        end
    else begin
            state <= state_next;
            //counter 1ms
            t_counter<=(t_counter==0)? PERIOD : t_counter-1;
         end
end

//address counter
always@(posedge pclk_i)begin
    if(state==transfer&pready_i)ad_counter<=ad_counter+1;
end

//APB master FSM
 always@(*) begin
    state_next = state;
    
    case(state)
        default: state_next = idle;
	    idle: if(sample_s) state_next=setup;
	    setup: state_next=transfer;
	    transfer: begin
	                   if(pready_i && sample_s) state_next=setup;
	                   if(pready_i && (~sample_s)) state_next=idle;
	                   
	              end
	endcase
end
//outputs
    assign psel_o = ~(state==idle) ;
    assign pwrite_o = ~(state==idle);
    assign penable_o = (state==transfer) ;
    assign paddr_o = (~(state==idle)) ? ad_counter : 0;
    assign pwdata_o = (pwrite_o) ? pdata_i : 0;
endmodule