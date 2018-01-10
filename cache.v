module cache{

	input wire					  rst,

    //from MEM
	input wire[`RegBus]           addr_i,
	input wire                    we_i,
	input wire[3:0]               sel_i,
	input wire[`RegBus]           data_i,
	input wire                    ce_i,

    //from RAM
    input wire                    RAM_data_i,

    //to MEM
    output reg[`DataBus]          mem_data_o.

    //to RAM
    output reg[`RegBus]           addr_o,
	output wire                   we_o,
	output reg[3:0]               sel_o,
	output reg[`RegBus]           data_o,
	output reg                    ce_o

};

    wire[1:0] set_select;
    reg[65:0] cache[0:7];
    reg hit_way0, hit_way1, hit, hit_ref;

    assign set_select = addr_i[3:2];
    
    always @ (*) begin
        if(rst == `RstEnable) begin
            hit_way0 <= 0;
            hit_way1 <= 0;
            hit      <= 0;
            hit_ref <= 0;
        end else if (ce_i == `ChipEnable) begin
            case (set_select)
                `2'b00: begin
                    hit_way0 <= (cache[0][`ValidBit] == `Valid &&
                                 cache[0][`CacheTag] == addr_i)
                    hit_way1 <= (cache[4][`ValidBit] == `Valid &&
                                 cache[4][`CacheTag] == addr_i)
                    hit <= hit_way0 | hit_way1;
                end
                `2'b01: begin
                    hit_way0 <= (cache[1][`ValidBit] == `Valid &&
                                 cache[1][`CacheTag] == addr_i)
                    hit_way1 <= (cache[5][`ValidBit] == `Valid &&
                                 cache[5][`CacheTag] == addr_i)
                    hit <= hit_way0 | hit_way1;
                end
                `2'b10: begin
                    hit_way0 <= (cache[2][`ValidBit] == `Valid &&
                                 cache[2][`CacheTag] == addr_i)
                    hit_way1 <= (cache[6][`ValidBit] == `Valid &&
                                 cache[6][`CacheTag] == addr_i)
                    hit <= hit_way0 | hit_way1;
                end
                `2'b11: begin
                    hit_way0 <= (cache[3][`ValidBit] == `Valid &&
                                 cache[3][`CacheTag] == addr_i)
                    hit_way1 <= (cache[7][`ValidBit] == `Valid &&
                                 cache[7][`CacheTag] == addr_i)
                    hit <= hit_way0 | hit_way1;
                end
                default: begin
                    hit_way0 <= 0;
                    hit_way1 <= 0;
                    hit      <= 0;
                end
            endcase
        end else begin
            hit_way0 <= 0;
            hit_way1 <= 0;
            hit      <= 0;
        end
    end // always

    always @ (*) begin
        if(rst == `RstEnable) begin
            data_o <= `ZeroWord;
            addr_o <= `ZeroWord;
            we_o <= 1'b0;
            sel_o <= 4'b0;
            mem_data_o <= `ZeroWord;
            ce_o <= `ChipDisable;
        end else if (ce_i == `ChipDisable) begin
            data_o <= `ZeroWord;
            addr_o <= `ZeroWord;
            we_o <= 1'b0;
            sel_o <= 4'b0;
            mem_data_o <= `ZeroWord;
            ce_o <= `ChipDisable;
        end else if (hit && we_i == `WriteEnable) begin
            addr_o <= `ZeroWord;
            we_o <= 1'b0;
            sel_o <= 4'b0;
            data_o <= `ZeroWord;
            ce_o <= `ChipDisable;

            case (set_select)
                `2'b00: begin
                    if (hit_way0) begin
                        if (sel[3] == 1'b1) begin
                            cache[0][31:24] <= data_i[31:24];
                        end
                        if (sel[2] == 1'b1) begin
                            cache[0][23:16] <= data_i[23:16];
                        end
                        if (sel[1] == 1'b1) begin
                            cache[0][15:8] <= data_i[15:8];
                        end
                        if (sel[0] == 1'b1) begin
                            cache[0][7:0] <= data_i[7:0];
                        end
                    end else begin
                        if (sel[3] == 1'b1) begin
                            cache[4][31:24] <= data_i[31:24];
                        end
                        if (sel[2] == 1'b1) begin
                            cache[4][23:16] <= data_i[23:16];
                        end
                        if (sel[1] == 1'b1) begin
                            cache[4][15:8] <= data_i[15:8];
                        end
                        if (sel[0] == 1'b1) begin
                            cache[4][7:0] <= data_i[7:0];
                        end
                    end
                end
                `2'b01: begin
                    if (hit_way0) begin
                        if (sel[3] == 1'b1) begin
                            cache[1][31:24] <= data_i[31:24];
                        end
                        if (sel[2] == 1'b1) begin
                            cache[1][23:16] <= data_i[23:16];
                        end
                        if (sel[1] == 1'b1) begin
                            cache[1][15:8] <= data_i[15:8];
                        end
                        if (sel[0] == 1'b1) begin
                            cache[1][7:0] <= data_i[7:0];
                        end
                    end else begin
                        if (sel[3] == 1'b1) begin
                            cache[5][31:24] <= data_i[31:24];
                        end
                        if (sel[2] == 1'b1) begin
                            cache[5][23:16] <= data_i[23:16];
                        end
                        if (sel[1] == 1'b1) begin
                            cache[5][15:8] <= data_i[15:8];
                        end
                        if (sel[0] == 1'b1) begin
                            cache[5][7:0] <= data_i[7:0];
                        end
                    end
                end
                `2'b10: begin
                    if (hit_way0) begin
                        if (sel[3] == 1'b1) begin
                            cache[2][31:24] <= data_i[31:24];
                        end
                        if (sel[2] == 1'b1) begin
                            cache[2][23:16] <= data_i[23:16];
                        end
                        if (sel[1] == 1'b1) begin
                            cache[2][15:8] <= data_i[15:8];
                        end
                        if (sel[0] == 1'b1) begin
                            cache[2][7:0] <= data_i[7:0];
                        end
                    end else begin
                        if (sel[3] == 1'b1) begin
                            cache[6][31:24] <= data_i[31:24];
                        end
                        if (sel[2] == 1'b1) begin
                            cache[6][23:16] <= data_i[23:16];
                        end
                        if (sel[1] == 1'b1) begin
                            cache[6][15:8] <= data_i[15:8];
                        end
                        if (sel[0] == 1'b1) begin
                            cache[6][7:0] <= data_i[7:0];
                        end
                    end
                end
                `2'b11: begin
                    if (hit_way0) begin
                        if (sel[3] == 1'b1) begin
                            cache[3][31:24] <= data_i[31:24];
                        end
                        if (sel[2] == 1'b1) begin
                            cache[3][23:16] <= data_i[23:16];
                        end
                        if (sel[1] == 1'b1) begin
                            cache[3][15:8] <= data_i[15:8];
                        end
                        if (sel[0] == 1'b1) begin
                            cache[3][7:0] <= data_i[7:0];
                        end
                    end else begin
                        if (sel[3] == 1'b1) begin
                            cache[7][31:24] <= data_i[31:24];
                        end
                        if (sel[2] == 1'b1) begin
                            cache[7][23:16] <= data_i[23:16];
                        end
                        if (sel[1] == 1'b1) begin
                            cache[7][15:8] <= data_i[15:8];
                        end
                        if (sel[0] == 1'b1) begin
                            cache[7][7:0] <= data_i[7:0];
                        end
                    end
                end
                default: begin
                end
            endcase
        end else if (we_i == `WriteEnable) begin
            data_o <= data_i;
            addr_o <= addr_i;
            we_o <= 1'b1;
            sel_o <= sel_i;
            ce_o <= `ChipEnable;
        end
    end //always










endmodule