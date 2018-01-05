CXX = iverilog
CFLAGS = -o
FILES = defines.v ex.v ex_mem.v id.v id_ex.v if_id.v inst_rom.v mem.v mem_wb.v openmips.v openmips_min_sopc.v openmips_min_sopc_tb.v pc_reg.v regfile.v

SXX = vvp
SFLAGSH = -n
SFLAGSR = -lxt2
# ***********
# Rules
# ***********

all: riscv.vcd

riscv.vcd: test
	$(SXX) $(SFLAGSH) test $(SFLAGSR)

test: $(FILES)
	rm -f test riscv.vcd
	$(CXX) $(CFLAGS) $@ $(FILES)
