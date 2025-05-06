`ifndef SIMPLE_ADDER_ENV_SV
`define SIMPLE_ADDER_ENV_SV

`include "simple_adder_agent.sv"
`include "simple_adder_scoreboard.sv"
`include "simple_adder_pkg.sv"

import uvm_pkg::*;
import simple_adder_pkg::*;

// 环境
class simple_adder_env extends uvm_env;
  `uvm_component_utils(simple_adder_env)

  simple_adder_agent agent;
  simple_adder_scoreboard scoreboard;

  function new(string name = "simple_adder_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    agent = simple_adder_pkg::simple_adder_agent::type_id::create("agent", this);
    scoreboard = simple_adder_pkg::simple_adder_scoreboard::type_id::create("scoreboard", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    agent.monitor.item_collected_port.connect(scoreboard.item_collected_export);
  endfunction
endclass

`endif // SIMPLE_ADDER_ENV_SV
