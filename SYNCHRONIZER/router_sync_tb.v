module router_sync_tb();
reg detect_add,write_enb_reg,clock,resetn,read_enb_0,read_enb_1,read_enb_2,empty_0,empty_1,empty_2,full_0,full_1,full_2;
reg [1:0] data_in;
wire soft_reset_0,soft_reset_1,soft_reset_2,fifo_full;
wire vld_out_0,vld_out_1,vld_out_2;
wire [2:0] write_enb;
router_sync DUT (.detect_add(detect_add),.write_enb_reg(write_enb_reg),.clock(clock),.resetn(resetn),.read_enb_0(read_enb_0),.read_enb_1(read_enb_1),.read_enb_2(read_enb_2)
                 ,.empty_0(empty_0),.empty_1(empty_1),.empty_2(empty_2),.full_0(full_0),.full_1(full_1),.full_2(full_2),.data_in(data_in),.soft_reset_0(soft_reset_0),
				 .soft_reset_1(soft_reset_1),.soft_reset_2(soft_reset_2),.fifo_full(fifo_full),.vld_out_0(vld_out_0),.vld_out_1(vld_out_1),.vld_out_2(vld_out_2)
				 ,.write_enb(write_enb));

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
{data_in,detect_add,write_enb_reg,read_enb_0,read_enb_1,read_enb_2,empty_0,empty_1,empty_2,full_0,full_1,full_2} = 0;
end
endtask
task inputs(input [1:0]i,input e);
begin
@(negedge clock);
data_in = i;
detect_add = e;
end
endtask

task write (input j);
begin
#10;
write_enb_reg = j;
end
endtask
task full (input m,n,o);
begin
full_0 = m;
full_1 = n;
full_2 = o;
end
endtask
task read (input a,b,c);
begin
@(negedge clock);
read_enb_0 = a;
read_enb_1 = b;
read_enb_2 = c;
end
endtask
task empty(d,e,f);
begin
empty_0 = d;
empty_1 = e;
empty_2 = f;
end
endtask
initial
begin
initialize;
reset;
inputs (2'b10,1'b1);
write (1'b1);
#10;
full(1'b0,1'b0,1'b1);
#10;
read(1'b1,1'b1,1'b0);
#10;
empty (1'b1,1'b1,1'b0);
#10;
end
initial
#400 $finish;
endmodule

                  