CXX = iverilog
CFLAGS = -o
FILES = defines.v pc_reg.v ctrl.v          		\
		inst_rom.v if_id.v id.v                 \
		regfile.v id_ex.v ex.v					\
		ex_mem.v mem.v mem_wb.v 				\
		openmips.v openmips_min_sopc.v 			\
		openmips_min_sopc_tb.v  

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
