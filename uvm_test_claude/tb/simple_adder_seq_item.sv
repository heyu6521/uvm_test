`ifndef SIMPLE_ADDER_SEQ_ITEM_SV
`define SIMPLE_ADDER_SEQ_ITEM_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

// 事务类
class simple_adder_seq_item extends uvm_sequence_item;
  rand bit [7:0] a;
  rand bit [7:0] b;
  bit [8:0] sum;

  `uvm_object_utils_begin(simple_adder_seq_item)
    `uvm_field_int(a, UVM_ALL_ON)
    `uvm_field_int(b, UVM_ALL_ON)
    `uvm_field_int(sum, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "simple_adder_seq_item");
    super.new(name);
  endfunction

  // 这里可以添加约束条件
  constraint c_valid_data {
    a inside {[0:255]};
    b inside {[0:255]};
  }
endclass

`endif // SIMPLE_ADDER_SEQ_ITEM_SV
