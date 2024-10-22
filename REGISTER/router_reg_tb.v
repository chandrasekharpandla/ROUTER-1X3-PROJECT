module router_reg_tb();
reg clock,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state;
reg [7:0] data_in;
wire parity_done,low_pkt_valid,err;
wire [7:0] dout;
integer i;
router_reg DUT (.clock(clock),.resetn(resetn),.pkt_valid(pkt_valid),.fifo_full(fifo_full),.rst_int_reg(rst_int_reg),.detect_add(detect_add),.ld_state(ld_state),
                .laf_state(laf_state),.full_state(full_state),.lfd_state(lfd_state),.data_in(data_in),.parity_done(parity_done),.low_pkt_valid(low_pkt_valid),.err(err),
				.dout(dout));

initial
begin
clock = 1'b0;
forever #5 clock = ~clock;
end
task initialize;
begin
{resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,data_in} = 0;
end
endtask
task reset;
begin
@(negedge clock);
resetn = 1'b0;
@(negedge clock);
resetn = 1'b1;
end
endtask
task packet_generation;
reg [7:0] payload,parity,header;
reg [5:0] payload_length;
reg [1:0] address;
begin
@(negedge clock);
detect_add = 1'b1;
pkt_valid = 1'b1;
payload_length = 6'd4;
address = 2'b10;
header = {payload_length,address};
parity = 8'h00 ^ header;
data_in = header;
@(negedge clock);
detect_add = 1'b0;
lfd_state = 1'b1;
fifo_full = 1'b0;
full_state = 1'b0;
laf_state = 1'b0;
for (i =0;i< payload_length;i=i+1)
begin
@(negedge clock);
ld_state = 1'b1;
lfd_state = 1'b0;
payload = {$random}%2**8;
data_in = payload;
parity = parity ^ data_in;
end
@(negedge clock);
pkt_valid = 1'b0;
data_in = parity;
@(negedge clock);
ld_state = 1'b0;
end
endtask

task packet_generation1;
reg [7:0] payload,parity,header;
reg [5:0] payload_length;
reg [1:0] address;
begin
@(negedge clock);
detect_add = 1'b1;
pkt_valid = 1'b1;
payload_length = 6'd4;
address = 2'b10;
header = {payload_length,address};
parity = 8'h00 ^ header;
data_in = header;
@(negedge clock);
detect_add = 1'b0;
lfd_state = 1'b1;
fifo_full = 1'b0;
full_state = 1'b0;
laf_state = 1'b0;
for (i =0;i< payload_length;i = i+1)
begin
@(negedge clock);
ld_state = 1'b1;
lfd_state = 1'b0;
payload = {$random}%2**8;
data_in = payload;
parity = parity ^ data_in;
end
@(negedge clock);
pkt_valid = 1'b0;
data_in = {$random}%256;
@(negedge clock);
ld_state = 1'b0;
end
endtask
initial
begin
initialize;
reset;
packet_generation;
//packet_generation1;
#500 $finish;
end
endmodule




          