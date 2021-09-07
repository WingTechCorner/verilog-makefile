default:
	@echo "The following Targets are available:"
	@echo "vcd    - create the vcd output using iverilog and suitable test bench"
	@echo "xc6    - Generate Xilinx Spartan6"
	@echo "ice40  - Lattice ICE40"
	@echo "ecp5   - Lattice ECP5"

clean:
	rm -rf *.json *.blif *.edif *.out *.vcd *.values
	rm -rf builds
	@ls -l

all: clean vcd xc6 ice40 ecp5

vcd:
	@echo "Generating the VDD executable script from Verilog files"
	@mkdir -p builds/vcd
	iverilog -Wall -o builds/vcd/top.out top.v top_tb.v \
		`cat verilog.includes | grep -v "^#" | tr '\012' ' '` \
		`cat verilog_tb.includes | grep -v "^#" | tr '\012' ' '`
	@echo "Running the top.out file to generate gtkwave file."
	@(cd builds/vcd; ./top.out)

view: vcd
	vcdcat builds/vcd/top_tb.vcd > builds/vcd/top_tb.values
	./scripts/vcdcat_clean_view.py builds/vcd/top_tb.values

xc6:
	#     -family {xcup|xcu|xc7|xc6s}
	@echo "Generating Spartan6 files"
	@mkdir -p builds/xc6s
	yosys -p "synth_xilinx -family xc6s -edif builds/xc6s/top.edif -blif builds/xc6s/top.blif" top.v \
		`cat verilog.includes | grep -v "^#" | tr '\012' ' '` 

ice40:
	@echo "Generating ICE40 files"
	@mkdir -p builds/ice40
	@yosys -p "hierarchy -top double_edge_detect; synth_ice40 -edif builds/ice40/top_ice40.edif -blif builds/ice40/top_ice40.blif -json builds/ice40/top_ice40.json" top.v `cat verilog.includes | grep -v "^#" | tr '\012' ' '` 
	@nextpnr-ice40 --hx8k --json builds/ice40/top_ice40.json --asc builds/ice40/top_ice40.asc --pcf-allow-unconstrained 
	@icepack builds/ice40/top_ice40.asc builds/ice40/top_ice40.bin

ecp5:
	@echo "Generating ECP5 files"
	@mkdir -p builds/ecp5
	@yosys -p "hierarchy -top double_edge_detect; synth_ecp5 -edif builds/ecp5/top_ecp5.edif -blif builds/ecp5/top_ecp5.blif -json builds/ecp5/top_ecp5.json" top.v `cat verilog.includes | grep -v "^#" | tr '\012' ' '` 
	@next-
