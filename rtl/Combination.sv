`timescale 1ps/100fs
module Combination #(
    parameter COO_COLS = 6,
    parameter FM_WM_ROWS = 6,
    parameter FM_WM_COLS = 3,
    parameter IN_DATA_WIDTH = 16,
    parameter COO_WIDTH = $clog2(COO_COLS),
    parameter ADDRESS_WIDTH = 13,
    parameter DOT_PROD_WIDTH = 16,
    parameter COO_BW = $clog2(COO_COLS),
    parameter COO_ROWS = 2,
    parameter FM_WM_WIDTH = $clog2(FM_WM_ROWS),
    parameter COUNTER_COO_WIDTH = $clog2(COO_COLS)
) (
    input logic clk,	// Clock
    input logic reset,	// Reset 
    input logic start,
    input logic [COO_BW - 1:0] coo_in [0:1], //row 0 and row 1 of the COO Stream
    input logic [DOT_PROD_WIDTH - 1:0] FM_WM_Row  [0:FM_WM_COLS-1],
    input logic [FM_WM_WIDTH -1:0] fm_wm_adj_row,

    output logic [COO_BW - 1:0] coo_address, // The column of the COO Matrix
    output logic [FM_WM_WIDTH - 1:0] read_fm_wm_row,
    output logic [DOT_PROD_WIDTH - 1:0] fm_wm_adj_out [0:FM_WM_COLS-1],
    output logic done_comb
);
    logic enable_write_om_prod;
    logic enable_coo_counter;
    logic reverse_coo;
    logic [IN_DATA_WIDTH-1:0] fm_wm_col_out [0:FM_WM_ROWS-1];
    logic [IN_DATA_WIDTH -1:0] fm_wm_adj_row_in [0:FM_WM_COLS-1];
    logic [FM_WM_WIDTH -1:0] read_row, write_row;

    always_comb begin
        if (done_comb) begin
            read_row = fm_wm_adj_row;
            write_row = 'b0;
            read_fm_wm_row = 'b0;
        end else if (reverse_coo) begin
            read_fm_wm_row = coo_in [0] -1;
            write_row = coo_in [1] -1;
            read_row = coo_in [1] -1;
        end else begin
            read_fm_wm_row = coo_in [1] -1;
            write_row = coo_in [0] -1;
            read_row = coo_in [0] -1;
        end
    end

    Combination_FSM  Combination_FSM_inst (
        .clk(clk),
        .reset(reset),
        .coo_count(coo_address),
        .start(start),

        .reverse_coo(reverse_coo),
        .enable_write_om_prod(enable_write_om_prod),
        .enable_coo_counter(enable_coo_counter),
        .done(done_comb)
    );

    Combination_Multiplication comb_mul (
        .in1(FM_WM_Row),
        .in2(fm_wm_adj_out),
    
        .prod(fm_wm_adj_row_in)
    );

    Counter #(.MAX_COUNT(COO_COLS), .COUNT_WIDTH(COUNTER_COO_WIDTH)) counter_coo (
        .clk(clk),
        .reset(reset),
        .enable(enable_coo_counter),
        .count(coo_address)
    );

    Matrix_FM_WM_ADJ_Memory Matrix_FM_WM_ADJ_Memory_inst (
        .clk(clk),
        .rst(reset),
        .write_row(write_row),
        .read_row(read_row),
        .wr_en(enable_write_om_prod),
        .fm_wm_adj_row_in(fm_wm_adj_row_in),

        .fm_wm_adj_out(fm_wm_adj_out)
    );

    
endmodule

module Combination_Multiplication #( 
    parameter DATA_WIDTH = 3,
    parameter WIDTH_IN = 16,
    parameter WIDTH_OUT = 16
) (
    input logic [WIDTH_IN -1:0] in1 [DATA_WIDTH -1:0],
    input logic [WIDTH_IN -1:0] in2 [DATA_WIDTH -1:0],
    
    output logic [WIDTH_OUT -1:0] prod [DATA_WIDTH -1:0]
);

    always_comb begin
        prod[0] = in1[0] + in2[0];
        prod[1] = in1[1] + in2[1];
        prod[2] = in1[2] + in2[2];
    end

endmodule
