
module computer(
input pclk_i,
input presetn_i,
input compute_req_i,
input [31:0] prdata_i,
input pready_i,
input pslverr_i,
output psel_o,
output penable_o,
output [7:0] paddr_o,
output [31:0] pwdata_o,
output pwrite_o,
output [31:0] data_o,
output valid_o
    );
    reg [7:0] ad_counter=0;
    reg [31:0] reg_data;
    
    localparam idle = 2'b00;
    localparam setup = 2'b01;
    localparam transfer = 2'b10;
    
    reg [1:0] state, state_next;
       
    always@(posedge pclk_i) begin
        if(~presetn_i)
            state <= idle;
        else
            state <= state_next;       
        end
    
    always@(posedge pclk_i)begin
        if(~presetn_i) ad_counter<=0;
        else if((state == transfer & pready_i)|valid_o) ad_counter<=ad_counter+1;    //address counter
    end
    
    always@(posedge pclk_i)begin
        if(~presetn_i)  reg_data<=0;
        else if(state == transfer & pready_i) reg_data<=prdata_i;          //register   
    end
    
    always@(*) begin
    state_next = state;
        case(state)
            default: state_next = idle;
	        idle: if(compute_req_i) state_next=setup;
	        setup: state_next=transfer;
	        transfer: begin
	                   if(pready_i|(~compute_req_i & ad_counter[0]))state_next=idle;
	                   if(pready_i|(compute_req_i & ~ad_counter[0]))state_next=setup;
	                   
	                  end
	   endcase
    end 
  //outputs
    assign paddr_o = (~(state==idle)) ? ad_counter : 0;
    assign valid_o=(state==transfer) & ~pready_i & ad_counter[0];
    assign pwdata_o=0;
    assign psel_o = ~(state==idle);
    assign penable_o = (state==transfer);
    assign pwrite_o = (~(state==idle)) ? ~psel_o : 0;
    assign data_o= (state==idle) ? 0 : reg_data + prdata_i;
    
endmodule