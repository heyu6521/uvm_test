`ifndef SIMPLE_ADDER_SEQUENCER_SV
`define SIMPLE_ADDER_SEQUENCER_SV

// 测序器
class simple_adder_sequencer extends uvm_sequencer #(simple_adder_seq_item);
  `uvm_component_utils(simple_adder_sequencer)

  function new(string name = "simple_adder_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction
endclass

`endif // SIMPLE_ADDER_SEQUENCER_SV