//import test_pkg::*;

class driver;
  transaction tr;
  int no_trans;
  mailbox#(transaction) mb;
  virtual alu_ifc vif;
  event next_tr;
  function new(virtual alu_ifc vif,mailbox#(transaction) mb);
    this.vif=vif;
    this.mb=mb;
  endfunction:new

  task reset();
     @(posedge vif.clk);
      vif.ALU_en <= 0;
      vif.a_en <= 0;
      vif.b_en <= 0;
      vif.a_op <= 3'b00;
      vif.b_op <= 2'b00;
      vif.A <= 5'h00;
      vif.B <= 5'h00;
      vif.rst_n <= 1'b0;
     $display("[DRV]: Reset Phase");
    @(posedge vif.clk);
    $display("At %0t [%0s] ,rst_n=%0b,ALU_en=%0b,a_en=%0b,b_en=%0b,a_op=%0b,b_op=%0b,A=%0x,B=%0x,c=%0x",
             $time,"[DRV]",vif.rst_n,vif.ALU_en,vif.a_en,vif.b_en,vif.a_op,vif.b_op,vif.A,vif.B,vif.c);
    // @(posedge vif.clk);
    // vif.rst_n <= 1'b1;
    // @(posedge vif.clk);
    $display("[DRV]: reset done");
    endtask:reset
    
  task run();
       reset();
    forever begin
      @(posedge vif.clk);
      mb.get(tr);
      tr.display_alu("[DRV]");
      vif.rst_n<=tr.rst_n;
      vif.ALU_en <= tr.ALU_en;
      vif.a_en <= tr.a_en;
      vif.b_en <= tr.b_en;
      vif.a_op <= tr.a_op;
      vif.b_op <= tr.b_op;
      vif.A <= tr.A;
      vif.B <= tr.B;
      $display("driver transaction is %p at time: %0t", tr, $realtime);
     ->next_tr;
    //  no_trans++;
    end
  endtask:run
endclass
