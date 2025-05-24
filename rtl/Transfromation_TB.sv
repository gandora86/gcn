module Tranformation_TB ();
    
    parameter FEATURE_COLS = 96;
    parameter WEIGHT_ROWS = 96;
    parameter FEATURE_ROWS = 6;
    parameter WEIGHT_COLS = 3;
    parameter FEATURE_WIDTH = $clog2(FEATURE_ROWS);
    parameter IN_DATA_WIDTH = 5;
    parameter DOT_PROD_WIDTH = 16;
    parameter ADDRESS_WIDTH = 13;
    parameter COUNTER_WEIGHT_WIDTH = $clog2(WEIGHT_COLS);
    parameter COUNTER_FEATURE_WIDTH = $clog2(FEATURE_ROWS);
    parameter NUM_OF_NODES = 6;
    parameter COO_NUM_OF_COLS = 6;
    parameter COO_NUM_OF_ROWS = 2;
    parameter COO_BW = $clog2(COO_NUM_OF_COLS);
    parameter MAX_ADDRESS_WIDTH = 2;
    parameter HALF_CLOCK_CYCLE = 5;

    string feature_filename = "/mnt/hgfs/Shared/GCN/feature_data.txt"; // modify the path to the files to match your case
    string weight_filename = "/mnt/hgfs/Shared/GCN/weight_data.txt";

    logic read_enable;
    logic [DOT_PROD_WIDTH-1:0] wm_fm_dot_product [0:WEIGHT_COLS-1];
    logic [IN_DATA_WIDTH-1:0] input_data [0:WEIGHT_ROWS-1];
    logic [ADDRESS_WIDTH-1:0] read_addres_mem;
    logic [IN_DATA_WIDTH - 1:0] feature_matrix_mem [0:FEATURE_ROWS - 1][0:FEATURE_COLS - 1];
    logic [IN_DATA_WIDTH - 1:0] weight_matrix_mem [0:WEIGHT_COLS - 1][0:WEIGHT_ROWS - 1];
    logic [$clog2(FEATURE_ROWS) - 1:0] read_row;

    initial $readmemb(feature_filename, feature_matrix_mem);
    initial $readmemb(weight_filename, weight_matrix_mem);

    always @(read_addres_mem or read_enable) begin
        if (read_enable) begin
            if(read_addres_mem >= 10'b10_0000_0000) begin
                input_data = feature_matrix_mem[read_addres_mem - 10'b10_0000_0000];
            end 
            else begin
                input_data = weight_matrix_mem[read_addres_mem];
            end 
        end
    end 

	logic clk;		// Clock
	logic rst;		// Dut Reset
	logic start;		// Start Signal: This is asserted in the testbench
	logic done;		// All the Calculations are done

    // Clock Generator
        initial begin
            clk <= '0;
            forever #(HALF_CLOCK_CYCLE) clk <= ~clk;
        end

    initial begin 
		#100000;
		$display("Simulation Time Expired");

		$finish;
	end 

	initial begin
		start = 1'b0;
		rst = 1'b1;
		// Reset the DUT
		repeat(3) begin
			#HALF_CLOCK_CYCLE;
			rst = ~rst;
		end
                start = 1'b1;

		wait (done === 1'b1);
		#21;
		
		// $finish;
 	end

    Transformation uut (
        .clk(clk),
        .reset(rst),
        .start(start),
        .data_in(input_data),
        .read_row(3'b0),

        .enable_read(read_enable),
        .done_trans(done),
        .read_address(read_addres_mem),
        .FM_WM_Row(wm_fm_dot_product)
);


endmodule
