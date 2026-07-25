`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.07.2026 20:38:59
// Design Name: 
// Module Name: cla16
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


module cla16(input [15:0]a,b,input cin,output [15:0]s,output cout);
wire c1,c2,c3;
cla cla0(.a(a[3:0]),.b(b[3:0]),.cin(cin),.s(s[3:0]),.cout(c1));
cla cla1(.a(a[7:4]),.b(b[7:4]),.cin(c1),.s(s[7:4]),.cout(c2));
cla cla2(.a(a[11:8]),.b(b[11:8]),.cin(c2),.s(s[11:8]),.cout(c3));
cla cla3(.a(a[15:12]),.b(b[15:12]),.cin(c3),.s(s[15:12]),.cout(cout));
endmodule
