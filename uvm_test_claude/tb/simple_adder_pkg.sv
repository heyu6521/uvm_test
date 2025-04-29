`ifndef SIMPLE_ADDER_PKG_SV
`define SIMPLE_ADDER_PKG_SV

package simple_adder_pkg;
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

  // 测序器
  class simple_adder_sequencer extends uvm_sequencer #(simple_adder_seq_item);
    `uvm_component_utils(simple_adder_sequencer)

    function new(string name = "simple_adder_sequencer", uvm_component parent = null);
      super.new(name, parent);
    endfunction
  endclass

  // 驱动器
  class simple_adder_driver extends uvm_driver #(simple_adder_seq_item);
    `uvm_component_utils(simple_adder_driver)

    virtual simple_adder_if vif;

    function new(string name = "simple_adder_driver", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(virtual simple_adder_if)::get(this, "", "vif", vif)) begin
        `uvm_fatal(get_type_name(), "Virtual interface not found")
      end
    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      
      forever begin
        seq_item_port.get_next_item(req);
        drive_stimulus();
        seq_item_port.item_done();
      end
    endtask

    task drive_stimulus();
      @(vif.driver_cb);
      vif.driver_cb.a <= req.a;
      vif.driver_cb.b <= req.b;
      `uvm_info(get_type_name(), $sformatf("Drove stimulus: a=%0h, b=%0h", req.a, req.b), UVM_HIGH)
    endtask
  endclass

  // 监视器
  class simple_adder_monitor extends uvm_monitor;
    `uvm_component_utils(simple_adder_monitor)

    virtual simple_adder_if vif;
    uvm_analysis_port #(simple_adder_seq_item) item_collected_port;
    simple_adder_seq_item collect_item;

    function new(string name = "simple_adder_monitor", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(virtual simple_adder_if)::get(this, "", "vif", vif)) begin
        `uvm_fatal(get_type_name(), "Virtual interface not found")
      end
      item_collected_port = new("item_collected_port", this);
      collect_item = simple_adder_seq_item::type_id::create("collect_item");
    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      
      forever begin
        @(vif.monitor_cb);
        collect_item.a = vif.monitor_cb.a;
        collect_item.b = vif.monitor_cb.b;
        collect_item.sum = vif.monitor_cb.sum;
        item_collected_port.write(collect_item);
        `uvm_info(get_type_name(), $sformatf("Collected: a=%0h, b=%0h, sum=%0h", 
                    collect_item.a, collect_item.b, collect_item.sum), UVM_HIGH)
      end
    endtask
  endclass

  // 评分板
  class simple_adder_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(simple_adder_scoreboard)

    uvm_analysis_imp #(simple_adder_seq_item, simple_adder_scoreboard) item_collected_export;
    int num_matches, num_mismatches;

    function new(string name = "simple_adder_scoreboard", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      item_collected_export = new("item_collected_export", this);
    endfunction

    function void write(simple_adder_seq_item item);
      bit [8:0] expected_sum;
      expected_sum = item.a + item.b;
      
      if(expected_sum == item.sum) begin
        `uvm_info(get_type_name(), $sformatf("MATCH! a=%0h, b=%0h, sum=%0h", 
                  item.a, item.b, item.sum), UVM_MEDIUM)
        num_matches++;
      end
      else begin
        `uvm_error(get_type_name(), $sformatf("MISMATCH! a=%0h, b=%0h, sum=%0h, expected=%0h", 
                   item.a, item.b, item.sum, expected_sum))
        num_mismatches++;
      end
    endfunction

    function void report_phase(uvm_phase phase);
      super.report_phase(phase);
      `uvm_info(get_type_name(), $sformatf("Matches: %0d, Mismatches: %0d", 
                num_matches, num_mismatches), UVM_LOW)
    endfunction
  endclass

  // 代理
  class simple_adder_agent extends uvm_agent;
    `uvm_component_utils(simple_adder_agent)

    simple_adder_driver driver;
    simple_adder_sequencer sequencer;
    simple_adder_monitor monitor;

    function new(string name = "simple_adder_agent", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      monitor = simple_adder_monitor::type_id::create("monitor", this);
      
      if(get_is_active() == UVM_ACTIVE) begin
        driver = simple_adder_driver::type_id::create("driver", this);
        sequencer = simple_adder_sequencer::type_id::create("sequencer", this);
      end
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      
      if(get_is_active() == UVM_ACTIVE) begin
        driver.seq_item_port.connect(sequencer.seq_item_export);
      end
    endfunction
  endclass

  // 环境
  class simple_adder_env extends uvm_env;
    `uvm_component_utils(simple_adder_env)

    simple_adder_agent agent;
    simple_adder_scoreboard scoreboard;

    function new(string name = "simple_adder_env", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      agent = simple_adder_agent::type_id::create("agent", this);
      scoreboard = simple_adder_scoreboard::type_id::create("scoreboard", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      
      agent.monitor.item_collected_port.connect(scoreboard.item_collected_export);
    endfunction
  endclass

  // 测试基类
  class simple_adder_base_test extends uvm_test;
    `uvm_component_utils(simple_adder_base_test)

    simple_adder_env env;
    
    function new(string name = "simple_adder_base_test", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      env = simple_adder_env::type_id::create("env", this);
    endfunction
    
    function void end_of_elaboration_phase(uvm_phase phase);
      super.end_of_elaboration_phase(phase);
      uvm_top.print_topology();
    endfunction
    
    function void report_phase(uvm_phase phase);
      uvm_report_server server;
      int err_num;
      
      super.report_phase(phase);
      
      server = uvm_report_server::get_server();
      err_num = server.get_severity_count(UVM_ERROR);
      
      if (err_num != 0) begin
        `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
        `uvm_info(get_type_name(), "----           TEST FAILED         ----", UVM_NONE)
        `uvm_info(get_type_name(), $sformatf("----      Errors: %4d        ----", err_num), UVM_NONE)
        `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
      end
      else begin
        `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
        `uvm_info(get_type_name(), "----           TEST PASSED         ----", UVM_NONE)
        `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
      end
    endfunction
  endclass

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

  // 定向测试
  class simple_adder_directed_test extends simple_adder_base_test;
    `uvm_component_utils(simple_adder_directed_test)
    
    function new(string name = "simple_adder_directed_test", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    
    task run_phase(uvm_phase phase);
      simple_adder_directed_seq directed_seq;
      
      phase.raise_objection(this);
      
      directed_seq = simple_adder_directed_seq::type_id::create("directed_seq");
      directed_seq.start(env.agent.sequencer);
      
      // 等待一段时间，让所有操作完成
      #100;
      
      phase.drop_objection(this);
    endtask
  endclass

endpackage
`endif // SIMPLE_ADDER_PKG_SV
