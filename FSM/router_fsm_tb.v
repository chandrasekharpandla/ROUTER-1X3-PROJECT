module router_fsm_tb();
reg clock,resetn,pkt_valid,parity_done,fifo_full,soft_reset_0,soft_reset_1,soft_reset_2,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2;
reg [1:0] data_in;
wire busy,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state;

router_fsm DUT (.clock(clock),.resetn(resetn),.pkt_valid(pkt_valid),.parity_done(parity_done),.fifo_full(fifo_full),
                 .soft_reset_0(soft_reset_0),.soft_reset_1(soft_reset_1),.soft_reset_2(soft_reset_2),
                 .low_pkt_valid(low_pkt_valid),.fifo_empty_0(fifo_empty_0),.fifo_empty_1(fifo_empty_1),.fifo_empty_2(fifo_empty_2),.data_in(data_in),
				 .busy(busy),.detect_add(detect_add),.ld_state(ld_state),.laf_state(laf_state),.full_state(full_state),.write_enb_reg(write_enb_reg),
				 .rst_int_reg(rst_int_reg),.lfd_state(lfd_state));
				 
initial
begin
clock = 1'b0;
forever #5 clock = ~clock;
end

task initialize;
begin
{pkt_valid,parity_done,fifo_full,soft_reset_0,soft_reset_1,soft_reset_2,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,data_in} = 0;
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

task t1;
begin
@(negedge clock);
pkt_valid = 1'b1;
data_in = 2'b01;
fifo_empty_1 = 1'b1;
@(negedge clock);
@(negedge clock);
fifo_full = 1'b0;
pkt_valid = 1'b0;
@(negedge clock);
@(negedge clock);
fifo_full = 1'b0;
end
endtask

task t2;
begin
@(negedge clock);
pkt_valid = 1'b1;
data_in = 2'b01;
fifo_empty_1 = 1'b1;
@(negedge clock);
@(negedge clock);
fifo_full = 1'b1;
@(negedge clock);
fifo_full = 1'b0;
@(negedge clock);
parity_done = 1'b0;
low_pkt_valid = 1'b1;
@(negedge clock);
@(negedge clock);
fifo_full = 1'b0;
end
endtask

task t3;
begin
@(negedge clock);
pkt_valid = 1'b1;
data_in = 2'b01;
fifo_empty_1 = 1'b1;
@(negedge clock);
@(negedge clock);
fifo_full = 1'b1;
@(negedge clock);
fifo_full = 1'b0;
@(negedge clock);
parity_done = 1'b0;
low_pkt_valid = 1'b0;
@(negedge clock);
fifo_full = 1'b0;
pkt_valid = 1'b0;
@(negedge clock);
@(negedge clock);
fifo_full = 1'b0;
end
endtask

task t4;
begin
@(negedge clock);
pkt_valid = 1'b1;
data_in = 2'b01;
fifo_empty_1 = 1'b1;
@(negedge clock);
@(negedge clock);
fifo_full = 1'b0;
pkt_valid = 1'b0;
@(negedge clock);
@(negedge clock);
fifo_full = 1'b1;
@(negedge clock);
fifo_full = 1'b0;
@(negedge clock);
parity_done = 1'b1;
end
endtask

initial
begin
initialize;
reset;
t1;
#10;
t2;
#10;
t3;
#10;
t4;
#10;
end
initial
#500 $finish;
endmodule





				 