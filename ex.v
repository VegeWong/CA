`include "defines.v"

module ex(

	input wire					  rst,
	
	//送到执行阶段的信息
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
	always @ (*) begin
		if(rst == `RstEnable) begin
			logicout <= `ZeroWord;
		end else begin
			case (opcode_i)
				`OP_OP_IMM: begin
					case(func3_i)
						`FUNCT3_ORI: begin
							logicout <= reg1_i | reg2_i;
						end
						default: begin
						end
					endcase //case OP-IMM->func3
				end
				default:				begin
					logicout <= `ZeroWord;
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