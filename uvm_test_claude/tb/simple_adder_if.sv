`ifndef SIMPLE_ADDER_IF_SV
`define SIMPLE_ADDER_IF_SV

interface simple_adder_if(input logic clk, input logic rst_n);
  logic [7:0] a;
  logic [7:0] b;
  logic [8:0] sum;

  // 用于监视引脚的钳位
  clocking monitor_cb @(posedge clk);
    input a, b, sum;
  endclocking

  // 用于驱动引脚的钳位
  clocking driver_cb @(posedge clk);
    output a, b;
    input sum;
  endclocking

  // 用于序列的调制
  modport MONITOR (clocking monitor_cb);
  modport DRIVER (clocking driver_cb);
endinterface

`endif // SIMPLE_ADDER_IF_SV
