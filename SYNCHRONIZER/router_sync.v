module router_sync (detect_add,data_in,write_enb_reg,clock,resetn,read_enb_0,read_enb_1,read_enb_2,empty_0,empty_1,empty_2,full_0,full_1,full_2,vld_out_0,vld_out_1,vld_out_2,write_enb,fifo_full,soft_reset_0,soft_reset_1,soft_reset_2);
input detect_add,write_enb_reg,clock,resetn,read_enb_0,read_enb_1,read_enb_2,empty_0,empty_1,empty_2,full_0,full_1,full_2;
input [1:0] data_in;
output reg soft_reset_0,soft_reset_1,soft_reset_2,fifo_full;
output vld_out_0,vld_out_1,vld_out_2;
output reg [2:0] write_enb;
reg [1:0] temp_data;
reg [4:0] count_0,count_1,count_2;
assign vld_out_0 = ~empty_0;
assign vld_out_1 = ~empty_1;
assign vld_out_2 = ~empty_2;

// storing 2 bit data_in into temp_data_in writing sequential logic
always@(posedge clock)
begin
if(detect_add)
    temp_data <= data_in;
end
always@(*)
begin
if(temp_data == 2'b00)
begin
if(write_enb_reg)
  write_enb = 3'b001;
else
  write_enb = 0;
end  
else if (temp_data == 2'b01)
begin
  if(write_enb_reg)
   write_enb = 3'b010;
  else
    write_enb = 0;
end
	
else if (temp_data == 2'b10)
begin
if(write_enb_reg)
  write_enb = 3'b100;
else
  write_enb = 0;
end
else
write_enb = 0;
end
//fifo full logic
always@(*)
begin
if (temp_data == 2'b00)
  fifo_full = full_0;
else if (temp_data == 2'b01)
   fifo_full = full_1;
else if (temp_data == 2'b10)
   fifo_full = full_2;
else 
   fifo_full = 0;

end
//counter logic
always@(posedge clock)
begin
count_0<=5'b1;
if (resetn == 1'b0)
 count_0 <= 5'b1;
 else if (vld_out_0)
 begin
 if (read_enb_0)
   count_0 <= 5'b1;
  else if(count_0 == 5'd30)
    count_0 <= 5'b1;
  else
   count_0 <= count_0 + 5'b1;
 end
 end
 
//counter logic
always@(posedge clock)
begin
count_1<= 5'b1;
if (resetn == 1'b0)
 count_1 <= 5'b1;
 else if (vld_out_1)
 begin
 if (read_enb_1)
   count_1 <= 5'b1;
  else if(count_1 == 5'd30)
    count_1 <= 5'b1;
  else
   count_1 <= count_1 + 5'b1;

 end
 end
 
//counter logic
always@(posedge clock)
begin
count_2<= 5'b1;
if (resetn == 1'b0)
 count_2 <= 5'b1;
 else if (vld_out_2)
 begin
 if (read_enb_2)
   count_2 <= 5'b1;
  else if(count_2 == 5'd30)
    count_2 <= 5'b1;
  else
   count_2 <= count_2 + 5'b1;
 end
 end
 
//soft_reset logic
always@(posedge clock)
begin
if(resetn ==1'b0)
soft_reset_0 <= 1'b0;
else if (vld_out_0)
begin
if (read_enb_0)
   soft_reset_0 <= 1'b0;
 else if (count_0 == 5'd30)
    soft_reset_0 <= 1'b1;
	
 else
   soft_reset_0 <= 1'b0;
end
end
//soft_reset logic
always@(posedge clock)
begin
if(resetn == 1'b0)
soft_reset_1 <= 1'b0;
else if (vld_out_1)
begin
if (read_enb_1)
   soft_reset_1 <= 1'b0;
 else if (count_1 == 5'd30)
    soft_reset_1 <= 1'b1;
	
 else
   soft_reset_1 <= 1'b0;
end
end
//soft_reset logic
always@(posedge clock)
begin
if(resetn == 1'b0)
soft_reset_2 <= 1'b0;
else if (vld_out_2)
begin
if (read_enb_2)
   soft_reset_2 <= 1'b0;
 else if (count_2 == 5'd30)
    soft_reset_2 <= 1'b1;
	
 else
   soft_reset_2 <= 1'b0;
end
end
endmodule


   


   