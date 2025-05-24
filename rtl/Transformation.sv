`timescale 1ps/100fs
module Transformation #(
    parameter FEATURE_ROWS = 6,
    parameter WEIGHT_COLS = 3,
    parameter WEIGHT_ROWS = 96,
    parameter IN_DATA_WIDTH = 5,
    parameter FEATURE_WIDTH = $clog2(FEATURE_ROWS),
    parameter ADDRESS_WIDTH = 13,
    parameter DOT_PROD_WIDTH = 16,
    parameter COUNTER_WEIGHT_WIDTH = $clog2(WEIGHT_COLS),
    parameter COUNTER_FEATURE_WIDTH = $clog2(FEATURE_ROWS)
) (
    input logic clk,
    input logic reset,
    input logic start,
    input logic [IN_DATA_WIDTH-1:0] data_in [0:WEIGHT_ROWS-1],
    input logic [FEATURE_WIDTH - 1:0] read_row,

    output logic enable_read,
    output logic done_trans,
    output logic [ADDRESS_WIDTH-1:0] read_address,
    output logic [DOT_PROD_WIDTH - 1:0] FM_WM_Row  [0:WEIGHT_COLS-1]
);
    
    logic enable_write_fm_wm_prod;
    logic enable_write;
    logic enable_scratch_pad;
    logic enable_weight_counter;
    logic enable_feature_counter;
    logic read_feature_or_weight;
    logic [COUNTER_WEIGHT_WIDTH-1:0] weight_count;
    logic [COUNTER_FEATURE_WIDTH-1:0] feature_count;
    logic [IN_DATA_WIDTH-1:0] weight_col_out [0:WEIGHT_ROWS-1];
    logic [DOT_PROD_WIDTH - 1:0] fm_wm_in;
    
    always_comb begin
        if(read_feature_or_weight && ~enable_feature_counter) begin
            read_address <= feature_count + 10'b10_0000_0000;
        end else if(~read_feature_or_weight && enable_scratch_pad) begin
            read_address <= weight_count;
        end else begin
            read_address <= read_address;
        end
    end

    Transformation_FSM Transformation_FSM_inst (
        .clk(clk),
        .reset(reset),
        .weight_count(weight_count),
        .feature_count(feature_count),
        .start(start),

        .enable_write_fm_wm_prod(enable_write_fm_wm_prod),
        .enable_read(enable_read),
        .enable_write(enable_write),
        .enable_scratch_pad(enable_scratch_pad),
        .enable_weight_counter(enable_weight_counter),
        .enable_feature_counter(enable_feature_counter),
        .read_feature_or_weight(read_feature_or_weight),
        .done(done_trans)
    );

    Scratch_Pad Scratch_Pad_inst (
        .clk(clk),
        .reset(reset),
        .write_enable(enable_scratch_pad),
        .weight_col_in(data_in),

        .weight_col_out(weight_col_out)
    );

    Matrix_FM_WM_Memory Matrix_FM_WM_Memory_inst (
        .clk(clk),
        .rst(reset),
        .write_row(feature_count),
        .write_col(weight_count),
        .read_row(read_row),
        .wr_en(enable_write_fm_wm_prod),
        .fm_wm_in(fm_wm_in),

        .fm_wm_row_out(FM_WM_Row)
    );

    Counter #(.MAX_COUNT(FEATURE_ROWS), .COUNT_WIDTH(COUNTER_FEATURE_WIDTH)) counter_feature (
        .clk(clk),
        .reset(reset),
        .enable(enable_feature_counter),
        .count(feature_count)
    );

    Counter #(.MAX_COUNT(WEIGHT_COLS), .COUNT_WIDTH(COUNTER_WEIGHT_WIDTH)) counter_weight (
        .clk(clk),
        .reset(reset),
        .enable(enable_weight_counter),
        .count(weight_count)
    );

    Transformation_Multiplication vector_mul (
        .in1(weight_col_out),
        .in2(data_in),
    
        .prod(fm_wm_in)
    );

endmodule
