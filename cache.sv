//cache_tb.sv
module cache_tb;

  logic clk, rst, read_en, write_en;
  logic [7:0] address, write_data, read_data;
  logic hit;

  cache_controller dut (
    .clk(clk), .rst(rst), .read_en(read_en), .write_en(write_en),
    .address(address), .write_data(write_data), .read_data(read_data), .hit(hit)
  );

  always #5 clk = ~clk;

  task write(input [7:0] addr, input [7:0] data);
    @(posedge clk);
    address = addr; write_data = data;
    write_en = 1; read_en = 0;
    @(posedge clk);
    write_en = 0;
  endtask

  task read(input [7:0] addr);
    @(posedge clk);
    address = addr;
    write_en = 0; read_en = 1;
    @(posedge clk);
    read_en = 0;
  endtask

  initial begin
    $display("Cache Controller Simulation Start");
    clk = 0; rst = 1;
    #10 rst = 0;

    write(8'h10, 8'hAA);   // Write
    read(8'h10);           // Read – Hit
    read(8'h30);           // Miss (conflict in index)
    write(8'h30, 8'hBB);   // Write
    read(8'h30);           // Hit

    $finish;
  end

endmodule
