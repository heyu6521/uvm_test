`ifndef SIMPLE_ADDER_DIRECTED_SEQ_SV
`define SIMPLE_ADDER_DIRECTED_SEQ_SV

`include "simple_adder_base_seq.sv"

import uvm_pkg::*;
`include "uvm_macros.svh"

// 定向序列（用于边界测试）
class simple_adder_directed_seq extends simple_adder_base_seq;
  `uvm_object_utils(simple_adder_directed_seq)

  function new(string name = "simple_adder_directed_seq");
    super.new(name);
  endfunction

  virtual task body();
    super.body();
    
    `uvm_info(get_type_name(), "Starting directed sequence", UVM_MEDIUM)
    
    // 边界测试用例
    req = simple_adder_seq_item::type_id::create("req");
    start_item(req);
    req.a = 8'hFF;
    req.b = 8'hFF;
    finish_item(req);
    
    req = simple_adder_seq_item::type_id::create("req");
    start_item(req);
    req.a = 8'h00;
    req.b = 8'h00;
    finish_item(req);
    
    req = simple_adder_seq_item::type_id::create("req");
    start_item(req);
    req.a = 8'h0F;
    req.b = 8'hF0;
    finish_item(req);
    
    `uvm_info(get_type_name(), "Directed sequence finished", UVM_MEDIUM)
  endtask
endclass

`endif // SIMPLE_ADDER_DIRECTED_SEQ_SV
