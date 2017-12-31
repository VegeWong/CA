`include "defines.v"

module id(

	input wire					  rst,
	input wire[`InstAddrBus]	  pc_i,
	input wire[`InstBus]          inst_i,

	input wire[`RegBus]           reg1_data_i,
	input wire[`RegBus]           reg2_data_i,

	//送到regfile的信息
	output reg                    reg1_read_o,
	output reg                    reg2_read_o,     
	output reg[`RegAddrBus]       reg1_addr_o,
	output reg[`RegAddrBus]       reg2_addr_o, 	      
	
	//送到执行阶段的信息
	output reg[`OpcodeBus]        opcode_o,
	output reg[`Func3Bus]         func3_o,
	output reg[`Func7Bus]         func7_o,
	output reg[`RegBus]           reg1_o,
	output reg[`RegBus]           reg2_o,
	output reg[`RegAddrBus]       wd_o,
	output reg                    wreg_o
	
	//送到pc_reg
	output reg                    pc_sig,
	output reg[`InstAddrBus]      pc_o,
);
  wire[6:0] op  = inst_i[6:0];
  wire[2:0] op2 = inst_i[14:12];
  wire[6:0] op3 = inst_i[31:25];

  reg[`RegBus]	imm;
  reg instvalid;
  
 
	always @ (*) begin
		//regfile
		reg1_read_o <= 1'b0;
		reg2_read_o <= 1'b0;
		reg1_addr_o <= `NOPRegAddr;
		reg2_addr_o <= `NOPRegAddr;	
		//exec
		instvalid <= `InstInvalid;
		opcode_o <= `EXE_OP_NOP;
		func7_o <= `EXE_FUNC7_NOP;
		func3_o <= `EXE_FUNC3_NOP;
		wd_o <= `NOPRegAddr;
		wreg_o <= `WriteDisable;
		imm <= `ZeroWord;
		//pc_reg
		pc_o <= `ZeroWord;
		pc_sig <= 1'b0;
		//begin decoding		
		if (rst != `RstEnable) begin
			instvalid <= `InstValid;
			opcode_o <= op;
		  	case (op)
		  		`OP_LUI: begin                       
					wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
					imm <= {inst_i[31:12], 12'b0};
		  		end
				`OP_AUIPC: begin
					wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
					imm <= {inst_i[31:12], 12'b0} + pc_i - 4;		
				end
				`OP_JAL: begin                       
					wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
					imm <= pc_i - 4;

					pc_o <= {11{inst_i[31]}, inst_i[19:12],
							inst_i[20], inst_i[30:21], 1'b0} + pc_i - 4;
					pc_sig <= 1'b1;
		  		end
				`OP_JALR: begin
					wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
					imm <= pc_i - 4;

					pc_o <= ({20{inst_i[31]}, inst_i[30:20]} + reg1_data_i);
					pc_sig <= 1'b1;
					
					func3_o <= `FUNCT3_JALR;
					reg1_read_o <= 1'b1;
				end
				`OP_BRANCH: begin
					pc_i <= {20{inst_i[31]}, inst_i[7],
							inst_i[30:25], inst_i[11:8], 1'b0} + pc_i - 4;
					pc_sig <= 1'b1;

					func3_o <= op2; 
					reg1_read_o <= 1'b1; reg2_read_o <= 1'b1;
		  		end
				`OP_LOAD: begin
					wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
					imm <= {20{inst_i[31]}, inst_i[30:20]};

					func3_o <= op2;
					reg1_read_o <= 1'b1; 
				end
				`OP_STORE: begin
					imm <= {20{inst_i[31]}, inst_i[31:25], inst_i[11:7]};
					
					func3_o <= op2;
					reg1_read_o <= 1'b1; reg2_read_o <= 1'b1;                     
		  		end
				`OP_OP_IMM: begin
					wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
					imm <= {21{inst_i[31]}, inst_i[30:20]};

					func3_o <= op2;
					reg1_read_o <= 1'b1;
					case (op2)
						`FUNCT3_SRLI_SRAI: begin
							func7_o <= op3;
						end
						default: begin
						end
					endcase
				end
				`OP_OP: begin
					wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];

					func3_o <= op2; func7_o <= op3;
					reg1_read_o <= 1'b1; reg2_read_o <= 1'b1;
		  		end
				`OP_MISC_MEM: begin
					func3_o <= op2;
				end
		    	default: begin
		    	end
		  endcase		  //case op			
		end       //if
	end         //always
	

	always @ (*) begin
		if(rst == `RstEnable) begin
			reg1_o <= `ZeroWord;
	  	end else if(reg1_read_o == 1'b1) begin
	  		reg1_o <= reg1_data_i;
	  	end else if(reg1_read_o == 1'b0) begin
	  		reg1_o <= imm;
	  	end else begin
	    	reg1_o <= `ZeroWord;
	  	end
	end
	
	always @ (*) begin
		if(rst == `RstEnable) begin
			reg2_o <= `ZeroWord;
	  	end else if(reg2_read_o == 1'b1) begin
	  		reg2_o <= reg2_data_i;
	  	end else if(reg2_read_o == 1'b0) begin
	  		reg2_o <= imm;
		end else begin
			reg2_o <= `ZeroWord;
		end
	end

endmodule