module MatrixMultiplier (
  output reg [15:0] matrixResult[5:0][2:0] // Resulting 6x3 matrix
);

  integer i, j, k;
  reg [5:0] matrixA[5:0][95:0]; // 6x96 matrix A
  reg [5:0] matrixB[95:0][2:0]; // 96x3 matrix B

  // Read matrices A and B from text files
  initial begin
    $readmemb("/mnt/hgfs/GitHub/GCN/feature_data.txt", matrixA);
    $readmemb("/mnt/hgfs/GitHub/GCN/weight_data.txt", matrixB);

    // Matrix multiplication
    for (i = 0; i < 6; i = i + 1) begin
      for (k = 0; k < 3; k = k + 1) begin
        matrixResult[i][k] = 16'b0;
        for (j = 0; j < 96; j = j + 1) begin
          matrixResult[i][k] = matrixResult[i][k] + matrixA[i][j] * matrixB[j][k];
        end
      end
    end

    // Write the result matrix to a text file
    // $fwrite("resultMatrix.txt", matrixResult);
    $finish;
  end

endmodule
