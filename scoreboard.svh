//import test_pkg::*;
class scoreboard;
  transaction tr;
  mailbox#(transaction) mb;
  virtual alu_ifc vif;
  event next;
  logic[5:0] exp_c;

  function new(mailbox#(transaction) mb);
    this.mb=mb;
  endfunction:new

  task run();
    forever begin
      mb.get(tr);
      tr.display_alu("[SCB]");
      if(!tr.rst_n)begin
         exp_c=6'b0;
      end

    else begin
    if(tr.ALU_en)begin
      if((tr.a_en==1'b1) && (tr.b_en==1'b0))begin //a_en is high , b_en is low 
          case(tr.a_op)
            3'b0:       exp_c= tr.A + tr.B;             //ADD_a 
            3'b001:     exp_c= tr.A - tr.B;             //SUB_a 
            3'b010:     exp_c= tr.A ^ tr.B;             //XOR_a 
            3'b011:     exp_c= tr.A & tr.B;             //AND_a
            3'b100:     exp_c= tr.A & tr.B;             //AND__a 
            3'b101:     exp_c= tr.A | tr.B;             //OR_a
            3'b110:     exp_c= ~(tr.A ^ tr.B);          //XNOR_a
            3'b111:     exp_c= 6'b0;                    //NULL_a
          endcase
      end
      
      else if((tr.a_en==1'b0) && (tr.b_en==1'b1))begin
          case(tr.b_op)
            2'b0:      exp_c= ~(tr.A & tr.B);       //NAND_b_1 
            2'b01:     exp_c= tr.A + tr.B;          //ADD_b_1 
            2'b10:     exp_c= tr.A + tr.B;          //ADD__b_1 
            2'b11:     exp_c= 6'b0;                 //NULL_a
          endcase
     end

     else if((tr.a_en==1'b1) && (tr.b_en==1'b1))begin
          case(tr.b_op)
            2'b0:      exp_c= tr.A ^ tr.B;          //XOR_b_2  
            2'b01:     exp_c= ~(tr.A ^ tr.B);       //XNOR_b_2
            2'b10:     exp_c= tr.A - 1;          //DEC_b_2  
            2'b11:     exp_c= tr.B + 2;                 //ADD2_b_2
         endcase
     end

    else
        exp_c=exp_c;
    end
    else
        exp_c=exp_c;
    end
      assert(exp_c==tr.c) 
    $display("[SCB]: ****************CORRECT:exp_c=%0x,c=%0x ****************",exp_c,tr.c);
    else
    $error("[SCB]: ****************FAILED:exp_c=%0x,c=%0x ****************",exp_c,tr.c);
       
    end
  endtask:run
endclass

