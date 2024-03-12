//import test_pkg::*;
class transaction;
  rand bit            rst_n;
  rand bit            ALU_en;
  rand bit            a_en;
  rand bit            b_en;
  rand bit    [2:0]   a_op;
  rand bit    [1:0]   b_op;
  rand bit    [4:0]   A;
  rand bit    [4:0]   B;
       logic  [5:0]   c;

constraint reset_value {
    rst_n dist {
      1'b1 :/ 90,
      1'b0 :/ 10
    };
  }
  
constraint enables {(a_en & b_en) != 1'b0;}

constraint alu_enable{
    ALU_en dist{0:/10,1:/90};
  }

constraint enable_ab{
    a_en dist{
        0:/50,
        1:/50
        };
    b_en dist{
        0:/50,
        1:/50
        };
  }
constraint op_ab_c{
    a_op dist{0:/50,1:/50,2:/50,3:/50,4:/50,5:/50,6:/50};
    b_op dist{0:/50,1:/50,2:/50,3:/50};
  }
constraint illegal_opa_c{
    if(ALU_en && a_en && !b_en ){
        if(a_op == 3'b111){
           A <= 'b0;
           B <= 'b0;
            }
        }
    }
    
constraint illegal_opb_c{
    if(ALU_en && !a_en && b_en ){
       if(b_op==2'b11){
          A <= 'b0;
          B <= 'b0;
            }
        }
    }
constraint A_B {
 A dist {
    5'h0 :/ 60,
    [5'h1 : 5'hFF] :/ 40
    };
 B dist {
    5'h0 :/ 80,
    [5'h1 : 5'hFF] :/ 20
    };
}
        
  function void display_alu (input string class_name);
       $display("At %0t [%0s] ,rst_n=%0b,ALU_en=%0b,a_en=%0b,b_en=%0b,a_op=%0b,b_op=%0b,A=%0x,B=%0x,c=%0x",
                $time,class_name,rst_n,ALU_en,a_en,b_en,a_op,b_op,A,B,c);
       
  endfunction:display_alu
  function transaction copy();
    copy=new();
    copy.rst_n = this.rst_n;
    copy.ALU_en=this.ALU_en;
    copy.a_en=this.a_en;
    copy.b_en=this.b_en;
    copy.a_op=this.a_op;
    copy.b_op=this.b_op;
    copy.A=this.A;
    copy.B=this.B;
    copy.c=this.c;
 endfunction
endclass
