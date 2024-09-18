`include "seq_item.sv"
`include "sequencer.sv"
`include "sequence.sv"
`include "driver.sv"
`include "monitor.sv"

class CNC_agent extends uvm_agent;

  //---------------------------------------
  // component instances
  //---------------------------------------
  CNC_driver    driver;
  CNC_sequencer sequencer;
  CNC_monitor   monitor;

  `uvm_component_utils(CNC_agent)
  
  //---------------------------------------
  // constructor
  //---------------------------------------
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //---------------------------------------
  // build_phase
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    monitor = CNC_monitor::type_id::create("monitor", this);

    //creating driver and sequencer only for ACTIVE agent
    if(get_is_active() == UVM_ACTIVE) begin
      driver    = CNC_driver::type_id::create("driver", this);
      sequencer = CNC_sequencer::type_id::create("sequencer", this);
    end
  endfunction : build_phase
  
  //---------------------------------------  
  // connect_phase - connecting the driver and sequencer port
  //---------------------------------------
  function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

endclass : CNC_agent