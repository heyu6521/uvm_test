`ifndef SIMPLE_ADDER_PKG_SV
`define SIMPLE_ADDER_PKG_SV

package simple_adder_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // 包含所有组件和事务定义
  `include "simple_adder_seq_item.sv"
  `include "simple_adder_driver.sv"
  `include "simple_adder_monitor.sv" 
  `include "simple_adder_sequencer.sv"
  `include "simple_adder_agent.sv"
  `include "simple_adder_scoreboard.sv"
  `include "simple_adder_env.sv"
  `include "simple_adder_base_test.sv"

endpackage
`endif // SIMPLE_ADDER_PKG_SV
