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
			opcode_o <= `EXE_OP_NOP;
			func7_o <= `EXE_FUNC7_NOP;
			func3_o <= `EXE_FUNC3_NOP;
			wd_o <= inst_i[11:7];
			wreg_o <= `WriteDisable;
			imm <= `ZeroWord;			
		  case (op)
		  	opcode_o <= op;
		  	`OP_OP_IMME: begin
			  	func3_o <= op2;
			  	case(op2)
					`FUNCT3_ORI: begin                 
		  				wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
		  				reg1_read_o <= 1'b1; reg2_read_o <= 1'b0;	  	
						imm <= {21{inst_i[31]}, inst_i[30:20]};
						instvalid <= `InstValid;
					end
					default: begin
					end
				endcase		//case op2
		  	end 			//OP-IMME inst				 
		    default:			begin
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