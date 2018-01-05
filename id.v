`include "defines.v"

module id(

	input wire					  rst,
	input wire[`InstAddrBus]	  pc_i,
	input wire[`InstBus]          inst_i,

	input wire[`RegBus]           reg1_data_i,
	input wire[`RegBus]           reg2_data_i,
	//input from ex
	input wire					  ex_wreg_i,
	input wire[`RegBus]           ex_wdata_i,
	input wire[`RegAddrBus]       ex_wd_i,
	//input from mem
	input wire					  mem_wreg_i,
	input wire[`RegBus]           mem_wdata_i,
	input wire[`RegAddrBus]       mem_wd_i,
	//送到regfile的信息
	output reg                    reg1_read_o,
	output reg                    reg2_read_o,     
	output reg[`RegAddrBus]       reg1_addr_o,
	output reg[`RegAddrBus]       reg2_addr_o, 	      
	
	//送到执行阶段的信息
	output reg[`AluselBus]        alusel_o,
	output reg[`OpcodeBus]        opcode_o,
	output reg[`Func3Bus]         func3_o,
	output reg[`Func7Bus]         func7_o,
	output reg[`RegBus]           reg1_o,
	output reg[`RegBus]           reg2_o,
	output reg[`RegAddrBus]       wd_o,
	output reg                    wreg_o
);

  wire[6:0] op  = inst_i[6:0];
  wire[2:0] op2 = inst_i[14:12];
  wire[6:0] op3 = inst_i[31:25];
  reg[`RegBus]	imm;
  reg instvalid;
  
 
	always @ (*) begin	
		if (rst == `RstEnable) begin
			//regfile
			reg1_read_o <= 1'b0;
			reg2_read_o <= 1'b0;
			reg1_addr_o <= `NOPRegAddr;
			reg2_addr_o <= `NOPRegAddr;	
			//exec
			instvalid <= `InstInvalid;
			alusel_o <= `ALU_NOP;
			opcode_o <= `EXE_OP_NOP;
			func7_o <= `EXE_FUNC7_NOP;
			func3_o <= `EXE_FUNC3_NOP;
			wd_o <= `NOPRegAddr;
			wreg_o <= `WriteDisable;
			imm <= `ZeroWord;		
	  	end else begin
			//regfile
			reg1_read_o <= 1'b0;
			reg2_read_o <= 1'b0;
			reg1_addr_o <= inst_i[19:15];
			reg2_addr_o <= inst_i[24:20];	
			//exec
			instvalid <= `InstInvalid;
			alusel_o <= `ALU_NOP;
			opcode_o <= `EXE_OP_NOP;
			func7_o <= `EXE_FUNC7_NOP;
			func3_o <= `EXE_FUNC3_NOP;
			wd_o <= inst_i[11:7];
			wreg_o <= `WriteDisable;
			imm <= `ZeroWord;			
		  case (op)
		  	`OP_LUI: begin
				/*
					....
				*/
			end	//OP-LUI inst
			`OP_AUIPC: begin
				/*
					....
				*/
			end	//OP-AUIPC inst
			`OP_JAL: begin
				/*
					....
				*/
			end	//OP-JAL inst
			`OP_JALR: begin
				/*
					....
				*/
			end	//OP-JALR inst
			`OP_BRANCH: begin
				/*
					....
				*/
			end	//OP-BRANCH inst
			`OP_LOAD: begin
				/*
					....
				*/
			end	//OP-LOAD inst
			`OP_STORE: begin
				/*
					....
				*/
			end	//OP-STORE inst
		  	`OP_OP_IMM: begin
			  	case(op2)
					`FUNCT3_ADDI: begin
						alusel_o <= ALU_ARI; opcode_o <= op; func3_o <= op2;
						wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
		  				reg1_read_o <= 1'b1; reg2_read_o <= 1'b0;	  	
						imm <= {21{inst_i[31]}, inst_i[30:20]};
						instvalid <= `InstValid;
					end
					`FUNCT3_SLTI: begin
						alusel_o <= ALU_ARI; opcode_o <= op; func3_o <= op2;
						wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
		  				reg1_read_o <= 1'b1; reg2_read_o <= 1'b0;	  	
						imm <= {21{inst_i[31]}, inst_i[30:20]};
						instvalid <= `InstValid;
					end
					`FUNCT3_SLTIU: begin
						alusel_o <= ALU_ARI; opcode_o <= op; func3_o <= op2;
						wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
		  				reg1_read_o <= 1'b1; reg2_read_o <= 1'b0;	  	
						imm <= {21{inst_i[31]}, inst_i[30:20]};
						instvalid <= `InstValid;
					end
					`FUNCT3_ORI: begin
						alusel_o <= ALU_LOG; opcode_o <= op; func3_o <= op2;               
		  				wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
		  				reg1_read_o <= 1'b1; reg2_read_o <= 1'b0;	  	
						imm <= {21{inst_i[31]}, inst_i[30:20]};
						instvalid <= `InstValid;
					end
					`FUNCT3_XORI: begin
						alusel_o <= ALU_LOG; opcode_o <= op; func3_o <= op2;
						wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
		  				reg1_read_o <= 1'b1; reg2_read_o <= 1'b0;	  	
						imm <= {21{inst_i[31]}, inst_i[30:20]};
						instvalid <= `InstValid;
					end
					`FUNCT3_ANDI: begin
						alusel_o <= ALU_LOG; opcode_o <= op; func3_o <= op2;
						wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
		  				reg1_read_o <= 1'b1; reg2_read_o <= 1'b0;	  	
						imm <= {21{inst_i[31]}, inst_i[30:20]};
						instvalid <= `InstValid;
					end
					`FUNCT3_SLLI: begin
						alusel_o <= ALU_LOG; opcode_o <= op; func3_o <= op2; func7_o <= op3;
						wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
		  				reg1_read_o <= 1'b1; reg2_read_o <= 1'b0;	  	
						imm <= {inst_i[24:20]};
						instvalid <= `InstValid;
					end
					`FUNCT3_SRLI_SRAI: begin
						case(op3)
							`FUNCT7_SRLI: begin
								alusel_o <= ALU_LOG; opcode_o <= op; func3_o <= op2; func7_o <= op3;
								wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
								reg1_read_o <= 1'b1; reg2_read_o <= 1'b0;	  	
								imm <= {inst_i[24:20]};
								instvalid <= `InstValid;
							end
							`FUNCT7_SRAI: begin
								alusel_o <= ALU_ARI; opcode_o <= op; func3_o <= op2; func7_o <= op3;
								wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
								reg1_read_o <= 1'b1; reg2_read_o <= 1'b0;	  	
								imm <= {inst_i[24:20]};
								instvalid <= `InstValid;
							end
							default: begin
								$display("Error: module id: < OP-OP-IMM :: FUNCT3-SRLI-SRAI :: unknown func7 >");
							end
						endcase //FUNCT3_SRLI_SRAI op3
					end
					default: begin
						$display("Error: module id: < OP-OP-IMM :: unknown func3 >");
					end
				endcase		//case OP_OP_IMME: op2
		  	end //OP-OP-IMME inst
			`OP_OP: begin
				case(op2)
					`FUNCT3_ADD_SUB: begin
						case(op3)
							`FUNCT7_ADD: begin
								alusel_o <= ALU_ARI; opcode_o <= op; func3_o <= op2; func7_o <= op3;
								wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
								reg1_read_o <= 1'b1; reg2_read_o <= 1'b1;	  	
								imm <= `ZeroWord;
								instvalid <= `InstValid;
							end
							`FUNCT7_SUB: begin
								alusel_o <= ALU_ARI; opcode_o <= op; func3_o <= op2; func7_o <= op3;
								wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
								reg1_read_o <= 1'b1; reg2_read_o <= 1'b1;	  	
								imm <= `ZeroWord;
								instvalid <= `InstValid;
							end
							default: begin
								$display("Error: module id: < OP-O :: ADD_SUB :: unknown func3 >");
							end
						endcase //ADD-SUB func7
					end
					`FUNCT3_SLL: begin
						alusel_o <= ALU_LOG; opcode_o <= op; func3_o <= op2;
						wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
		  				reg1_read_o <= 1'b1; reg2_read_o <= 1'b1;	  	
						imm <= `ZeroWord;
						instvalid <= `InstValid;
					end
					`FUNCT3_SLT: begin
						alusel_o <= ALU_ARI; opcode_o <= op; func3_o <= op2;
						wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
		  				reg1_read_o <= 1'b1; reg2_read_o <= 1'b1;	  	
						imm <= `ZeroWord;
						instvalid <= `InstValid;
					end
					`FUNCT3_SLTU: begin
						alusel_o <= ALU_ARI; opcode_o <= op; func3_o <= op2;
						wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
		  				reg1_read_o <= 1'b1; reg2_read_o <= 1'b1;	  	
						imm <= `ZeroWord;
						instvalid <= `InstValid;
					end
					`FUNCT3_XOR: begin
						alusel_o <= ALU_LOG; opcode_o <= op; func3_o <= op2;
						wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
		  				reg1_read_o <= 1'b1; reg2_read_o <= 1'b1;	  	
						imm <= `ZeroWord;
						instvalid <= `InstValid;
					end
					`FUNCT3_SRL_SRA: begin
						case(op3)
							`FUNCT7_SRL: begin
								alusel_o <= ALU_LOG; opcode_o <= op; func3_o <= op2; func7_o <= op3
								wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
								reg1_read_o <= 1'b1; reg2_read_o <= 1'b1;	  	
								imm <= `ZeroWord;
								instvalid <= `InstValid;
							end
							`FUNCT7_SRA: begin
								alusel_o <= ALU_ARI; opcode_o <= op; func3_o <= op2; func7_o <= op3
								wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
								reg1_read_o <= 1'b1; reg2_read_o <= 1'b1;	  	
								imm <= `ZeroWord;
								instvalid <= `InstValid;
							end
							default: begin
								$display("Error: module id: < OP-OP :: SRL_SRA :: unknown func7 >");
							end
						endcase//SRL_SRA op3
					end
					`FUNCT3_OR: begin
						alusel_o <= ALU_LOG; opcode_o <= op; func3_o <= op2;
						wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
		  				reg1_read_o <= 1'b1; reg2_read_o <= 1'b1;	  	
						imm <= `ZeroWord;
						instvalid <= `InstValid;
					end
					`FUNCT3_AND: begin
						alusel_o <= ALU_LOG; opcode_o <= op; func3_o <= op2;
						wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
		  				reg1_read_o <= 1'b1; reg2_read_o <= 1'b1;	  	
						imm <= `ZeroWord;
						instvalid <= `InstValid;
					end
					default: begin
						$display("Error: module id: < OP-OP :: unknown func3 >");
					end
				endcase //OP-OP op2
			end	//OP-OP inst
			`OP_MISC_MEM: begin
				/*
					....
				*/
			end	//OP-MISC-MEM inst
		    default: begin
				$display("Error: module id: < :: unknown opcode >");
		    end
		  endcase		  //case op			
		end       //if
	end         //always
	

	always @ (*) begin
		if(rst == `RstEnable) begin
			reg1_o <= `ZeroWord;
		end else if((reg1_read_o == 1'b1) && (ex_wreg_i == 1'b1)
					&&(ex_wd_i == reg1_addr_o)) begin
			reg1_o <= ex_wdata_i;
		end else if ((reg1_read_o == 1'b1) && (mem_wreg_i == 1'b1)
					&&(mem_wd_i == reg1_addr_o)) begin
			reg1_o <= mem_wdata_i;	
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
		end else if((reg2_read_o == 1'b1) && (ex_wreg_i == 1'b1)
					&&(ex_wd_i == reg2_addr_o)) begin
			reg2_o <= ex_wdata_i;
		end else if ((reg2_read_o == 1'b1) && (mem_wreg_i == 1'b1)
					&&(mem_wd_i == reg2_addr_o)) begin
			reg2_o <= mem_wdata_i;	
	  	end else if(reg2_read_o == 1'b1) begin
	  		reg2_o <= reg2_data_i;
	  	end else if(reg2_read_o == 1'b0) begin
	  		reg2_o <= imm;
	  	end else begin
	    	reg2_o <= `ZeroWord;
	  	end
	end

endmodule