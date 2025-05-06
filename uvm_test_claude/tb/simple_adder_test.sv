`ifndef SIMPLE_ADDER_TEST_SV
`define SIMPLE_ADDER_TEST_SV

`include "simple_adder_base_test.sv"
`include "simple_adder_random_seq.sv"
`include "simple_adder_directed_seq.sv"

import uvm_pkg::*;
`include "uvm_macros.svh"
// We still need the package for the seq_item type used in sequences
import simple_adder_pkg::*; 

class simple_adder_test extends simple_adder_base_test;
  `uvm_component_utils(simple_adder_test)
  
  function new(string name = "simple_adder_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    simple_adder_random_seq random_seq;
    simple_adder_directed_seq directed_seq;
    
    phase.raise_objection(this);
    
    `uvm_info(get_type_name(), "Starting random sequence", UVM_LOW)
    random_seq = simple_adder_pkg::simple_adder_random_seq::type_id::create("random_seq");
    // Ensure the sequence runs on the correct sequencer
    if (!random_seq.randomize()) `uvm_fatal("SEQ_RAND_FAIL", "Failed to randomize random_seq")
    random_seq.start(env.agent.sequencer); 
    
    #50;
    
    `uvm_info(get_type_name(), "Starting directed sequence", UVM_LOW)
    directed_seq = simple_adder_pkg::simple_adder_directed_seq::type_id::create("directed_seq");
    // Ensure the sequence runs on the correct sequencer
    if (!directed_seq.randomize()) `uvm_fatal("SEQ_RAND_FAIL", "Failed to randomize directed_seq") // Although not random, randomize() is still needed for construction
    directed_seq.start(env.agent.sequencer);
    
    #50;
    
    phase.drop_objection(this);
  endtask
endclass

`endif // SIMPLE_ADDER_TEST_SV
