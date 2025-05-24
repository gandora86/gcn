`timescale 1ps/100fs
module Argmax #(
    parameter DOT_PROD_WIDTH = 16,
    parameter FM_WM_COLS = 3,
    parameter FM_WM_ROWS = 6,
    parameter MAX_ADDRESS_WIDTH = 2,
    parameter FEATURE_ROWS = 6,
    parameter FM_WM_WIDTH = $clog2(FM_WM_ROWS),
    parameter COUNT_WIDTH = $clog2(FEATURE_ROWS)
) (
    input logic clk,	// Clock
    input logic reset,	// Reset 
    input logic start,
    input logic [DOT_PROD_WIDTH - 1:0] fm_wm_adj_out [0:FM_WM_COLS-1],
    
    output logic [FM_WM_WIDTH -1:0] fm_wm_adj_row,
    output logic done,
    output logic [MAX_ADDRESS_WIDTH - 1:0] max_addi_answer [0:FEATURE_ROWS - 1]
);

    integer i;
    logic [DOT_PROD_WIDTH - 1:0] max_value;

    always_ff @( posedge clk or posedge reset ) begin
        if (reset) begin
            fm_wm_adj_row <= 'b0;
            done <= 0;
        end else begin
            if (start) begin
                if (fm_wm_adj_row == (FEATURE_ROWS -1)) begin
                    done <= 1;
                    fm_wm_adj_row <= fm_wm_adj_row;
                end else begin
                    done <= 0;
                    fm_wm_adj_row <= fm_wm_adj_row +1;
                end
            end
        end
    end
    
    always_comb begin
        max_addi_answer[fm_wm_adj_row] = 'b0;
        max_value = fm_wm_adj_out[0];
        for (i = 0; i < FM_WM_COLS; i = i +1) begin
            if(fm_wm_adj_out[i] > max_value) begin
                max_value = fm_wm_adj_out[i];
                max_addi_answer[fm_wm_adj_row] = i;
            end
        end
    end

    
endmodule
