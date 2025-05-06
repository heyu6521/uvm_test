`ifndef SIMPLE_ADDER_BASE_TEST_SV
`define SIMPLE_ADDER_BASE_TEST_SV

`include "simple_adder_env.sv"
`include "simple_adder_pkg.sv" // Still need pkg for imports

import uvm_pkg::*;
`include "uvm_macros.svh"

// 测试基类
class simple_adder_base_test extends uvm_test;
  `uvm_component_utils(simple_adder_base_test)

  simple_adder_env env;
  
  function new(string name = "simple_adder_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    env = simple_adder_env::type_id::create("env", this);
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction
  
  function void report_phase(uvm_phase phase);
    uvm_report_server server;
    int err_num;
    
    super.report_phase(phase);
    
    server = uvm_report_server::get_server();
    err_num = server.get_severity_count(UVM_ERROR);
    
    if (err_num != 0) begin
      `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
      `uvm_info(get_type_name(), "----           TEST FAILED         ----", UVM_NONE)
      `uvm_info(get_type_name(), $sformatf("----      Errors: %4d        ----", err_num), UVM_NONE)
      `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    end
    else begin
      `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
      `uvm_info(get_type_name(), "----           TEST PASSED         ----", UVM_NONE)
      `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    end
  endfunction
endclass

`endif // SIMPLE_ADDER_BASE_TEST_SV
