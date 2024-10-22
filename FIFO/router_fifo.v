module router_fifo (clock,resetn,soft_reset,lfd_state,read_enb,write_enb,data_in,data_out,empty,full);
input clock,resetn,soft_reset,lfd_state,read_enb,write_enb;
input [7:0] data_in;
output empty,full;
output reg [7:0] data_out;
reg [3:0] wr_ptr,rd_ptr;
reg [4:0] fifo_ptr;
reg [6:0] fifo_counter;
reg temp_lfd;
reg [8:0] mem [15:0];
integer i;
assign full = (fifo_ptr > 5'b01111);
assign empty = (fifo_ptr == 5'b00000);
//fifo_ptr logic
always @(posedge clock)
begin
if(resetn == 1'b0)
   fifo_ptr <= 0;
else if (soft_reset)
   fifo_ptr <= 0;
else if (write_enb && full == 1'b0)
   fifo_ptr <= fifo_ptr + 1;
else if (read_enb && empty == 1'b0)
   fifo_ptr <= fifo_ptr - 1;
 else 
 fifo_ptr <= fifo_ptr;
end
//lfd_state logic
always@(posedge clock)
    begin
      if(resetn == 1'b0)
        temp_lfd <= 1'b0;
        else if (soft_reset)
        temp_lfd <= 1'b0;
	  else 
	    temp_lfd <= lfd_state;
    end 
	
//write logic
always @(posedge clock)
begin
if (resetn == 1'b0)
begin
wr_ptr <= 0;
for(i=0;i<16;i=i+1)
   mem[i] <= 0;
end
else if (soft_reset)
begin
wr_ptr <= 0;
for(i=0;i<16;i=i+1)
    mem[i] <= 0;
end
else if (write_enb && full == 1'b0)
begin
mem[wr_ptr] <= {temp_lfd,data_in};
wr_ptr <= wr_ptr + 1'b1;
end
else
wr_ptr <= wr_ptr;
end

//Read logic
always@(posedge clock)
begin
if (resetn == 1'b0)
begin
 rd_ptr <= 0;
 data_out <= 0;
end
else if (soft_reset)
begin
 rd_ptr <= 0;
 data_out <= 8'bz;
end
else if (read_enb && empty == 1'b0)
begin
data_out <= mem[rd_ptr][7:0];
rd_ptr <= rd_ptr + 1'b1;
end
else if (fifo_counter == 0)
data_out <= 8'bz;
end
//fifo_counter logic
always @(posedge clock)
begin
if(resetn == 1'b0)
 fifo_counter <= 0;
else if (soft_reset)
 fifo_counter <= 0;
 else if (read_enb && empty == 1'b0)
 begin
 if(mem[rd_ptr][8])
 fifo_counter <= mem[rd_ptr][7:2] + 1'b1;
 else if (fifo_counter != 7'b0)
   fifo_counter <= fifo_counter -1;
 end
 end
endmodule
 

 




