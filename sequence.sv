
// sequence - random stimulus 
//=========================================================================
class CNC_sequence extends uvm_sequence#(CNC_seq_item);
  
  `uvm_object_utils(CNC_sequence)
  
  //--------------------------------------- 
  //Constructor
  //---------------------------------------
  function new(string name = "CNC_sequence");
    super.new(name);
  endfunction
  
  `uvm_declare_p_sequencer(CNC_sequencer)
  
  //---------------------------------------
  // create, randomize and send  to driver
  //---------------------------------------
  virtual task body();
    repeat(10) begin
    req = CNC_seq_item::type_id::create("req");
    wait_for_grant();
    req.randomize();
     `uvm_info(get_type_name(),$sformatf("sequence.req.a: %0d",req.a),UVM_LOW)
     `uvm_info(get_type_name(),$sformatf("sequence.req.mode: %0d",req.mode),UVM_LOW)
    send_request(req);
    wait_for_item_done();
   end 
  endtask
endclass
//=========================================================================

class write_sequence extends uvm_sequence#(CNC_seq_item);
  
  `uvm_object_utils(write_sequence)
   
  //--------------------------------------- 
  //Constructor
  //---------------------------------------
  function new(string name = "write_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_do_with(req, {
      req.in_en ==1;      
    })

  endtask
endclass

//=========================================================================
class write_read_sequence extends uvm_sequence#(CNC_seq_item);
  
  `uvm_object_utils(write_read_sequence)
   
  //--------------------------------------- 
  //Constructor
  //---------------------------------------
  function new(string name = "write_read_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_do_with(req,{req.in_en==1;})
  endtask
endclass
  //=========================================================================



class wr_sequence extends uvm_sequence#(CNC_seq_item);
  
  //--------------------------------------- 
  //Declaring sequences
  //---------------------------------------
  write_sequence wr_seq;
  
  `uvm_object_utils(wr_sequence)
   
  //--------------------------------------- 
  //Constructor
  //---------------------------------------
  function new(string name = "wr_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_do(wr_seq)
  endtask
endclass
//=========================================================================