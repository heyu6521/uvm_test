`ifndef SIMPLE_ADDER_BASE_SEQ_SV
`define SIMPLE_ADDER_BASE_SEQ_SV

`include "simple_adder_seq_item.sv"

import uvm_pkg::*;
`include "uvm_macros.svh"

// 序列基类
class simple_adder_base_seq extends uvm_sequence #(simple_adder_seq_item);
  `uvm_object_utils(simple_adder_base_seq)

  function new(string name = "simple_adder_base_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "Starting sequence", UVM_MEDIUM)
  endtask
endclass

`endif // SIMPLE_ADDER_BASE_SEQ_SV
