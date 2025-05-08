
`include "simple_adder_if.sv"
`include "simple_adder_pkg.sv"
`include "simple_adder_test.sv"

module top;
  import uvm_pkg::*;
  import simple_adder_pkg::*;

  // 定义时钟和复位信号
  bit clk;
  bit rst_n;

  // 生成时钟
  always #5 clk = ~clk;

  // 接口实例化
  simple_adder_if dut_if(clk, rst_n);

  // DUT实例化
  simple_adder dut(
    .clk(clk),
    .rst_n(rst_n),
    .a(dut_if.a),
    .b(dut_if.b),
    .sum(dut_if.sum)
  );
  // 波形转储
  initial begin
    // 创建fsdb文件
    $fsdbDumpfile("dump.fsdb");
    //$fsdbDumpvars(0, top);  // 转储顶层模块的所有信号
    // 可选：添加更细粒度的信号转储
    $fsdbDumpvars("+all");  // 转储所有信号
    // $fsdbDumpMDA();  // 转储多维数组
  end
  initial begin    
    // 将接口注册到UVM配置数据库
    uvm_config_db#(virtual simple_adder_if)::set(null, "*", "vif", dut_if);
    
    // 注册所有定向测试到测试库
    a_b_values_test::register();
    `uvm_info("TOP", "Registered a_b_values_test to test library", UVM_LOW)
    
    // 设置要运行的测试名称
    uvm_config_db#(string)::set(null, "*.simple_adder_library_test", "test_name", "a_b_values_test");
    
    // 启动UVM测试
    run_test("simple_adder_library_test");
  end
  initial begin
    // 复位生成
    rst_n = 0;
    #10;
    rst_n = 1;
  end
endmodule
