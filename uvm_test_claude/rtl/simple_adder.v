// A simple adder module (Verilog-2001 compatible)
module simple_adder (
  input  clk,
  input  rst_n,
  input  [7:0] a,
  input  [7:0] b,
  output [8:0] sum
);

reg [8:0] sum; // Declare sum as reg for sequential logic

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    sum <= 9'b0;
  end else begin
    sum <= a + b;
  end
end

endmodule
