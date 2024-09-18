
class CNC_seq_item extends uvm_sequence_item;
  //---------------------------------------
  //data
  //---------------------------------------

  rand bit [1:0] mode;
  rand bit [1:0] t;
  rand bit signed [7:0] a, b, c, d;
       bit signed [16:0] e,f; 
       bit out_en;
  rand bit in_en;
 
  
  
  //---------------------------------------
  //Field macros
  //---------------------------------------
  `uvm_object_utils_begin(CNC_seq_item)
    `uvm_field_int(a,UVM_ALL_ON)
    `uvm_field_int(b,UVM_ALL_ON)
    `uvm_field_int(c,UVM_ALL_ON)
    `uvm_field_int(d,UVM_ALL_ON)
    `uvm_field_int(e,UVM_ALL_ON)
    `uvm_field_int(f,UVM_ALL_ON)
    `uvm_field_int(mode,UVM_ALL_ON)
    `uvm_field_int(in_en,UVM_ALL_ON)    
    `uvm_field_int(out_en,UVM_ALL_ON)
    `uvm_field_int(t,UVM_ALL_ON)
  `uvm_object_utils_end
  
  //---------------------------------------
  //Constructor
  //---------------------------------------
  function new(string name = "CNC_seq_item");
    super.new(name);
  endfunction
  
  //---------------------------------------
  //Constaint
  //---------------------------------------
  constraint t_range { t inside {[0:1]}; }
  constraint mode_range { mode inside {[1:2]}; }
  
endclass