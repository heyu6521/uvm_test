`ifndef A_B_VALUES_TEST_SV
`define A_B_VALUES_TEST_SV

// 确保基类已定义
`include "directed_test_base.sv"

// 特定的定向测试：a和b的值从1到10
class a_b_values_test extends directed_test_base;
  `uvm_object_utils(a_b_values_test)
  
  function new(string name = "a_b_values_test");
    super.new(name);
  endfunction
  
  virtual task body();
    super.body();
    
    `uvm_info(test_name, "Running test with a and b values from 1 to 10", UVM_MEDIUM)
    
    // 依次测试a和b值从1到10
    for (int a = 1; a <= 10; a++) begin
      for (int b = 1; b <= 10; b++) begin
        req = simple_adder_seq_item::type_id::create("req");
        start_item(req);
        req.a = a;
        req.b = b;
        finish_item(req);
        
        `uvm_info(test_name, $sformatf("Sent values: a=%0d, b=%0d", a, b), UVM_MEDIUM)
      end
    end
    
    `uvm_info(test_name, "Test with a and b values from 1 to 10 completed", UVM_MEDIUM)
  endtask
  
  // 静态初始化块，用于注册到测试库
  static function automatic void register();
    test_library::register_test("a_b_values_test", a_b_values_test::get_type());
    `uvm_info("a_b_values_test", "Registered to test library", UVM_LOW)
  endfunction
endclass

`endif // A_B_VALUES_TEST_SV