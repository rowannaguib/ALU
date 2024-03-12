//import test_pkg::*;

class environment;
  
  virtual alu_ifc ifc;
  event next;
  
  generator gen;
  driver drv;
  monitor mon;
  scoreboard scb;
  coverage cov;
  
  mailbox#(transaction) mb2drv;
  mailbox#(transaction) mb2scb;
  mailbox#(transaction) mb2cov;
 
  
  function new(virtual alu_ifc ifc);
    this.ifc=ifc;
    mb2drv=new();
    gen=new(mb2drv);
    drv=new(ifc,mb2drv);
    mb2scb=new();
    mb2cov=new();
    mon=new(ifc,mb2scb,mb2cov);
    scb=new(mb2scb);
    cov=new(mb2cov);
    gen.vif=this.ifc;
    scb.vif=this.ifc;
    cov.vif=this.ifc;
    gen.next_tr=next;
    drv.next_tr=next;
    mon.next_tr=next;
  endfunction:new

  task pre_test;
  	drv.reset();
  endtask

  task test;
    fork 
       gen.run();
       drv.run();
       mon.run();
      scb.run();
      cov.run();
    join_any
  endtask

  task post_test;
    wait(gen.finsh_tr==1'b1);
    $stop;
  endtask

  task run;
    test();
    post_test();
  endtask
  
endclass:environment
