`include "defines.v"

module id_ex(

	input wire					  clk,
	input wire					  rst,

	
	//从译码阶段传递的信息
	input wire[`OpcodeBus]    	  id_opcode,
	input wire[`Func3Bus]         id_func3,
	input wire[`Func7Bus]         id_func7,
	input wire[`RegBus]           id_reg1,
	input wire[`RegBus]           id_reg2,
	input wire[`RegAddrBus]       id_wd,
	input wire                    id_wreg,	
	
	//传递到执行阶段的信息
	output reg[`OpcodeBus]    	  ex_opcode,
	output reg[`Func3Bus]         ex_func3,
	output reg[`Func7Bus]         ex_func7,
	output reg[`RegBus]           ex_reg1,
	output reg[`RegBus]           ex_reg2,
	output reg[`RegAddrBus]       ex_wd,
	output reg                    ex_wreg,
	
);

	always @ (posedge clk) begin
		if (rst == `RstEnable) begin
			ex_opcode <= `EXE_OP_NOP;
			ex_func3 <= `EXE_FUNC3_NOP;
			ex_func7 <= `EXE_FUNC7_NOP;
			ex_reg1 <= `ZeroWord;
			ex_reg2 <= `ZeroWord;
			ex_wd <= `NOPRegAddr;
			ex_wreg <= `WriteDisable;
		end else begin		
			ex_opcode <= id_opcode;
			ex_func3 <= id_func3;
			ex_func7 <= id_func7;
			ex_reg1 <= id_reg1;
			ex_reg2 <= id_reg2;
			ex_wd <= id_wd;
			ex_wreg <= id_wreg;
		end
	end
	
endmodule