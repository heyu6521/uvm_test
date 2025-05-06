`ifndef SIMPLE_ADDER_RANDOM_SEQ_SV
`define SIMPLE_ADDER_RANDOM_SEQ_SV

`include "simple_adder_base_seq.sv"

import uvm_pkg::*;
`include "uvm_macros.svh"

// 随机序列
class simple_adder_random_seq extends simple_adder_base_seq;
  `uvm_object_utils(simple_adder_random_seq)

  function new(string name = "simple_adder_random_seq");
    super.new(name);
  endfunction

  virtual task body();
    super.body();
    
    `uvm_info(get_type_name(), "Starting random sequence", UVM_MEDIUM)
    
    repeat(10) begin
      req = simple_adder_seq_item::type_id::create("req");
      start_item(req);
      if(!req.randomize()) begin
        `uvm_error(get_type_name(), "Randomization failed")
      end
      finish_item(req);
    end
    
    `uvm_info(get_type_name(), "Random sequence finished", UVM_MEDIUM)
  endtask
endclass

`endif // SIMPLE_ADDER_RANDOM_SEQ_SV
