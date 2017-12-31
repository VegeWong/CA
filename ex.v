`include "defines.v"

module ex(

	input wire					  rst,
	
	//送到执行阶段的信息
	input wire[`OpcodeBus]        opcode_i,
	input wire[`Func3Bus]         func3_i,
	input wire[`Func7Bus]         func7_i,
	input wire[`RegBus]           reg1_i,
	input wire[`RegBus]           reg2_i,
	input wire[`InstAddrBus]      pc_i,
	input wire[`RegAddrBus]       wd_i,
	input wire                    wreg_i,

	//送到Mem阶段信息
	output reg[`RegAddrBus]       wd_o,
	output reg                    wreg_o,
	output reg[`RegBus]			  wdata_o,

	output reg					  br_o; //branch result
	output reg				      

);

	reg[`RegBus] logicout;
	always @ (*) begin
		if(rst == `RstEnable) begin
			logicout <= `ZeroWord;
		end else begin
			case (opcode_i)
		  		`OP_LUI: begin                       
					logicout <= reg1_i;
		  		end
				`OP_AUIPC: begin
					logicout <= reg1_i;
				end
				`OP_JAL: begin                       
					logicout <= reg1_i;
		  		end
				`OP_JALR: begin
					logicout <= reg2_i;
				end
				`OP_BRANCH: begin
					case (func3_i)
						`FUNCT3_BEQ: begin
							br_o <= (reg1_i == reg2_i?) 1:0;
						end
						`FUNCT3_BNE: begin
							
						end
						`FUNCT3_BLT: begin
							
						end
						`FUNCT3_BGE: begin
							
						end
						`FUNCT3_BLTU: begin
							
						end
						`FUNCT3_BGEU: begin
							
						end
					endcase
		  		end
				`OP_LOAD: begin
					wreg_o <= `WriteEnable; instvalid = `InstValid;
					imm <= {20{inst_i[31]}, inst_i[30:20]};
					opcode_o <= `OP_LOAD; wd_o <= inst_i[11:7];
					reg1_read_o <= 1'b1; reg2_read_o <= 1'b0;  
					case (op2)
						`FUNCT3_LB: begin
							func3_o <= `FUNCT3_LB;
						end
						`FUNCT3_LH: begin
							func3_o <= `FUNCT3_LH;
						end
						`FUNCT3_LW: begin
							func3_o <= `FUNCT3_LW;
						end
						`FUNCT3_LBU: begin
							func3_o <= `FUNCT3_LBU;
						end
						`FUNCT3_LHU: begin
							func3_o <= `FUNCT3_LHU;
						end
					endcase
				end
				`OP_STORE: begin
					wreg_o <= `WriteDisable; instvalid = `InstValid;
					imm <= {20{inst_i[31]}, inst_i[31:25], inst_i[11:7]};
					opcode_o <= `OP_STORE; wd_o <= `NOPRegAddr;
					reg1_read_o <= 1'b1; reg2_read_o <= 1'b1;                       
					case (op2)
						`FUNCT3_SB: begin
							func3_o <= `FUNCT3_SB;
						end
						`FUNCT3_SH: begin
							func3_o <= `FUNCT3_SH;
						end
						`FUNCT3_SW: begin
							func3_o <= `FUNCT3_SW;
						end
					endcase
		  		end
				`OP_OP_IMM: begin
					wreg_o <= `WriteEnable; instvalid = `InstValid;
					imm <= {21{inst_i[31]}, inst_i[30:20]};
					opcode_o <= `OP_OP_IMM; wd_o <= inst_i[11:7];
					reg1_read_o <= 1'b1; reg2_read_o <= 1'b0;
					case (op2)
						`FUNCT3_ADDI: begin
							func3_o <= `FUNCT3_ADDI;
						end
						`FUNCT3_SLTI: begin
							func3_o <= `FUNCT3_SLTI;
						end
						`FUNCT3_SLTIU: begin
							func3_o <= `FUNCT3_SLTIU;
						end
						`FUNCT3_XORI: begin
							func3_o <= `FUNCT3_XORI;
						end
						`FUNCT3_ORI: begin
							func3_o <= `FUNCT3_ORI;
						end
						`FUNCT3_ANDI: begin
							func3_o <= `FUNCT3_ANDI;
						end
						`FUNCT3_SLLI: begin
							func3_o <= `FUNCT3_SLLI;
						end
						`FUNCT3_SRLI_SRAI: begin
							func3_o <= `FUNCT3_SRLI_SRAI;
							case (op3)
								`FUNCT7_SRLI: begin
									func7_o <= `FUNCT7_SRLI;
								end
								`FUNCT7_SRAI: begin
									func7_o <= `FUNCT7_SRAI;
								end
							endcase
						end
					endcase
				end
				`OP_OP: begin
					wreg_o <= `WriteEnable; instvalid = `InstValid;
					imm <= {32'b0};
					opcode_o <= `OP_OP; wd_o <= inst_i[11:7];
					reg1_read_o <= 1'b1; reg2_read_o <= 1'b1;                       
					case (op2)
						`FUNCT3_ADD_SUB: begin
							func3_o <= `FUNCT3_ADD_SUB;
							case (op3)
								`FUNCT7_ADD: begin
									func7_o <= `FUNCT7_ADD;
								end
								`FUNCT7_SUB: begin
									func7_o <= `FUNCT7_SUB;
								end
							endcase
						end
						`FUNCT3_SLL: begin
							func3_o <= `FUNCT3_SLL;
							func7_o <= `FUNCT7_SLL;
						end
						`FUNCT3_SLT: begin
							func3_o <= `FUNCT3_SLT;
							func7_o <= `FUNCT7_SLT;
						end
						`FUNCT3_SLTU: begin
							func3_o <= `FUNCT3_SLTU;
							func7_o <= `FUNCT7_SLTU;
						end
						`FUNCT3_XOR: begin
							func3_o <= `FUNCT3_XOR;
							func7_o <= `FUNCT7_XOR;
						end
						`FUNCT3_SRL_SRA: begin
							func3_o <= `FUNCT3_SRL_SRA;
							case (op3)
								`FUNCT7_SRL: begin
									func7_o <= `FUNCT7_ADD;
								end
								`FUNCT7_SRA: begin
									func7_o <= `FUNCT7_SUB;
								end
							endcase
						end
						`FUNCT3_OR: begin
							func3_o <= `FUNCT3_OR;
							func7_o <= `FUNCT7_OR;
						end
						`FUNCT3_AND: begin
							func3_o <= `FUNCT3_AND;
							func7_o <= `FUNCT7_AND;
						end
					endcase
		  		end
				`OP_MISC_MEM: begin
					wreg_o <= `WriteDisable; instvalid = `InstValid;
					imm <= {32'b0};
					opcode_o <= `OP_MISC_MEM; wd_o <= `NOPRegAddr
					reg1_read_o <= 1'b0; reg2_read_o <= 1'b0;
					case (op2)
						`FUNCT3_FENCE: begin
							func3_o <= `FUNCT3_FENCE;
						end
						`FUNCT3_FENCEI: begin
							func3_o <= `FUNCT3_FENCEI
						end
					endcase
				end
		    	default: begin
		    	end
		  endcase		  //case op	
		end    //if
	end      //always


 always @ (*) begin
	 wd_o <= wd_i;	 	 	
	 wreg_o <= wreg_i;
	 case ( alusel_i ) 
	 	`EXE_RES_LOGIC:		begin
	 		wdata_o <= logicout;
	 	end
	 	default:					begin
	 		wdata_o <= `ZeroWord;
	 	end
	 endcase
 end	

endmodule