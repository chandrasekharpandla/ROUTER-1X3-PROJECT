module router_reg (clock,resetn,pkt_valid,data_in,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,parity_done,low_pkt_valid,err,dout);

input clock,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state;
input [7:0] data_in;
output reg parity_done,low_pkt_valid,err;
output reg [7:0] dout;
reg [7:0] header,fifo_full_state,internal_parity,packet_parity;
// RTL for dout
always@(posedge clock)
begin
if(!resetn)
begin
dout <= 8'b0;
header <= 8'b0;
end
else if(detect_add && pkt_valid && data_in[1:0] != 3)
  header <= data_in;
else if (lfd_state)
dout <= header;
else if (ld_state && !fifo_full)
dout <= data_in;
else if (ld_state && fifo_full)
fifo_full_state <= data_in;
else if (laf_state)
dout <= fifo_full_state;
end

//RTL for internal parity
always@(posedge clock)
begin
if(!resetn)
internal_parity <= 8'b0;
else if(!detect_add)
begin
if(lfd_state)
internal_parity <= internal_parity ^ header;
else if (pkt_valid && ld_state&& !full_state)
internal_parity <= internal_parity ^ data_in;
else 
begin
if(detect_add)
internal_parity <= 8'b0;
end
end
end

//RTL for packet_parity
always@(posedge clock)
begin
if(!resetn)
packet_parity <= 8'b0;
else if(!detect_add)
begin
if(ld_state && !pkt_valid)
packet_parity <= data_in;
end
end
//RTL for Error
always@(posedge clock)
begin
if(!resetn)
err <= 1'b0;
else if (parity_done)
begin
if(packet_parity != internal_parity)
err <= 1'b1;
else 
err <= 1'b0;
end
end

//RTL for low_pkt_valid
always@(posedge clock)
begin
if(!resetn)
low_pkt_valid <= 1'b0;
else if (rst_int_reg)
low_pkt_valid <= 1'b0;
else if (ld_state && !pkt_valid)
low_pkt_valid <= 1'b1;
end
//RTL for parity_done
always@(posedge clock)
begin
if(!resetn)
parity_done <= 1'b0;
else if(!detect_add)
begin
if(ld_state && !pkt_valid)
parity_done <= 1'b1;
else if(laf_state && low_pkt_valid && !parity_done)
parity_done <= 1'b1;
end
end
endmodule



