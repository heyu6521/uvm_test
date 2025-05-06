`ifndef SIMPLE_ADDER_SCOREBOARD_SV
`define SIMPLE_ADDER_SCOREBOARD_SV

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

`endif // SIMPLE_ADDER_SCOREBOARD_SV