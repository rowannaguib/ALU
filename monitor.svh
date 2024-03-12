//import test_pkg::*;

class monitor;
  transaction tr;
  mailbox#(transaction) mb2scb;
  mailbox#(transaction) mb2cov;
  virtual alu_ifc vif;
  event next_tr;

  function new(virtual alu_ifc vif,mailbox#(transaction) mb2scb,mailbox#(transaction) mb2cov);
    this.vif=vif;
    this.mb2scb=mb2scb;
    this.mb2cov=mb2cov;
    tr=new();
  endfunction:new

  task run();
    forever begin
       @(posedge vif.clk);
       @(posedge vif.clk);
       #1ns;
      tr.rst_n=vif.rst_n;
      tr.ALU_en=vif.ALU_en;
      tr.a_en=vif.a_en;
      tr.b_en=vif.b_en ;
      tr.a_op=vif.a_op;
      tr.b_op=vif.b_op;
      tr.A=vif.A;
      tr.B=vif.B;
      tr.c=vif.c;
      mb2scb.put(tr);
      mb2cov.put(tr);
      tr.display_alu("MON");
     ->next_tr;
      
    end
  endtask:run
endclass
