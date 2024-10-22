module router_fifo_tb();
reg clock,resetn,soft_reset,lfd_state,read_enb,write_enb;
reg [7:0] data_in;
wire empty,full;
wire [7:0] data_out;
reg [7:0] header,payload,parity;
reg [1:0] address;
integer i;
router_fifo DUT (.clock(clock),.resetn(resetn),.soft_reset(soft_reset),.lfd_state(lfd_state),.read_enb(read_enb),.write_enb(write_enb),.data_in(data_in),.empty(empty),.full(full),.data_out(data_out));
initial
begin
clock = 1'b0;
forever #5 clock = ~clock;
end
task initialize;
begin
{resetn,soft_reset,lfd_state,read_enb,write_enb} = 0;
end
endtask
//reset operation
task reseta;
begin
@(negedge clock);
resetn = 1'b0;
@(negedge clock);
resetn = 1'b1;
end
endtask
task resetb;
begin
@(negedge clock);
soft_reset = 1'b1;
@(negedge clock);
soft_reset = 1'b0;
end
endtask
//wite operation
task write;
reg [5:0] payload_length;
begin
@(negedge clock);
address = 2'b01;
payload_length = 6'd8;
header = {payload_length,address};
data_in = header;
lfd_state = 1'b1;
write_enb = 1'b1;
for (i=0;i<payload_length;i=i+1)
begin
@(negedge clock);
payload = {$random}%2**8;
data_in = payload;
lfd_state = 1'b0;
end
@(negedge clock);
parity = {$random}%2**8;
data_in = parity;
end
endtask
task read;
begin
@(negedge clock);
read_enb = 1'b1;
write_enb = 1'b0;
end
endtask
initial
begin
initialize;
reseta;
resetb;
write;
read;
$monitor($time,"data_in = %b,data_out = %b,lfd_state = %b",data_in,data_out,lfd_state);
#400 $finish;
end
endmodule






