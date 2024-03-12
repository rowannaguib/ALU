//import test_pkg::*;
interface alu_ifc;
  logic       clk; 
  bit       rst_n;
  logic       ALU_en,a_en,b_en;
  logic [2:0] a_op;
  logic [1:0] b_op;
  logic [4:0] A;
  logic [4:0] B;
  logic [6:0] c;
  
endinterface
