`ifndef SIMPLE_ADDER_SEQUENCES_SV
`define SIMPLE_ADDER_SEQUENCES_SV

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

`endif // SIMPLE_ADDER_SEQUENCES_SV