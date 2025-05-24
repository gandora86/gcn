`timescale 1ps/100fs
module GCN
  #(parameter FEATURE_COLS = 96,
    parameter WEIGHT_ROWS = 96,
    parameter FEATURE_ROWS = 6,
    parameter WEIGHT_COLS = 3,
    parameter FEATURE_WIDTH = $clog2(FEATURE_ROWS),
    parameter WEIGHT_WIDTH = 5,
    parameter DOT_PROD_WIDTH = 16,
    parameter ADDRESS_WIDTH = 13,
    parameter COUNTER_WEIGHT_WIDTH = $clog2(WEIGHT_COLS),
    parameter COUNTER_FEATURE_WIDTH = $clog2(FEATURE_ROWS),
    parameter MAX_ADDRESS_WIDTH = 2,
    parameter NUM_OF_NODES = 6,			 
    parameter COO_NUM_OF_COLS = 6,			
    parameter COO_NUM_OF_ROWS = 2,			
    parameter COO_BW = $clog2(COO_NUM_OF_COLS),
    parameter FM_WM_ROWS = 6,
    parameter FM_WM_WIDTH = $clog2(FM_WM_ROWS)
)
(
  input logic clk,	// Clock
  input logic reset,	// Reset 
  input logic start,
  input logic [WEIGHT_WIDTH-1:0] data_in [0:WEIGHT_ROWS-1], //FM and WM Data
  input logic [COO_BW - 1:0] coo_in [0:1], //row 0 and row 1 of the COO Stream

  output logic [COO_BW - 1:0] coo_address, // The column of the COO Matrix 
  output logic [ADDRESS_WIDTH-1:0] read_address, // The Address to read the FM and WM Data
  output logic enable_read, // Enabling the Read of the FM and WM Data
  output logic done, // Done signal indicating that all the calculations have been completed
  output logic [MAX_ADDRESS_WIDTH - 1:0] max_addi_answer [0:FEATURE_ROWS - 1] // The answer to the argmax and matrix multiplication 
); 

  logic done_trans, done_comb;
  logic [DOT_PROD_WIDTH - 1:0] FM_WM_Row  [0:WEIGHT_COLS-1];
  logic [FEATURE_WIDTH - 1:0] read_fm_wm_row;
  logic [DOT_PROD_WIDTH - 1:0] fm_wm_adj_out [0:WEIGHT_COLS-1];
  logic [FM_WM_WIDTH -1:0] fm_wm_adj_row;

  Transformation Transformation_int (
        .clk(clk),
        .reset(reset),
        .start(start),
        .data_in(data_in),
        .read_row(read_fm_wm_row),

        .enable_read(enable_read),
        .done_trans(done_trans),
        .read_address(read_address),
        .FM_WM_Row(FM_WM_Row)
  );

  Combination Combination_inst (
        .clk(clk),
        .reset(reset),
        .start(done_trans),
        .coo_in(coo_in),
        .FM_WM_Row(FM_WM_Row),
        .fm_wm_adj_row(fm_wm_adj_row),

        .coo_address(coo_address),
        .read_fm_wm_row(read_fm_wm_row),
        .fm_wm_adj_out(fm_wm_adj_out),
        .done_comb(done_comb)
  );

  Argmax Argmax_inst (
        .clk(clk),
        .reset(reset),
        .start(done_comb),
        .fm_wm_adj_out(fm_wm_adj_out),

        .fm_wm_adj_row(fm_wm_adj_row),
        .done(done),
        .max_addi_answer(max_addi_answer)
  );

endmodule
