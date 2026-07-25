`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.07.2026 14:29:46
// Design Name: 
// Module Name: wallacetree_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module wallacetree_tb;
reg clk,rst_n;
reg [7:0]a,b;
wire [15:0]p;
wire valid_out;

wallace_tree dut(.clk(clk),.rst_n(rst_n),.a(a),.b(b),.p(p),.valid_out(valid_out));
// clk generation
initial clk=0;
always #10 clk = ~clk;
// 10ns for high and 10ns for low. total 20 ns means 50mhz
initial
begin
a=0;
b=0;
rst_n=0;
#20
rst_n=1;
#20
a=8'd5;
b=8'd10;
#20
a=8'd16;
b=8'd20;
#20
a=8'd7;
b=8'd10;
#20
if(p==16'd50)
begin
$display("5*10 = %d ---PASS ",p);
end
else
begin
$display("FAIL=%d",p);
end
a=8'd255;
b=8'd255;
#20
if(p==16'd320)
begin
$display("16*20 = %d ---PASS ",p);
end
else
begin
$display("FAIL=%d",p);
end
#20
if(p==16'd70)
begin
$display("7*10 = %d ---PASS ",p);
end
else
begin
$display("FAIL=%d",p);
end
#20; 
if (p== 16'd65025)
begin
$display("255*255 = %d  ---PASS",p); 
end
else 
begin
$display ("fail=%d",p);
end
#20
$finish;
end
endmodule
