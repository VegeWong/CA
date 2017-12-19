module pc_reg(
    input wire    clk,
    input wire    rst,
    output reg    pc,
    output reg    ce
);

    always @ (posedge clk) begin
        if (rst == 'stEnable) begin
            ce <= 'ChipDisable;
        end else begin
            ce <= 'ChipEnable;
        end
    end

    always @ (posedge clk) begin
        if (ce == 'CHipDisable) begin
            pc <= 32'h00000000;
        end else begin
            pc <= pc + 4'h4;
        end
    end

endmodule
