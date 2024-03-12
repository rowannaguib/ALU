//import test_pkg::*;

class coverage;

	transaction tr;
	mailbox#(transaction) mb2cov;
    virtual alu_ifc vif;
    event next;
    
covergroup cg;
	opa: coverpoint tr.a_op;
 	en_a: coverpoint tr.a_en;
	cross opa,en_a;
    opb: coverpoint tr.b_op;
    en_b: coverpoint tr.b_en;
    cross opb,en_b;
    ina:coverpoint tr.A;
    inb:coverpoint tr.B;
    rst:coverpoint tr.rst_n;
    out:coverpoint tr.c;
endgroup

  function new(mailbox#(transaction) mb2cov);
    this.mb2cov=mb2cov;
    cg=new();
  endfunction:new

  task run();
    forever begin
      mb2cov.get(tr);
      tr.display_alu("[COV]");
      cg.sample();
      $display("                      ********************************                ");
    end
  endtask:run

endclass:coverage
