`ifndef SIMPLE_ADDER_PKG_SV
`define SIMPLE_ADDER_PKG_SV

package simple_adder_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Include the sequence item definition
  `include "simple_adder_seq_item.sv"

  // The package now primarily serves to define the scope for imports
  // and potentially shared type definitions or utility functions (none in this case).
  // All component and sequence classes have been moved to separate files.

endpackage
`endif // SIMPLE_ADDER_PKG_SV
