`ifndef SIMPLE_ADDER_RANDOM_TEST_SV
`define SIMPLE_ADDER_RANDOM_TEST_SV

// 随机测试
class simple_adder_random_test extends simple_adder_base_test;
  `uvm_component_utils(simple_adder_random_test)
  
  function new(string name = "simple_adder_random_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    simple_adder_random_seq random_seq;
    
    phase.raise_objection(this);
    
    random_seq = simple_adder_random_seq::type_id::create("random_seq");
    random_seq.start(env.agent.sequencer);
    
    // 等待一段时间，让所有操作完成
    #100;
    
    phase.drop_objection(this);
  endtask
endclass

`endif // SIMPLE_ADDER_RANDOM_TEST_SV