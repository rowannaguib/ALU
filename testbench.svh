//import test_pkg::*;
`timescale 1ns/1ps
`include "interface.sv"
`include "transaction.svh"
`include "generator.svh"
`include "driver.svh"
`include "monitor.svh"
`include "scoreboard.svh"
`include "coverage.svh"
`include "environment.svh"
//`include "ALU.sv"
module tb;
  alu_ifc ifc();
  environment env;
  initial begin
   ifc.clk <= 0;
    forever#10 ifc.clk <= ~ifc.clk;
  end

 ALU dut( ifc.clk,ifc.rst_n,ifc.ALU_en,ifc.a_en,ifc.b_en,ifc.a_op,ifc.b_op,ifc.A,ifc.B,ifc.c);

  initial begin
    env=new(ifc);
    env.gen.count=1500;
    env.run();
  end
 
 
 initial begin
    $dumpfile("test.vcd");
    $dumpvars;
  end
  `ifdef FSDB
  initial begin
    $fsdbDumpfile("textbench.fsdb");
    $fsdbDumpvars;
  end
  `endif
endmodule:tb