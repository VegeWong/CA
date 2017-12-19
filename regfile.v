module regfile(
    input wire  clk,
    input wire  rst,

    //write port
    input wire              we,
    input wire[`RegAddrBus] waddr,
    input wire[`RegBus]     wdata,

    //read port 1
    input wire              rel,
    input wire[`RegAddrBus] raddr1,
    output reg[`RegBus]     rdata1，

);
