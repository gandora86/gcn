`timescale 1ps/100fs
module Transformation_Multiplication #( 
    parameter DATA_WIDTH = 96,
    parameter WIDTH_IN = 5,
    parameter WIDTH_OUT = 16
) (
    input logic [WIDTH_IN -1:0] in1 [DATA_WIDTH -1:0],
    input logic [WIDTH_IN -1:0] in2 [DATA_WIDTH -1:0],
    
    output logic [WIDTH_OUT -1:0] prod
);
    
    logic [WIDTH_OUT -1:0] prod_temp [DATA_WIDTH :0];
    assign prod = prod_temp[DATA_WIDTH];
    integer i;

    always_comb begin
        prod_temp[0] = 'd0;
        for (i = 0; i < DATA_WIDTH; i = i  +1) begin
            prod_temp[i+1] = in1[i] * in2[i] + prod_temp[i];
        end
    end
        
    

endmodule
