
class CNC_monitor extends uvm_monitor;

  //---------------------------------------
  // Virtual Interface
  //---------------------------------------
  virtual CNC_if vif;

  //---------------------------------------
  // analysis port, to send the transaction to scoreboard
  //---------------------------------------
  uvm_analysis_port #(CNC_seq_item) item_collected_port;
  
  // begin captured (by the collect_address_phase and data_phase methods).
  //---------------------------------------
  uvm_analysis_port #(CNC_seq_item) item_collected_port;
  CNC_seq_item trans_collected;
  `uvm_component_utils(CNC_monitor)
  //----constructor---------------------------------------
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected = new();
    item_collected_port = new("item_collected_port", this);
  endfunction : new

  // constructor
  //---------------------------------------
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected = new();
    item_collected_port = new("item_collected_port", this);
  endfunction : new

  //---------------------------------------
  // build_phase - getting the interface handle
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual CNC_if)::get(this, "", "vif", vif))
       `uvm_fatal("NOVIF",{"vif must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase
  

  // sample the values on interface signal ans assigns to transaction class fields
  //---------------------------------------
  virtual task run_phase(uvm_phase phase);
    forever begin
      wait (vif.monitor_cb.in_en == 1)
      @(posedge vif.MONITOR.clk);   
      trans_collected.mode <= vif.monitor_cb.mode;
      trans_collected.a <= vif.monitor_cb.in_data;
      @(posedge vif.MONITOR.clk);    
      trans_collected.b <= vif.monitor_cb.in_data;
      @(posedge vif.MONITOR.clk);   
      trans_collected.c <= vif.monitor_cb.in_data;
      @(posedge vif.MONITOR.clk); 
      trans_collected.d <= vif.monitor_cb.in_data;
      wait(vif.monitor_cb.out_en == 1)
      @(posedge vif.MONITOR.clk);
      trans_collected.e <= vif.monitor_cb.out_data;
      @(posedge vif.MONITOR.clk);
      `uvm_info(get_type_name(),$sformatf("2nd_monitor_out_data: %0d",vif.monitor_cb.out_data),UVM_LOW)
      trans_collected.f <= vif.monitor_cb.out_data;
      `uvm_info(get_type_name(),$sformatf("monitor_trans_collected.a: %0d",trans_collected.a),UVM_LOW)
      `uvm_info(get_type_name(),$sformatf("monitor_trans_collected.b: %0d",trans_collected.b),UVM_LOW)
      `uvm_info(get_type_name(),$sformatf("monitor_trans_collected.c: %0d",trans_collected.c),UVM_LOW)
      `uvm_info(get_type_name(),$sformatf("monitor_trans_collected.d: %0d",trans_collected.d),UVM_LOW)
      `uvm_info(get_type_name(),$sformatf("monitor_trans_collected.e: %0d",trans_collected.e),UVM_LOW)
      `uvm_info(get_type_name(),$sformatf("monitor_trans_collected.f: %0d",trans_collected.f),UVM_LOW)
	    item_collected_port.write(trans_collected);
      end 
  endtask : run_phase

endclass : CNC_monitor
