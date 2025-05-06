`ifndef SIMPLE_ADDER_PKG_SV
`define SIMPLE_ADDER_PKG_SV

package simple_adder_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Include sequence item
  `include "seq_items/simple_adder_seq_item.sv"
  
  // Include sequences
  `include "sequences/simple_adder_sequences.sv"
  
  // Include agent components
  `include "agent/simple_adder_sequencer.sv"
  `include "agent/simple_adder_driver.sv"
  `include "agent/simple_adder_monitor.sv"
  `include "agent/simple_adder_agent.sv"
  
  // Include environment components
  `include "env/simple_adder_scoreboard.sv"
  `include "env/simple_adder_env.sv"
  
  // Include tests
  `include "tests/simple_adder_base_test.sv"
  `include "tests/simple_adder_random_test.sv"
  `include "tests/simple_adder_directed_test.sv"

endpackage
`endif // SIMPLE_ADDER_PKG_SV