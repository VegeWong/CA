`include "defines.v"

module ex(

	input wire					  rst,
	
	//送到执行阶段的信息
	input wire[`AluselBus]        alusel_i,
	input wire[`OpcodeBus]        opcode_i,
	input wire[`Func3Bus]         func3_i,
	input wire[`Func7Bus]         func7_i,
	input wire[`RegBus]           reg1_i,
	input wire[`RegBus]           reg2_i,
	input wire[`RegAddrBus]       wd_i,
	input wire                    wreg_i,

	
	output reg[`RegAddrBus]       wd_o,
	output reg                    wreg_o,
	output reg[`RegBus]			  wdata_o
	
);

	reg[`RegBus] logicout;
	reg[`RegBus] shiftres;
	reg[`RegBus] arithmeticres;

	wire ov_sum;
	wire reg1_eq_reg2;
	wire reg1_lt_reg2;
	always @ (*) begin
		logice <= 1'b0;
		shifte <= 1'b0;
		logicout <= `ZeroWord;
		shiftres <= `ZeroWord;
		if(rst == `RstEnable) begin
			logice <= 1'b0;
			shifte <= 1'b0;
			logicout <= `ZeroWord;
			shiftres <= `ZeroWord;
		end else begin
			case (opcode_i)
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
					case(func3_i)
						`FUNCT3_ADDI: begin
							logice <= 1'b1;
							shifte <= 1'b0;
							logicout <= reg1_i + reg2_i;
							shiftres <= `ZeroWord;
						end
						`FUNCT3_SLTI: begin
							/*
								.....
							*/
						end
						`FUNCT3_SLTIU: begin
							/*
								.....
							*/
						end
						`FUNCT3_ORI: begin
							logice <= 1'b1;
							shifte <= 1'b0;
							logicout <= reg1_i | reg2_i;
							shiftres <= `ZeroWord;
						end
						`FUNCT3_XORI: begin
							logice <= 1'b1;
							shifte <= 1'b0;
							logicout <= reg1_i ^ reg2_i;
							shiftres <= `ZeroWord;
						end
						`FUNCT3_ANDI: begin
							logice <= 1'b1;
							shifte <= 1'b0;
							logicout <= reg1_i & reg2_i;
							shiftres <= `ZeroWord;
						end
						default: begin
							$display("Error: module ex: < OP_IMM error :: unknown func3 >");
						end
					endcase //case OP-IMM->func3
				end
				`OP_OP: begin

				end //OP-OP inst
				`OP_MISC_MEM: begin
					/*
						....
					*/
				end	//OP-MISC-MEM inst
				default: begin
					$display("Error: module ex: < :: unknown opcode >");
				end
			endcase //case opcode
		end    //if
	end      //always


 always @ (*) begin
	 wd_o <= wd_i;	 	 	
	 wreg_o <= wreg_i;
	 case (opcode_i) 
	 	`OP_OP_IMM:	begin
	 		wdata_o <= logicout;
	 	end
	 	default: begin
	 		wdata_o <= `ZeroWord;
	 	end
	 endcase
 end	

endmodule