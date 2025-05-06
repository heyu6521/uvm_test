`ifndef SIMPLE_ADDER_DRIVER_SV
`define SIMPLE_ADDER_DRIVER_SV

`include "simple_adder_if.sv"
`include "simple_adder_pkg.sv"

import uvm_pkg::*;
import simple_adder_pkg::*;

// 驱动器
class simple_adder_driver extends uvm_driver #(simple_adder_seq_item);
  `uvm_component_utils(simple_adder_driver)

  virtual simple_adder_if vif;

  function new(string name = "simple_adder_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual simple_adder_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal(get_type_name(), "Virtual interface not found")
    end
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    forever begin
      seq_item_port.get_next_item(req);
      drive_stimulus();
      seq_item_port.item_done();
    endtask
  endclass

  task drive_stimulus();
    @(vif.driver_cb);
    vif.driver_cb.a <= req.a;
    vif.driver_cb.b <= req.b;
    `uvm_info(get_type_name(), $sformatf("Drove stimulus: a=%0h, b=%0h", req.a, req.b), UVM_HIGH)
  endtask
endclass

`endif // SIMPLE_ADDER_DRIVER_SV
