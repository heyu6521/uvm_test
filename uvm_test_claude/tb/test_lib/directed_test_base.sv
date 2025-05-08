`ifndef DIRECTED_TEST_BASE_SV
`define DIRECTED_TEST_BASE_SV

// 定向测试基类
class directed_test_base extends simple_adder_base_seq;
  `uvm_object_utils(directed_test_base)
  
  string test_name;
  
  function new(string name = "directed_test_base");
    super.new(name);
    test_name = name;
  endfunction
  
  // 默认的测试方法，子类需要重写
  virtual task body();
    super.body();
    `uvm_info(test_name, "Starting directed test", UVM_MEDIUM)
    
    // 子类将重写此方法以实现特定的测试
    
    `uvm_info(test_name, "Directed test completed", UVM_MEDIUM)
  endtask
endclass

`endif // DIRECTED_TEST_BASE_SV