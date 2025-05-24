`timescale 1ps/100fs
module Combination_FSM 
  #(parameter COO_COLS = 6,
    parameter FM_WM_COLS = 3,
    parameter COO_ROWS = 2,     // Check
    parameter COUNTER_FM_WM_WIDTH = $clog2(FM_WM_COLS),
    parameter COUNTER_COO_WIDTH = $clog2(COO_COLS))
(
  input logic clk,
  input logic reset,
  input logic [COUNTER_COO_WIDTH-1:0] coo_count,
  input logic start,


  output logic enable_write_om_prod,
  output logic reverse_coo,
  output logic enable_coo_counter,
  output logic done
);

  typedef enum logic [2:0] {
	START,
	READ_COO_DATA,
	REVERSE_COO_DATA,
	INCREMENT_COO_COUNTER,
	DONE
  } state_t;

  state_t current_state, next_state;

  always_ff @(posedge clk or posedge reset)
    if (reset)
      current_state <= START;
    else
      current_state <= next_state;

  always_comb begin
    case (current_state)

      START: begin
		enable_write_om_prod = 1'b0;
		enable_coo_counter = 1'b0;
		reverse_coo = 1'b0; 
		done = 1'b0;

		if (start) begin
			next_state = READ_COO_DATA;
		end 
		else begin 
			next_state = START;
		end 
        	
      end

	  READ_COO_DATA: begin
		enable_write_om_prod = 1'b0;
		enable_coo_counter = 1'b0;
		reverse_coo = 1'b0; 
		done = 1'b0;
		next_state = REVERSE_COO_DATA;
	  end

	  REVERSE_COO_DATA: begin
		enable_write_om_prod = 1'b1;
		enable_coo_counter = 1'b0;
		reverse_coo = 1'b1; 
		done = 1'b0;
		next_state = INCREMENT_COO_COUNTER;
	  end


      INCREMENT_COO_COUNTER: begin
		enable_write_om_prod = 1'b1;
        enable_coo_counter = 1'b1;
		reverse_coo = 1'b0; 
		done = 1'b0;

		if (coo_count == COO_COLS - 1) begin
			next_state = DONE;
		end 
		else begin
			next_state = READ_COO_DATA;
		end
      end

      DONE: begin
		enable_write_om_prod = 1'b0;
		enable_coo_counter = 1'b0;
		reverse_coo = 1'b0; 
		done = 1'b1;

		next_state = DONE;
      end

    endcase
  end

endmodule
