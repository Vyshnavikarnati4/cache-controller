// cache_controller.v
module cache_controller (
    input logic clk,
    input logic rst,
    input logic read_en,
    input logic write_en,
    input logic [7:0] address,
    input logic [7:0] write_data,
    output logic [7:0] read_data,
    output logic hit
);

  logic [7:0] data_array [3:0];
  logic [5:0] tag_array [3:0];
  logic       valid_array[3:0];

  logic [1:0] index;
  logic [5:0] tag;

  assign index = address[3:2];
  assign tag   = address[7:2];

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      for (int i = 0; i < 4; i++) begin
        valid_array[i] <= 0;
        tag_array[i] <= 0;
        data_array[i] <= 0;
      end
    end else begin
      if (read_en) begin
        if (valid_array[index] && tag_array[index] == tag) begin
          hit <= 1;
          read_data <= data_array[index];
        end else begin
          hit <= 0;
          read_data <= 8'b0;
        end
      end
      if (write_en) begin
        data_array[index] <= write_data;
        tag_array[index] <= tag;
        valid_array[index] <= 1;
        hit <= 0;
      end
    end
  end

endmodule
