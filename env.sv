//----------------------------------------------------------------

`include "agent.sv"
`include "scoreboard.sv"

class CNC_env extends uvm_env;
  
  //---------------------------------------
  // agent and scoreboard instance
  //---------------------------------------
  CNC_agent      CNC_agnt;
  CNC_scoreboard CNC_scb;
  `uvm_component_utils(CNC_env)
  
  //--------------------------------------- 
  // constructor
  //---------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //---------------------------------------
  // build_phase - crate the components
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    CNC_agnt = CNC_agent::type_id::create("CNC_agnt", this);
    CNC_scb  = CNC_scoreboard::type_id::create("CNC_scb", this);
  endfunction : build_phase
  
  //---------------------------------------
  // connect_phase - connecting monitor and scoreboard port
  //---------------------------------------
  function void connect_phase(uvm_phase phase);
    CNC_agnt.monitor.item_collected_port.connect(CNC_scb.item_collected_export);
  endfunction : connect_phase

endclass : CNC_env