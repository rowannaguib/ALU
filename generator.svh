//import test_pkg::*;

class generator;
  virtual alu_ifc vif;
  transaction tr;
  mailbox #(transaction) mb;
  event next_tr;
  int count = 0;
  bit finsh_tr=1'b0;

  function new(mailbox#(transaction) mb);
    this.mb=mb;
    tr=new();
  endfunction:new

  task run();
    repeat(count)begin
      @(posedge vif.clk);
      assert(tr.randomize()) 
      else $error("Randomization failed");
    //   enables :
    //   assert ( (trans.a_en & trans.b_en) != 1 )
    //   else $error("[GEN] Both enables for mode 'a' and mode 'b' are low!");

    //   illegal_a :
    //   assert ( ((trans.a_en && (trans.a_op == 3'b1)) && !trans.b_en ) != 1 )
    //   else $error("[GEN] illegal value input in op_a !");

    //   illegal_b :
    //   assert ( ((!trans.a_en && (trans.b_op == 2'b11)) && trans.b_en ) != 1 )
    //   else $error("[GEN] illegal value input in op_b!");
      mb.put(tr);
    //   mbx.put(trans.copy());
      tr.display_alu("[GEN]: From Generator Class");
      @(posedge vif.clk);
      @(next_tr);
    end
    finsh_tr=1'b1;
  endtask:run

endclass
