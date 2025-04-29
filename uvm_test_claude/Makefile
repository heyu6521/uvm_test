# Makefile for Simple Adder UVM Testbench
# 修改这些变量以匹配您的安装位置
VCS      = vcs
VERDI    = verdi
VCS_HOME = /opt/synopsys/vcs/vcs-mx/O-2018.09-SP2
UVM_HOME = /opt/synopsys/vcs/vcs-mx/O-2018.09-SP2/etc/uvm

# 基本目录
RTL_DIR = ./rtl
TB_DIR  = ./tb
SIM_DIR = ./sim

# 源文件
RTL_SRCS = $(RTL_DIR)/simple_adder.v
TB_SRCS  = $(TB_DIR)/simple_adder_if.sv \
           $(TB_DIR)/simple_adder_pkg.sv \
           $(TB_DIR)/simple_adder_test.sv \
           $(TB_DIR)/top.sv

# 编译和仿真选项
COMP_OPTS = -sverilog \
            -timescale=1ns/1ps \
            -CFLAGS -DVCS \
            +v2k \
            -full64 \
            -debug_all \
						-debug_access+all -fsdb \
            +incdir+$(TB_DIR) \
            +incdir+$(UVM_HOME) \
            $(UVM_HOME)/uvm.sv \
            $(UVM_HOME)/dpi/uvm_dpi.cc \
            -LDFLAGS -Wl,--no-as-needed

SIM_OPTS  = -l $(SIM_DIR)/sim.log \
            +UVM_TESTNAME=simple_adder_test \
            +UVM_VERBOSITY=UVM_MEDIUM \
            +UVM_PHASE_TRACE \
						+fsdbfile+dump.fsdb \
						+vcs+kdb

# 默认目标
all: comp run

# 创建目录
$(SIM_DIR):
	mkdir -p $(SIM_DIR)

# 编译
comp: $(SIM_DIR)
#	$(VCS) $(COMP_OPTS) $(RTL_SRCS) $(TB_SRCS) -o $(SIM_DIR)/simv
	$(VCS) $(COMP_OPTS) -f filelist.f -o $(SIM_DIR)/simv

# 运行仿真
run: $(SIM_DIR)
	cd $(SIM_DIR) && ./simv $(SIM_OPTS)

# 启动波形查看器
verdi: $(SIM_DIR)
	cd $(SIM_DIR) && $(VERDI) -v $(RTL_SRCS) -sv $(TB_SRCS) -ssf dump.fsdb -nologo -autoread -top top
#verdi: $(SIM_DIR)
#	cd $(SIM_DIR) && $(VERDI) -kdb simv.kdb -ssf dump.fsdb -nologo &	
# 运行随机测试
test_random: comp
	cd $(SIM_DIR) && ./simv $(SIM_OPTS) +UVM_TESTNAME=simple_adder_random_test

# 运行定向测试
test_directed: comp
	cd $(SIM_DIR) && ./simv $(SIM_OPTS) +UVM_TESTNAME=simple_adder_directed_test

# 运行所有测试
test_all: test_random test_directed

filelist:
	find ./rtl ./tb -name "*.v" -o -name "*.sv" > filelist.f


# 生成覆盖率报告
cov:
	cd $(SIM_DIR) && $(VCS_HOME)/bin/urg -dir simv.vdb -format both -report cov_report

# 清理生成的文件
clean:
	rm -rf $(SIM_DIR)/* csrc *.log *.vpd *.vdb *.key *.fsdb

# 完全清理
clean_all: clean
	rm -rf $(SIM_DIR)

.PHONY: all comp run verdi test_random test_directed test_all clean clean_all cov
