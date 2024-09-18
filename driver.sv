
`define DRIV_IF vif.DRIVER.driver_cb

class CNC_driver extends uvm_driver #(CNC_seq_item);

  //--------------------------------------- 
  // Virtual Interface
  //--------------------------------------- 
  virtual CNC_if vif;
  `uvm_component_utils(CNC_driver)
    
  //--------------------------------------- 
  // Constructor
  //--------------------------------------- 
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //--------------------------------------- 
  // build phase
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     if(!uvm_config_db#(virtual CNC_if)::get(this, "", "vif", vif))
       `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase

  //---------------------------------------  
  // run phase
  //---------------------------------------  
  virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
      `uvm_info(get_type_name(),$sformatf("req.a: %0d",req.a),UVM_LOW)
      `uvm_info(get_type_name(),$sformatf("req.mode: %0d",req.mode),UVM_LOW)
      $display("\t req.a = %0d\t",req.a);
    end
  endtask : run_phase
  
 
  // drives the value's from seq_item to interface signals
  //---------------------------------------
  virtual task drive();

      `DRIV_IF.in_en <= 0;
      repeat (req.t)@ (negedge vif.DRIVER.clk); //req.t
      `DRIV_IF.in_en <= 1;
      `uvm_info(get_type_name(),$sformatf("drive_phase_req.mode: %0d",req.mode),UVM_LOW)
      `DRIV_IF.in_data <= req.a;
      `DRIV_IF.mode <= req.mode;
      @(negedge vif.DRIVER.clk);
      `DRIV_IF.in_data <= req.b;
      `DRIV_IF.mode <= 2'bXX;   
      @(negedge vif.DRIVER.clk);
      `DRIV_IF.in_data <= req.c;
      @(negedge vif.DRIVER.clk);
      `DRIV_IF.in_data <= req.d;
      @(negedge vif.DRIVER.clk);
      `DRIV_IF.in_data <= 8'bXXXXXXXX;
      wait (`DRIV_IF.out_en == 1)
      wait (`DRIV_IF.out_en == 0)
      `DRIV_IF.in_en <= 0;

  endtask : drive
endclass : CNC_driver