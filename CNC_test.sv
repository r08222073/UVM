
class CNC_test extends CNC_base_test;

  `uvm_component_utils(CNC_test)
  
  //---------------------------------------
  // sequence instance 
  //--------------------------------------- 
  wr_sequence seq;

  //---------------------------------------
  // constructor
  //---------------------------------------
  function new(string name = "CNC_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  //---------------------------------------
  // build_phase
  //---------------------------------------
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create the sequence
    seq = wr_sequence::type_id::create("seq");
  endfunction : build_phase
  
  //---------------------------------------
  // run_phase - starting the test
  //---------------------------------------
  task run_phase(uvm_phase phase);
    
    phase.raise_objection(this);
     repeat(10) begin 
      seq.start(env.CNC_agnt.sequencer);
    end

    phase.raise_objection(this);
    seq.start(env.CNC_agnt.sequencer);
    phase.drop_objection(this);
    
    //set a drain-time for the environment if desired
    phase.phase_done.set_drain_time(this, 2500);
  endtask : run_phase
  
endclass : CNC_test