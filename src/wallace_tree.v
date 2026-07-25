`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.06.2026 17:15:20
// Design Name: 
// Module Name: wallace_tree
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

module fa(input x,y,z,output sum,carry);
assign sum = x^y^z;
assign carry = x&y | y&z | z&x;
endmodule

module ha(input x,y,output sum,carry);
assign sum = x^y;
assign carry = x&y;
endmodule
 
module wallace_tree(input clk,input rst_n,input [7:0]a,input[7:0]b,
output[15:0]p,output valid_out);
reg [7:0]r0,r1,r2,r3,r4,r5,r6,r7;

//step 1
always@(posedge clk)
begin
if(!rst_n)
begin
r0<=8'b0;
r1<=8'b0;
r2<=8'b0;
r3<=8'b0;
r4<=8'b0;
r5<=8'b0;
r6<=8'b0;
r7<=8'b0;
end
else 
begin
r0<= a&{8{b[0]}};
r1<= a&{8{b[1]}};
r2<= a&{8{b[2]}};
r3<= a&{8{b[3]}};
r4<= a&{8{b[4]}};
r5<= a&{8{b[5]}};
r6<= a&{8{b[6]}};
r7<= a&{8{b[7]}};
end
end
//LEVEL 1 REDUCTION
// col1
wire c1_sum , c1_carry;
ha c1_adder(.x(r0[1]),.y(r1[0]),.sum(c1_sum),.carry(c1_carry));
// col2
wire c2_sum , c2_carry;
fa c2_adder(.x(r0[2]),.y(r1[1]),.z(r2[0]),.sum(c2_sum),.carry(c2_carry));
// col3
wire c3_sum , c3_carry;
fa c3_adder(.x(r0[3]),.y(r1[2]),.z(r2[1]),.sum(c3_sum),.carry(c3_carry));
// col4
wire c4_sum0 , c4_carry0;
wire c4_sum1 , c4_carry1;
fa c4_adder0(.x(r0[4]),.y(r1[3]),.z(r2[2]),.sum(c4_sum0),.carry(c4_carry0));
ha c4_adder1(.x(r3[1]),.y(r4[0]),.sum(c4_sum1),.carry(c4_carry1));
// col5
wire c5_sum0 , c5_carry0;
wire c5_sum1 , c5_carry1;
fa c5_adder0(.x(r0[5]),.y(r1[4]),.z(r2[3]),.sum(c5_sum0),.carry(c5_carry0));
fa c5_adder1(.x(r3[2]),.y(r4[1]),.z(r5[0]),.sum(c5_sum1),.carry(c5_carry1));
// col6
wire c6_sum0 , c6_carry0;
wire c6_sum1 , c6_carry1;
fa c6_adder0(.x(r0[6]),.y(r1[5]),.z(r2[4]),.sum(c6_sum0),.carry(c6_carry0));
fa c6_adder1(.x(r3[3]),.y(r4[2]),.z(r5[1]),.sum(c6_sum1),.carry(c6_carry1));
// col7
wire c7_sum0 , c7_carry0;
wire c7_sum1 , c7_carry1;
wire c7_sum2 , c7_carry2;
fa c7_adder0(.x(r0[7]),.y(r1[6]),.z(r2[5]),.sum(c7_sum0),.carry(c7_carry0));
fa c7_adder1(.x(r3[4]),.y(r4[3]),.z(r5[2]),.sum(c7_sum1),.carry(c7_carry1));
ha c7_adder2(.x(r6[1]),.y(r7[0]),.sum(c7_sum2),.carry(c7_carry2));
// col8
wire c8_sum0 , c8_carry0;
wire c8_sum1 , c8_carry1;
fa c8_adder0(.x(r1[7]),.y(r2[6]),.z(r3[5]),.sum(c8_sum0),.carry(c8_carry0));
fa c8_adder1(.x(r4[4]),.y(r5[3]),.z(r6[2]),.sum(c8_sum1),.carry(c8_carry1));
// col9
wire c9_sum0 , c9_carry0;
wire c9_sum1 , c9_carry1;
fa c9_adder0(.x(r2[7]),.y(r3[6]),.z(r4[5]),.sum(c9_sum0),.carry(c9_carry0));
fa c9_adder1(.x(r5[4]),.y(r6[3]),.z(r7[2]),.sum(c9_sum1),.carry(c9_carry1));
// col10
wire c10_sum0 , c10_carry0;
wire c10_sum1 , c10_carry1;
fa c10_adder0(.x(r3[7]),.y(r4[6]),.z(r5[5]),.sum(c10_sum0),.carry(c10_carry0));
ha c10_adder1(.x(r6[4]),.y(r7[3]),.sum(c10_sum1),.carry(c10_carry1));
// col11
wire c11_sum , c11_carry;
fa c11_adder(.x(r4[7]),.y(r5[6]),.z(r6[5]),.sum(c11_sum),.carry(c11_carry));
// col12
wire c12_sum , c12_carry;
fa c12_adder(.x(r5[7]),.y(r6[6]),.z(r7[5]),.sum(c12_sum),.carry(c12_carry));
// col13
wire c13_sum , c13_carry;
ha c13_adder(.x(r6[7]),.y(r7[6]),.sum(c13_sum),.carry(c13_carry));

// step 2
reg [0:0] col0;
reg [0:0] col1;
reg [1:0] col2;
reg [2:0] col3;
reg [2:0] col4;
reg [3:0] col5;
reg [4:0] col6;
reg [4:0] col7;
reg [5:0] col8;
reg [3:0] col9;
reg [3:0] col10;
reg [3:0] col11;
reg [1:0] col12;
reg [1:0] col13;
reg [1:0] col14;
//SAVING RESULTS for LEVEL 2 REDUCTION
///////////////////////////////////////stage 2 pipeline\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
always @(posedge clk)
begin
if(!rst_n)
begin
col0<=1'b0;
col1<=1'b0;
col2<=2'b0;
col3<=3'b0;
col4<=3'b0;
col5<=4'b0;
col6<=5'b0;
col7<=5'b0;
col8<=6'b0;
col9<=4'b0;
col10<=4'b0;
col11<=4'b0;
col12<=2'b0;
col13<=2'b0;
col14<=2'b0;
end
else
begin
col0[0]<=r0[0];
col1[0]<=c1_sum;
col2[0]<=c1_carry;
col2[1]<=c2_sum;
col3[0]<=c2_carry;
col3[1]<=c3_sum;
col3[2]<=r3[0];
col4[0]<=c3_carry;
col4[1]<=c4_sum0;
col4[2]<=c4_sum1;
col5[0]<=c4_carry0;
col5[1]<=c4_carry1;
col5[2]<=c5_sum0;
col5[3]<=c5_sum1;
col6[0]<=c5_carry0;
col6[1]<=c5_carry1;
col6[2]<=c6_sum0;
col6[3]<=c6_sum1;
col6[4]<=r6[0];
col7[0]<=c6_carry0;
col7[1]<=c6_carry1;
col7[2]<=c7_sum0;
col7[3]<=c7_sum1;
col7[4]<=c7_sum2;
col8[0]<=c7_carry0;
col8[1]<=c7_carry1;
col8[2]<=c7_carry2;
col8[3]<=c8_sum0;
col8[4]<=c8_sum1;
col8[5]<=r7[1];
col9[0]<=c8_carry0;
col9[1]<=c8_carry1;
col9[2]<=c9_sum0;
col9[3]<=c9_sum1;
col10[0]<=c9_carry0;
col10[1]<=c9_carry1;
col10[2]<=c10_sum0;
col10[3]<=c10_sum1;
col11[0]<=c10_carry0;
col11[1]<=c10_carry1;
col11[2]<=c11_sum;
col11[3]<=r7[4];
col12[0]<=c11_carry;
col12[1]<=c12_sum;
col13[0]<=c12_carry;
col13[1]<=c13_sum;
col14[0]<=c13_carry;
col14[1]<=r7[7];
end
end

//level 2 reduction
//col3
wire c3l2_sum , c3l2_carry;
fa c3l2_adder(.x(col3[0]),.y(col3[1]),.z(col3[2]),.sum(c3l2_sum),.carry(c3l2_carry));
//col4
wire c4l2_sum , c4l2_carry;
fa c4l2_adder(.x(col4[0]),.y(col4[1]),.z(col4[2]),.sum(c4l2_sum),.carry(c4l2_carry));
//col5
wire c5l2_sum , c5l2_carry;
wire c5l2_bypass = col5[3];
fa c5l2_adder(.x(col5[0]),.y(col5[1]),.z(col5[2]),.sum(c5l2_sum),.carry(c5l2_carry));
///col6
wire c6l2_sum0 , c6l2_carry0;
wire c6l2_sum1 , c6l2_carry1;
fa c6l2_adder0(.x(col6[0]),.y(col6[1]),.z(col6[2]),.sum(c6l2_sum0),.carry(c6l2_carry0));
ha c6l2_adder1(.x(col6[3]),.y(col6[4]),.sum(c6l2_sum1),.carry(c6l2_carry1));
//col7
wire c7l2_sum0 , c7l2_carry0;
wire c7l2_sum1 , c7l2_carry1;
fa c7l2_adder0(.x(col7[0]),.y(col7[1]),.z(col7[2]),.sum(c7l2_sum0),.carry(c7l2_carry0));
ha c7l2_adder1(.x(col7[3]),.y(col7[4]),.sum(c7l2_sum1),.carry(c7l2_carry1));
//col8
wire c8l2_sum0 , c8l2_carry0;
wire c8l2_sum1 , c8l2_carry1;
fa c8l2_adder0(.x(col8[0]),.y(col8[1]),.z(col8[2]),.sum(c8l2_sum0),.carry(c8l2_carry0));
fa c8l2_adder1(.x(col8[3]),.y(col8[4]),.z(col8[5]),.sum(c8l2_sum1),.carry(c8l2_carry1));
//col9
wire c9l2_sum , c9l2_carry;
wire c9l2_bypass = col9[3];
fa c9l2_adder(.x(col9[0]),.y(col9[1]),.z(col9[2]),.sum(c9l2_sum),.carry(c9l2_carry));
//col10
wire c10l2_sum , c10l2_carry;
wire c10l2_bypass = col10[3];
fa c10l2_adder(.x(col10[0]),.y(col10[1]),.z(col10[2]),.sum(c10l2_sum),.carry(c10l2_carry));
//col11
wire c11l2_sum , c11l2_carry;
wire c11l2_bypass = col11[3];
fa c11l2_adder(.x(col11[0]),.y(col11[1]),.z(col11[2]),.sum(c11l2_sum),.carry(c11l2_carry));
//col12
wire c12l2_bypass0 = col12[0];
wire c12l2_bypass1 = col12[1];
//col13
wire c13l2_bypass0 = col13[0];
wire c13l2_bypass1 = col13[1];
//col14
wire c14l2_bypass0 = col14[0];
wire c14l2_bypass1 = col14[1];

// level 3 reduction
//col5
wire c5l3_sum , c5l3_carry;
fa c5l3_adder(.x(c4l2_carry),.y(c5l2_sum),.z(c5l2_bypass),.sum(c5l3_sum),.carry(c5l3_carry));
//col6
wire c6l3_sum , c6l3_carry;
fa c6l3_adder(.x(c5l2_carry),.y(c6l2_sum0),.z(c6l2_sum1),.sum(c6l3_sum),.carry(c6l3_carry));
//col7
wire c7l3_sum , c7l3_carry;
wire c7l3_bypass = c7l2_sum1;
fa c7l3_adder(.x(c6l2_carry0),.y(c6l2_carry1),.z(c7l2_sum0),.sum(c7l3_sum),.carry(c7l3_carry));
//col8
wire c8l3_sum , c8l3_carry;
wire c8l3_bypass = c8l2_sum1;
fa c8l3_adder(.x(c7l2_carry0),.y(c7l2_carry1),.z(c8l2_sum0),.sum(c8l3_sum),.carry(c8l3_carry));
//col9
wire c9l3_sum , c9l3_carry;
wire c9l3_bypass = c9l2_bypass;
fa c9l3_adder(.x(c8l2_carry0),.y(c8l2_carry1),.z(c9l2_sum),.sum(c9l3_sum),.carry(c9l3_carry));
//col10
wire c10l3_sum , c10l3_carry;
fa c10l3_adder(.x(c9l2_carry),.y(c10l2_sum),.z(c10l2_bypass),.sum(c10l3_sum),.carry(c10l3_carry));
//col11
wire c11l3_sum , c11l3_carry;
fa c11l3_adder(.x(c10l2_carry),.y(c11l2_sum),.z(c11l2_bypass),.sum(c11l3_sum),.carry(c11l3_carry));
//col12
wire c12l3_sum , c12l3_carry;
fa c12l3_adder(.x(c11l2_carry),.y(c12l2_bypass0),.z(c12l2_bypass1),.sum(c12l3_sum),.carry(c12l3_carry));

//level4 reduction
//col7
wire c7l4_sum,c7l4_carry;
fa c7l4_adder(.x(c6l3_carry),.y(c7l3_sum),.z(c7l3_bypass),.sum(c7l4_sum),.carry(c7l4_carry));
//col8
wire c8l4_sum0,c8l4_carry0;
wire c8l4_sum1,c8l4_carry1;
fa c8l4_adder0(.x(c7l3_carry),.y(c8l3_sum),.z(c8l3_bypass),.sum(c8l4_sum0),.carry(c8l4_carry0));
ha c8l4_adder1(.x(c8l4_sum0),.y(c7l4_carry),.sum(c8l4_sum1),.carry(c8l4_carry1));
//col9
wire c9l4_sum0,c9l4_carry0;
wire c9l4_sum1,c9l4_carry1;
fa c9l4_adder0(.x(c8l3_carry),.y(c9l3_sum),.z(c9l3_bypass),.sum(c9l4_sum0),.carry(c9l4_carry0));
fa c9l4_adder1(.x(c8l4_carry0),.y(c8l4_carry1),.z(c9l4_sum0),.sum(c9l4_sum1),.carry(c9l4_carry1));
//col10
wire c10l4_sum0,c10l4_carry0;
wire c10l4_sum1,c10l4_carry1;
fa c10l4_adder0(.x(c9l3_carry),.y(c10l3_sum),.z(c9l4_carry0),.sum(c10l4_sum0),.carry(c10l4_carry0));
ha c10l4_adder1(.x(c9l4_carry1),.y(c10l4_sum0),.sum(c10l4_sum1),.carry(c10l4_carry1));
//col11
wire c11l4_sum0,c11l4_carry0;
wire c11l4_sum1,c11l4_carry1;
fa c11l4_adder0(.x(c10l3_carry),.y(c11l3_sum),.z(c10l4_carry0),.sum(c11l4_sum0),.carry(c11l4_carry0));
ha c11l4_adder1(.x(c10l4_carry1),.y(c11l4_sum0),.sum(c11l4_sum1),.carry(c11l4_carry1));
//col12
wire c12l4_sum0,c12l4_carry0;
wire c12l4_sum1,c12l4_carry1;
fa c12l4_adder0(.x(c11l3_carry),.y(c12l3_sum),.z(c11l4_carry0),.sum(c12l4_sum0),.carry(c12l4_carry0));
ha c12l4_adder1(.x(c11l4_carry1),.y(c12l4_sum0),.sum(c12l4_sum1),.carry(c12l4_carry1));
//col13
wire c13l4_sum0,c13l4_carry0;
wire c13l4_sum1,c13l4_carry1;
fa c13l4_adder0(.x(c12l3_carry),.y(c13l2_bypass0),.z(c13l2_bypass1),.sum(c13l4_sum0),.carry(c13l4_carry0));
fa c13l4_adder1(.x(c12l4_carry0),.y(c12l4_carry1),.z(c13l4_sum0),.sum(c13l4_sum1),.carry(c13l4_carry1));
//col14
wire c14l4_sum0,c14l4_carry0;
wire c14l4_sum1,c14l4_carry1;
fa c14l4_adder0(.x(c14l2_bypass0),.y(c14l2_bypass1),.z(c13l4_carry0),.sum(c14l4_sum0),.carry(c14l4_carry0));
ha c14l4_adder1(.x(c13l4_carry1),.y(c14l4_sum0),.sum(c14l4_sum1),.carry(c14l4_carry1));

// cla vectors
//////////////////////////////stage 3 pipeline////////////////////////////////////////////////
reg [15:0]s,k;
always @(posedge clk)
begin
if(!rst_n)
begin
s<=0;
k<=0;
end
else
begin
s<= {c14l4_carry0,c14l4_sum1,c13l4_sum1,c12l4_sum1,c11l4_sum1,c10l4_sum1,c9l4_sum1,c8l4_sum1,c7l4_sum
,c6l3_sum,c5l3_sum,c4l2_sum,c3l2_sum,col2[0],col1[0],col0[0]};
k<= {c14l4_carry1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,c5l3_carry,1'b0,c3l2_carry,1'b0,col2[1],1'b0,1'b0};
end
end

wire [15:0]z;
wire [15:0]x;
assign z = s;
assign x = k;

wire [15:0]cla_sum;
wire cla_carry;
cla16 cla_final(.a(z),.b(x),.cin(1'b0),.s(cla_sum),.cout(cla_carry));

assign valid_out = rst_n ? 1'b1:1'b0;
assign p=cla_sum; 
endmodule

