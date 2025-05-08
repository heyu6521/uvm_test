`ifndef SIMPLE_ADDER_LIBRARY_TEST_SV
`define SIMPLE_ADDER_LIBRARY_TEST_SV

// 基于测试库的测试
class simple_adder_library_test extends simple_adder_base_test;
  `uvm_component_utils(simple_adder_library_test)
  
  string test_name = "a_b_values_test"; // 默认测试名
  
  function new(string name = "simple_adder_library_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // 尝试从配置数据库中获取测试名称
    void'(uvm_config_db#(string)::get(this, "", "test_name", test_name));
    `uvm_info(get_type_name(), $sformatf("Will run test: %s", test_name), UVM_LOW)
  endfunction
  
  task run_phase(uvm_phase phase);
    uvm_object_wrapper test_type;
    uvm_sequence base_seq;
    
    phase.raise_objection(this);
    
    // 列出所有可用的测试
    test_library::list_tests();
    
    // 获取测试类型
    test_type = test_library::get_test(test_name);
    
    if (test_type != null) begin
      `uvm_info(get_type_name(), $sformatf("Starting test: %s", test_name), UVM_LOW)
      
      // 创建并启动测试序列
      base_seq = uvm_sequence#(simple_adder_seq_item)::type_id::create(test_name);
      base_seq.set_type_override(test_type);
      base_seq.start(env.agent.sequencer);
      
      // 等待一段时间，确保所有操作完成
      #100;
      
      `uvm_info(get_type_name(), $sformatf("Test %s completed", test_name), UVM_LOW)
    end
    else begin
      `uvm_error(get_type_name(), $sformatf("Test %s not found in library", test_name))
    end
    
    phase.drop_objection(this);
  endtask
endclass

`endif // SIMPLE_ADDER_LIBRARY_TEST_SV