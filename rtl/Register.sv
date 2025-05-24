module Register #(parameter WIDTH = 64, parameter DEPTH = 1) (
    input logic clk, reset,
    input logic [WIDTH-1:0] in [DEPTH-1:0],
    
    output logic [WIDTH-1:0] out [DEPTH-1:0]
);
    always_ff @(posedge clk or posedge reset) begin
        if(reset) begin
            for (int i = 0; i < WIDTH; i = i + 1) begin
            for (int j = 0; j < DEPTH; j = j + 1) begin
                    out [j][i] <= '0;
            end 
            end
        end else begin
            out <= in;
        end
    end
    /* always @(*) begin
        out = in;
    end */
endmodule
