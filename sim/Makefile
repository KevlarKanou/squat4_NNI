# Makefile for SystemVerilog Testbench Lab1
# LAB_DIR = lab5
RTL= ../src/rtl/hec_cal.v ../src/rtl/LookupTable.v ../src/rtl/utopia1_atm_rx.v ../src/rtl/utopia1_atm_tx.v ../src/rtl/FwdLkp.v ../src/rtl/arbitor.v ../src/rtl/squat4_NNI.v
SVTB = ../src/tb/top.sv ../src/tb/cpu_ifc.sv ../src/tb/Utopia.sv
SVCM = ../src/env/test.sv ../src/env/environment.sv ../src/env/config.sv ../src/env/generator.sv ../src/env/driver.sv ../src/env/monitor.sv ../src/env/scoreboard.sv ../src/env/coverage.sv
# seed = 123456
seed = $(shell date +%s)

default: test 

test: compile run

run:
	./simv -l simv.log +ntb_random_seed=$(seed)

compile:
	vcs -full64 -l vcs.log -sverilog -kdb +lint=TFIPC-L -debug_access+all $(SVTB) $(RTL) $(SVCM) +vcs+vcdpluson -lca -fsdb

verdi:
	verdi -ssf novas.fsdb -undockWin -nologo &

dve:
	dve -vpd vcdplus.vpd &

cov:
	dve -covdir simv.vdb -full64 &

urg:
	urg -full64 -dir simv.vdb

verdi_debug:
	./simv -l simv.log -gui=verdi +ntb_random_seed=$(seed)

debug:
	./simv -l simv.log -gui=dve +ntb_random_seed=$(seed)

# solution: clean
# 	cp -f ../../solutions/$(LAB_DIR)/*.sv .

clean:
	rm -rf simv* csrc* *.tmp *.vpd *.key *.log *hdrs.h *.fsdb verdiLog elabcomLog novas.* *.dat DVEfiles urgReport vdCovLog

# nuke: clean
# 	rm -rf *.v* *.sv include .*.lock .*.old DVE* *.tcl *.h *.rc *.ses *.ses.* *.dat
# 	cp -f ../../solutions/$(LAB_DIR)/router_io.sv.orig router_io.sv
# 	cp -f ../../solutions/$(LAB_DIR)/router_test_top.sv.orig router_test_top.sv
# 	cp -f ../../solutions/$(LAB_DIR)/test.sv.orig test.sv

help:
	@echo ==========================================================================
	@echo  " 								       "
	@echo  " USAGE: make target <seed=xxx>                                         "
	@echo  " 								       "
	@echo  " ------------------------- Test TARGETS ------------------------------ "
	@echo  " test       => Compile TB and DUT files, runs the simulation.          "
	@echo  " compile    => Compile the TB and DUT. Generates dve and verdi output  "
	@echo  " run        => Run the simulation.                                     "
	@echo  " dve        => Run dve in post-processing mode.          "
	@echo  "                                                                       "
	@echo  " verdi      => Run verdi in post-processing mode.          "
	@echo  " verdi_gui  => Run simulation interactively with verdi                  "
	@echo  "               All verdi targets must have Verdi installed.          "
	@echo  " cov	    => Analyze coverage             							"
	@echo  " urg	    => Report coverage result             						"
	@echo  "                                                                       "
	@echo  " debug      => Runs simulation interactively with dve.                  "
	@echo  " clean      => Remove all intermediate simv and log files.             "
	@echo  "                                                                       "
	@echo  " -------------------- ADMINISTRATIVE TARGETS ------------------------- "
	@echo  " help       => Displays this message.                                  "
# 	@echo  " solution   => Copies all files from solutions directory.               "
# 	@echo  " nuke       => Erase all files except Makefile. Put directory back to original state. "
	@echo  "								       "
	@echo ==========================================================================

#.PHONY: run
