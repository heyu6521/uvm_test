`ifndef SIMPLE_ADDER_MONITOR_SV
`define SIMPLE_ADDER_MONITOR_SV

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

`endif // SIMPLE_ADDER_MONITOR_SV