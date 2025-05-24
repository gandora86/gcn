`timescale 1ps/100fs
module Counter #(
    parameter MAX_COUNT = 6,
    parameter COUNT_WIDTH  = $clog2(MAX_COUNT)
) (
    input logic clk,
    input logic reset,
    input logic enable,

    output logic [COUNT_WIDTH -1:0] count
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 'b0;
        end else begin
            if (enable) begin
                if (count == MAX_COUNT) begin
                    count <= 'b0;
                end else begin
                    count <= count +1;
                end
            end else begin
                count <= count;
            end
        end
    end
    
endmodule
