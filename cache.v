//block size: 4 bytes
//write policy: write through

`include "defines.v"

module cache(
    
    input wire                 rst,
    input wire                 clk,

    //from MEM
    input wire[`RegBus]        mem_addr_i,
    input wire                 mem_we_i,
    input wire[3:0]            mem_sel_i,
    input wire[`RegBus]        mem_data_i,
    input wire                 mem_ce_i,

    //from RAM
    input wire[`RegBus]        ram_data_i,

    //to RAM
    output reg[`RegBus]        ram_addr_o,
    output reg                 ram_we_o,
    output reg[3:0]            ram_sel_o,
    output reg[`RegBus]        ram_data_o,
    output reg                 ram_ce_o,
    
    //to MEM
    output reg[`RegBus]        mem_data_o,

    //to ctrl
    output wire                stallreq
);
    
    wire set_select;
    reg[64:0] cache[0:4];
    reg hit;
    reg ready;
    reg[64:0] write_buffer;

    assign set_select = mem_addr_i[3:2];

    always @ (*) begin
        if (rst == `RstEnable) begin
            hit <= `NotHit;
        end else if (mem_ce_i == `ChipDisable) begin
            hit <= `NotHit;
        end else begin
            case (set_select)
                2'b00: begin
                    hit <= (cache[0][`ValidBit] == `Valid &&
                                 cache[0][`CacheTag] == mem_addr_i);
                end
                2'b01: begin
                    hit <= (cache[1][`ValidBit] == `Valid &&
                                 cache[1][`CacheTag] == mem_addr_i);
                end
                2'b10: begin
                    hit <= (cache[2][`ValidBit] == `Valid &&
                                 cache[2][`CacheTag] == mem_addr_i);
                end
                2'b11: begin
                    hit <= (cache[3][`ValidBit] == `Valid &&
                                 cache[3][`CacheTag] == mem_addr_i);
                end
            endcase
            $display("Hit = %b", hit);
        end
    end //always

    always @ (*) begin
        ready <= 1'b0;
        if (rst == `RstEnable) begin
            ram_addr_o <= `ZeroWord;
            ram_we_o <= `WriteDisable;
            ram_sel_o <= 4'b0;
            ram_data_o <= `ZeroWord;
            ram_ce_o <= `ChipDisable;
            mem_data_o <= `ZeroWord;
            ready <= 1'b1;
        end else if (ram_ce_o == `ChipDisable) begin
            if (write_buffer[`ValidBit] == 1'b0) begin
                ram_addr_o <= `ZeroWord;
                ram_we_o <= `WriteDisable;
                ram_sel_o <= 4'b0;
                ram_data_o <= `ZeroWord;
                ram_ce_o <= `ChipDisable;
                ready <= 1'b1;
            end else begin
                ram_addr_o <= write_buffer[63:32];
                ram_we_o <= `WriteEnable;
                ram_sel_o <= 4'b1111;
                ram_data_o <= write_buffer[`DataStorage];
                ram_ce_o <= `ChipEnable;
                $display("spare time writing");
            end
        end else if (!hit) begin
            if (mem_we_i == `WriteDisable) begin
                ram_addr_o <= mem_addr_i;
                ram_we_o <= mem_we_i;
                ram_sel_o <= mem_sel_i;
                ram_data_o <= mem_data_i;
                ram_ce_o <= mem_ce_i;
            end else begin
                write_buffer <= {1'b1, mem_addr_i[31:0], mem_data_i[31:0]};
                ready <= 1'b1;
            end
        end else begin
            ram_addr_o <= `ZeroWord;
            ram_we_o <= `WriteDisable;
            ram_sel_o <= 4'b0;
            ram_data_o <= `ZeroWord;
            ram_ce_o <= `ChipDisable;
            if (mem_we_i == `WriteDisable) begin
                case (set_select)
                    2'b00: begin
                        mem_data_o <= (cache[0][`DataStorage]);
                    end
                    2'b01: begin
                        mem_data_o <= (cache[1][`DataStorage]);
                    end
                    2'b10: begin
                        mem_data_o <= (cache[2][`DataStorage]);
                    end
                    2'b11: begin
                        mem_data_o <= (cache[3][`DataStorage]);
                    end
                endcase
                ready <= 1'b1;
            end else begin
                case (set_select)
                    2'b00: begin
                        if (mem_sel_i[3] == 1'b1) begin
                            cache[0][31:24] <= mem_data_i[31:24];
                        end
                        if (mem_sel_i[2] == 1'b1) begin
                            cache[0][23:16] <= mem_data_i[23:16];
                        end
                        if (mem_sel_i[1] == 1'b1) begin
                            cache[0][15:8] <= mem_data_i[15:8];
                        end
                        if (mem_sel_i[0] == 1'b1) begin
                            cache[0][7:0] <= mem_data_i[7:0];
                        end	
                    end
                    2'b01: begin
                         if (mem_sel_i[3] == 1'b1) begin
                            cache[1][31:24] <= mem_data_i[31:24];
                        end
                        if (mem_sel_i[2] == 1'b1) begin
                            cache[1][23:16] <= mem_data_i[23:16];
                        end
                        if (mem_sel_i[1] == 1'b1) begin
                            cache[1][15:8] <= mem_data_i[15:8];
                        end
                        if (mem_sel_i[0] == 1'b1) begin
                            cache[1][7:0] <= mem_data_i[7:0];
                        end	
                    end
                    2'b10: begin
                         if (mem_sel_i[3] == 1'b1) begin
                            cache[2][31:24] <= mem_data_i[31:24];
                        end
                        if (mem_sel_i[2] == 1'b1) begin
                            cache[2][23:16] <= mem_data_i[23:16];
                        end
                        if (mem_sel_i[1] == 1'b1) begin
                            cache[2][15:8] <= mem_data_i[15:8];
                        end
                        if (mem_sel_i[0] == 1'b1) begin
                            cache[2][7:0] <= mem_data_i[7:0];
                        end	
                    end
                    2'b11: begin
                         if (mem_sel_i[3] == 1'b1) begin
                            cache[3][31:24] <= mem_data_i[31:24];
                        end
                        if (mem_sel_i[2] == 1'b1) begin
                            cache[3][23:16] <= mem_data_i[23:16];
                        end
                        if (mem_sel_i[1] == 1'b1) begin
                            cache[3][15:8] <= mem_data_i[15:8];
                        end
                        if (mem_sel_i[0] == 1'b1) begin
                            cache[3][7:0] <= mem_data_i[7:0];
                        end	
                    end
                endcase
                ready <= 1'b1;
            end
        end
    end //always

    always @ (*) begin
        if (rst == `RstEnable) begin
            cache[0] <= `CacheNOP;
            cache[1] <= `CacheNOP;
            cache[2] <= `CacheNOP;
            cache[3] <= `CacheNOP;
        end else if (ready == 1'b0) begin
            case (set_select)
                2'b00: begin
                    if (cache[0][`ValidBit] == 1'b1) begin
                        write_buffer <= cache[0][64:0];
                    end else begin
                        write_buffer <= {1'b1, mem_addr_i[31:0], ram_data_i[31:0]};
                    end
                end
                2'b01: begin
                    if (cache[1][`ValidBit] == 1'b1) begin
                        write_buffer <= cache[1][64:0];
                    end else begin
                        cache[1] <= {1'b1, mem_addr_i[31:0], ram_data_i[31:0]};
                    end
                end
                2'b10: begin
                    if (cache[2][`ValidBit] == 1'b1) begin
                        write_buffer <= cache[2][64:0];
                    end else begin
                        cache[2] <= {1'b1, mem_addr_i[31:0], ram_data_i[31:0]};
                    end
                end
                2'b11: begin
                   if (cache[3][`ValidBit] == 1'b1) begin
                        write_buffer <= cache[3][64:0];
                    end else begin
                        cache[3] <= {1'b1, mem_addr_i[31:0], ram_data_i[31:0]};
                    end
                end
            endcase
        end
    end //always

    assign stallreq = !ready;

endmodule