
//including interfcae and testcase files
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "interface.sv"
`include "base_test.sv"
`include "CNC_test.sv"
//---------------------------------------------------------------

module tbench_top;

  //---------------------------------------
  //clock and reset signal declaration
  //---------------------------------------
  bit clk;
  bit reset;
  
  //---------------------------------------
  //clock generation
  //---------------------------------------
  always #5 clk = ~clk;
  
  //---------------------------------------
  //reset Generation
  //---------------------------------------
  initial begin
    reset = 1;
    #5 reset =0;
    #5 reset =1;
  end
  
  //---------------------------------------
  //interface instance
  //---------------------------------------
  CNC_if intf(clk,reset);
  
  //---------------------------------------
  //DUT instance
  //---------------------------------------
  CNC DUT (
    .clk(intf.clk),
    .rst_n(intf.reset),
    .IN_VALID(intf.in_en),
    .MODE(intf.mode),
    .IN(intf.in_data),
    .OUT_VALID(intf.out_en),
    .OUT(intf.out_data)
   );
  
  //---------------------------------------
  //passing the interface handle to lower heirarchy using set method 
  //and enabling the wave dump
  //---------------------------------------
  initial begin 
    uvm_config_db#(virtual CNC_if)::set(uvm_root::get(),"*","vif",intf);
    //enable wave dump
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end
  
  //---------------------------------------
  //calling test
  //---------------------------------------
  initial begin 
    run_test("CNC_test");
  end
  
endmodule