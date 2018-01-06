`include "defines.v"

module ex_mem(

	input wire					  clk,
	input wire					  rst,
	
	//ctrl
	input wire[`CtrlBus]          stall,

	//来自执行阶段的信息	
	input wire[`RegAddrBus]       ex_wd,
	input wire                    ex_wreg,
	input wire[`RegBus]			  ex_wdata, 	
	input wire[`RegBus]			  ex_opcode,
	input wire[`RegBus]			  ex_func3,
	input wire[`RegBus]			  ex_mem_addr,
	input wire[`RegBus]			  ex_reg2,
	//送到访存阶段的信息
	output reg[`RegAddrBus]       mem_wd,
	output reg                    mem_wreg,
	output reg[`RegBus]			  mem_wdata,
	output reg[`RegBus]			  mem_opcode,
	output reg[`RegBus]			  mem_func3,
	output reg[`RegBus]			  mem_mem_addr,
	output reg[`RegBus]			  mem_reg2
);


	always @ (posedge clk) begin
		if(rst == `RstEnable) begin
			mem_wd <= `NOPRegAddr;
			mem_wreg <= `WriteDisable;
		    mem_wdata <= `ZeroWord;
			mem_opcode <= `ZeroWord;
			mem_func3 <= `ZeroWord;
			mem_mem_addr <= `ZeroWord;
			mem_reg2 <= `ZeroWord;
		end else if (stall[3] == `Stop && stall[4] == `NoStop) begin
			mem_wd <= `NOPRegAddr;
			mem_wreg <= `WriteDisable;
		    mem_wdata <= `ZeroWord;
			mem_opcode <= `ZeroWord;
			mem_func3 <= `ZeroWord;
			mem_mem_addr <= `ZeroWord;
			mem_reg2 <= `ZeroWord;	
		end else if (stall[3] == `NoStop) begin
			mem_wd <= ex_wd;
			mem_wreg <= ex_wreg;
			mem_wdata <= ex_wdata;
			mem_opcode <= ex_opcode;
			mem_func3 <= ex_func3;
			mem_mem_addr <= ex_mem_addr;
			mem_reg2 <= ex_reg2;			
		end    //if
	end      //always
			

endmodule