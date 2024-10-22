module router_fsm(clock,resetn,pkt_valid,parity_done,data_in,fifo_full,soft_reset_0,soft_reset_1,soft_reset_2,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,
                  busy,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state);

                parameter DECODE_ADDRESS  = 3'b000,
				          LOAD_FIRST_DATA = 3'b001,
						  LOAD_DATA       = 3'b010,
						  LOAD_PARITY     = 3'b011,
						  FIFO_FULL_STATE = 3'b100,
						  LOAD_AFTER_FULL = 3'b101,
						  CHECK_PARITY_ERROR = 3'b110,
						  WAIT_TILL_EMPTY = 3'b111;
						  
						  
//FSM coding style-1
input clock,resetn,pkt_valid,parity_done,fifo_full,soft_reset_0,soft_reset_1,soft_reset_2,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2;
input [1:0] data_in;
output  busy,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state;
reg [2:0] present_state,next_state;
reg [1:0] temp_data;
//assigning datain to temp variable
always@(posedge clock)
begin
if(!resetn)
temp_data <= 2'b00;
else
temp_data <= data_in;
end

//Present State logic
always@(posedge clock)
begin
if(!resetn)
present_state <= DECODE_ADDRESS;
else if (soft_reset_0 || soft_reset_1 || soft_reset_2)
  present_state <= DECODE_ADDRESS;
else
present_state <= next_state;
end

//Next State logic
always @(*)
begin
next_state = DECODE_ADDRESS;
case (present_state)
DECODE_ADDRESS : begin
                  if((pkt_valid && data_in == 0 && fifo_empty_0)||(pkt_valid && data_in == 1 && fifo_empty_1)||(pkt_valid && data_in == 2 && fifo_empty_2))
					 
					       next_state = LOAD_FIRST_DATA;
					 
				  else if((pkt_valid && data_in == 0 && !fifo_empty_0)||(pkt_valid && data_in == 1 && !fifo_empty_1)||(pkt_valid && data_in == 2 && !fifo_empty_2))
						   
						   next_state = WAIT_TILL_EMPTY;
				  else
				      next_state = DECODE_ADDRESS;
					  
				 end
LOAD_FIRST_DATA : begin
                    next_state = LOAD_DATA;
				  end
				  

LOAD_DATA       : begin
                    if (!fifo_full && !pkt_valid)
					  next_state = LOAD_PARITY;
					else if (fifo_full)
                       next_state = FIFO_FULL_STATE;
                    else
                       next_state = LOAD_DATA;
				  end
				  
LOAD_PARITY     : begin
                     next_state = CHECK_PARITY_ERROR;
				  end
				  

FIFO_FULL_STATE : begin
                    if(fifo_full)
                        next_state = FIFO_FULL_STATE;
                    else if(!fifo_full)
                        next_state = LOAD_AFTER_FULL;
                  end

LOAD_AFTER_FULL : begin
                    if(!parity_done && low_pkt_valid)
                        next_state = LOAD_PARITY;
                    else if(!parity_done && !low_pkt_valid)
                        next_state = LOAD_DATA;
                    else if(parity_done)
                        next_state = DECODE_ADDRESS;
                  end
CHECK_PARITY_ERROR : begin
                        if (fifo_full)
                            next_state = FIFO_FULL_STATE;
                        else if(!fifo_full)
                            next_state = DECODE_ADDRESS;
					 end
WAIT_TILL_EMPTY : begin
                    if((fifo_empty_0 && temp_data == 0) ||
					   (fifo_empty_1 && temp_data == 1) ||
					   (fifo_empty_2 && temp_data == 2))
					   
					    next_state = LOAD_FIRST_DATA;
						
				    else 
					  next_state = WAIT_TILL_EMPTY;
				  end
				  
endcase
end

// Output logic
assign detect_add = (present_state == DECODE_ADDRESS);
assign ld_state = (present_state == LOAD_DATA);
assign laf_state = (present_state == LOAD_AFTER_FULL);
assign full_state = (present_state == FIFO_FULL_STATE);
assign write_enb_reg = ((present_state == LOAD_DATA)||(present_state == LOAD_PARITY)||(present_state == LOAD_AFTER_FULL));
assign rst_int_reg = (present_state == CHECK_PARITY_ERROR);
assign lfd_state = (present_state == LOAD_FIRST_DATA);
assign busy = ((present_state == LOAD_FIRST_DATA)||(present_state == LOAD_AFTER_FULL)||(present_state == LOAD_PARITY)||(present_state == FIFO_FULL_STATE)||
                                  (present_state == CHECK_PARITY_ERROR)||(present_state == WAIT_TILL_EMPTY));
	
endmodule

					   
					
           