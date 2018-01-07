`include "defines.v"

module ex_mem(

	input wire					  clk,
	input wire					  rst,
	
	//ctrl
	input wire[`CtrlBus]          stall,

	//����ִ�н׶ε���Ϣ	
	input wire[`RegAddrBus]       ex_wd,
	input wire                    ex_wreg,
	input wire[`RegBus]			  ex_wdata, 	
	input wire[`OpcodeBus]		  ex_opcode,
	input wire[`Func3Bus]		  ex_func3,
	input wire[`RegBus]		  ex_mem_addr,
	input wire[`RegBus]			  ex_reg2,
	//�͵��ô�׶ε���Ϣ
	output reg[`RegAddrBus]       mem_wd,
	output reg                    mem_wreg,
	output reg[`RegBus]			  mem_wdata,
	output reg[`OpcodeBus]		  mem_opcode,
	output reg[`Func3Bus]		  mem_func3,
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