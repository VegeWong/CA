`include "defines.v"

module ctrl(

	input wire					 rst,

	input wire                   branch_flag_i,
	input wire                   stallreq_from_id,
	input wire                   stallreq_from_ex,
	output reg[5:0]              stall       
	
);


	always @ (*) begin
		if(rst == `RstEnable) begin
			stall <= 6'b000000;
		end else if (stallreq_from_ex == `Stop) begin
			stall <= 6'b001111;
		end else if (stallreq_from_id == `Stop) begin
			stall <= 6'b000111;			
		end else if (branch_flag_i == `Branch) begin
			stall <= 6'b010000;
		end else begin
			stall <= 6'b000000;
		end    //if
	end      //always
			

endmodule