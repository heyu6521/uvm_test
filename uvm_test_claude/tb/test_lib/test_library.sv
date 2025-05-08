`ifndef TEST_LIBRARY_SV
`define TEST_LIBRARY_SV

// 确保序列已定义
`include "../sequences/simple_adder_sequences.sv"

// 测试库类，用于注册和管理定向测试序列
class test_library extends uvm_object;
  `uvm_object_utils(test_library)
  
  // 存储测试序列的关联数组
  static uvm_object_wrapper test_seq_array[string];
  
  function new(string name = "test_library");
    super.new(name);
  endfunction
  
  // 注册测试序列的静态方法
  static function void register_test(string test_name, uvm_object_wrapper test_seq);
    test_seq_array[test_name] = test_seq;
    `uvm_info("TEST_LIBRARY", $sformatf("Registered test: %s", test_name), UVM_LOW)
  endfunction
  
  // 获取测试序列的静态方法
  static function uvm_object_wrapper get_test(string test_name);
    if (test_seq_array.exists(test_name)) begin
      return test_seq_array[test_name];
    end else begin
      `uvm_error("TEST_LIBRARY", $sformatf("Test %s not found in library", test_name))
      return null;
    end
  endfunction
  
  // 列出所有可用测试的静态方法
  static function void list_tests();
    string test_names[$];
    test_names = test_seq_array.find_index() with (1);
    `uvm_info("TEST_LIBRARY", "Available tests:", UVM_LOW)
    foreach (test_names[i]) begin
      `uvm_info("TEST_LIBRARY", $sformatf(" - %s", test_names[i]), UVM_LOW)
    end
  endfunction
endclass

`endif // TEST_LIBRARY_SV