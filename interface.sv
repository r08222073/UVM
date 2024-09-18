//--------------------------------------------------------

interface CNC_if(input logic clk,reset);

  //---------------------------------------
  //declaring the signals
  //---------------------------------------
  logic in_en;
  logic [1:0] mode;
  logic [7:0] in_data;
  logic out_en;
  logic [16:0] out_data;   

  //---------------------------------------
  //driver clocking block
  //---------------------------------------
  clocking driver_cb @(negedge clk);
    default input #1 output #1;
    output in_data;
    output in_en;
    output mode;
    input  out_en; 
    input out_data; 
  endclocking
  
  //---------------------------------------
  //monitor clocking block
  //---------------------------------------
  clocking monitor_cb @(posedge clk);
    default input #1 output #1;
    input mode;
    input in_en;
    input in_data;
    input out_en;  
    input out_data;
      
  endclocking
  
  //---------------------------------------
  //driver modport
  //---------------------------------------
  modport DRIVER  (clocking driver_cb,input clk,reset);
  
  //---------------------------------------
  //monitor modport  
  //---------------------------------------
  modport MONITOR (clocking monitor_cb,input clk,reset);
  
endinterface
