
class CNC_scoreboard extends uvm_scoreboard;
  
  //---------------------------------------
  // declaring pkt_qu to store the pkt's recived from monitor
  //---------------------------------------
  CNC_seq_item pkt_qu[$];

  //---------------------------------------
  // golden answer
  //---------------------------------------
  
  bit [16:0] golden_e, golden_f;
  //---------------------------------------
  //port to recive packets from monitor
  //---------------------------------------
  uvm_analysis_imp#(CNC_seq_item, CNC_scoreboard) item_collected_export;
  `uvm_component_utils(CNC_scoreboard)

  //---------------------------------------
  // new - constructor
  //---------------------------------------
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  //---------------------------------------
  // build_phase - create port and initialize local memory
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      item_collected_export = new("item_collected_export", this);
      golden_e = 17'd0;
      golden_f = 17'd0;
  endfunction: build_phase
  
  //---------------------------------------
  // write task - recives the pkt from monitor and pushes into queue
  //---------------------------------------
  virtual function void write(CNC_seq_item pkt);
    //pkt.print();
    pkt_qu.push_back(pkt);
  endfunction : write

  //---------------------------------------
  // run_phase - compare's the DUT answer with the golden answer
  //---------------------------------------
  virtual task run_phase(uvm_phase phase);
    CNC_seq_item CNC_pkt;
    
    forever begin
        wait(pkt_qu.size() > 0);
        CNC_pkt = pkt_qu.pop_front();
        
        case(CNC_pkt.mode)
        2'd0: begin golden_e=CNC_pkt.a+CNC_pkt.c; golden_f=CNC_pkt.b+CNC_pkt.d; end
        2'd1: begin golden_e=CNC_pkt.a-CNC_pkt.c; golden_f=CNC_pkt.b-CNC_pkt.d; end
        2'd2: begin golden_e=CNC_pkt.a*CNC_pkt.c-CNC_pkt.b*CNC_pkt.d; golden_f=CNC_pkt.a*CNC_pkt.d+CNC_pkt.b*CNC_pkt.c; end
        endcase   

        if (golden_e == CNC_pkt.e && golden_f == CNC_pkt.f ) begin
        `uvm_info(get_type_name(),$sformatf("-----------------:: PASS   ::-------------"),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("------------------------------------------"),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("Golden_e =  %0d, \t CNC_e = %0d", golden_e, CNC_pkt.e),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("Golden_f =  %0d, \t CNC_e = %0d", golden_f, CNC_pkt.f),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("-------------------------------------------"),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("-----------------:: PASS   ::--------------"),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("-------------------------------------------"),UVM_LOW)
          end
        else begin
        `uvm_info(get_type_name(),$sformatf("-----------------:: Fail   ::-------------"),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("-------------------QQQQQ------------------"),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("Golden_e =  %0d, \t CNC_e =  %0d", golden_e, CNC_pkt.e),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("Golden_f =  %0d, \t CNC_f =  %0d", golden_f, CNC_pkt.f),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("-------------------QQQQQ-------------------"),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("-----------------:: Fail   ::--------------"),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("-------------------------------------------"),UVM_LOW)
          end
    end
  endtask : run_phase
endclass : CNC_scoreboard