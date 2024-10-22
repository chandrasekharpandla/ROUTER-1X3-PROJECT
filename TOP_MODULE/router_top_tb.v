module router_top_tb();
reg clock,resetn,read_enb_0,read_enb_1,read_enb_2,pkt_valid;
reg [7:0] data_in;
wire [7:0] data_out_0,data_out_1,data_out_2;
wire valid_out_0,valid_out_1,valid_out_2,error,busy;
integer i;


router_top DUT (.clock(clock),.resetn(resetn),.read_enb_0(read_enb_0),.read_enb_1(read_enb_1),.read_enb_2(read_enb_2),.pkt_valid(pkt_valid),
                .data_in(data_in),.data_out_0(data_out_0),.data_out_1(data_out_1),.data_out_2(data_out_2),.error(error),.busy(busy),
				.valid_out_0(valid_out_0),.valid_out_1(valid_out_1),.valid_out_2(valid_out_2));
				
initial
begin
clock = 1'b0;
forever #5 clock = ~clock;
end
task reset;
begin
@(negedge clock);
resetn = 1'b0;
@(negedge clock);
resetn = 1'b1;
end
endtask

task initialize;
begin
{read_enb_0,read_enb_1,read_enb_2,pkt_valid,data_in} = 0;
end
endtask

//payload = 14

task t1;
reg [7:0] header,payload,parity;
reg [5:0] payload_length;
reg [1:0] address;
begin
@(negedge clock);
wait(~busy)
@(negedge clock);
payload_length = 6'd14;
address = 2'b10;
header = {payload_length,address};
parity = 0;
data_in = header;
pkt_valid = 1'b1;
parity = parity ^ header;
@(negedge clock);
wait(~busy)
for(i = 0;i<payload_length;i = i+1)
begin
@(negedge clock);
wait(~busy)
payload = {$random}%256;
data_in = payload;
parity = parity^data_in;
end
@(negedge clock);
wait(~busy)
pkt_valid = 1'b0;
data_in = parity;
end
endtask

//payload <14

task t2;
reg [7:0] header,payload,parity;
reg [5:0] payload_length;
reg [1:0] address;
begin
@(negedge clock);
wait(~busy)
@(negedge clock);
payload_length = 6'd14;
address = 2'b10;
header = {payload_length,address};
parity = 0;
data_in = header;
pkt_valid = 1'b1;
parity = parity^header;
@(negedge clock);
wait(~busy)
for(i = 0;i<payload_length;i=i+1)
begin
@(negedge clock);
wait(~busy)
payload = {$random}%256;
data_in = payload;
parity = parity^payload;
end
@(negedge clock);
wait(~busy)
begin
pkt_valid = 1'b0;
data_in = parity;
end
end
endtask

//payload >14
task t3;
reg [7:0] header,payload,parity;
reg [5:0] payload_length;
reg [1:0] address;
begin
@(negedge clock);
wait(~busy)
@(negedge clock);
payload_length = 6'd18;
address = 2'b10;
header = {payload_length,address};
parity = 0;
data_in = header;
pkt_valid = 1'b1;
parity = parity^header;
@(negedge clock);
wait(~busy)
for(i = 0;i<payload_length;i=i+1)
begin
@(negedge clock);
wait(~busy)
payload = {$random}%256;
data_in = payload;
parity = parity^payload;
end
@(negedge clock);
wait(~busy)
pkt_valid = 1'b0;
data_in = parity;
end
endtask

initial
begin
initialize;
reset;
@(negedge clock);
t2;
@(negedge clock);
read_enb_2 = 1'b1;
 wait(~valid_out_2);
 @(negedge clock);
 read_enb_2 = 1'b0;
end
initial
#500 $finish();
endmodule






