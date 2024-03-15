//import test_pkg::*;

class coverage;

	transaction tr;
	mailbox#(transaction) mb2cov;
    virtual alu_ifc vif;
    event next;
    
covergroup cg;
 	option.auto_bin_max = 256;
  	opa: coverpoint tr.a_op;
 	en_a: coverpoint tr.a_en;
  	cross opa,en_a{
    bins bin_op_a = binsof (opa) intersect{[0:7]};
    }
    opb: coverpoint tr.b_op;
    en_b: coverpoint tr.b_en;
  cross opb,en_b{
    bins bin_op_b = binsof (opb) intersect{[0:3]};
 	}
    ina:coverpoint tr.A;
    inb:coverpoint tr.B;
    rst:coverpoint tr.rst_n {bins activated = {0}; bins deactivated = {1};}
    out:coverpoint tr.c {bins off = {0};}
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
      $display ("Coverage = %.2f%%", cg.get_coverage());
      $display("                      ********************************                ");
    end
  endtask:run

endclass:coverage
