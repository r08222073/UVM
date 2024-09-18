

class CNC_sequencer extends uvm_sequencer#(CNC_seq_item);

  `uvm_component_utils(CNC_sequencer) 

  //---------------------------------------
  //constructor
  //---------------------------------------
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
endclass