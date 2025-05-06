`ifndef SIMPLE_ADDER_AGENT_SV
`define SIMPLE_ADDER_AGENT_SV

`include "simple_adder_driver.sv"
`include "simple_adder_monitor.sv"
`include "simple_adder_sequencer.sv"
`include "simple_adder_pkg.sv"

import uvm_pkg::*;
import simple_adder_pkg::*;

// 代理
class simple_adder_agent extends uvm_agent;
  `uvm_component_utils(simple_adder_agent)

  simple_adder_driver driver;
  simple_adder_sequencer sequencer;
  simple_adder_monitor monitor;

  function new(string name = "simple_adder_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    monitor = simple_adder_monitor::type_id::create("monitor", this);
    
    if(get_is_active() == UVM_ACTIVE) begin
      driver = simple_adder_pkg::simple_adder_driver::type_id::create("driver", this);
      sequencer = simple_adder_pkg::simple_adder_sequencer::type_id::create("sequencer", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    if(get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction
endclass

`endif // SIMPLE_ADDER_AGENT_SV
