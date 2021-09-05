default:
	@echo "The following Targets are available:"
	@echo "vcd    - create the vcd output using iverilog and suitable test bench"
	@echo "xc6    - Generate Xilinx Spartan6"
	@echo "ice40  - Lattice ICE40"
	@echo "ecp5   - Lattice ECP5"

clean:
	rm -rf *.json *.blif *.edif *.out *.vcd

vcd:
	@echo "Generating the VDD executable script from Verilog files"
	iverilog -Wall -o top.out top.v top_tb.v \
		`cat verilog.includes | grep -v "^#" | tr '\012' ' '`
	@echo "Running the top.out file to generate gtkwave file."
	./top.out

xc6:
	#     -family {xcup|xcu|xc7|xc6s}
	@echo "Generating Spartan6 files"
	yosys -p "synth_xilinx -family xc6s -edif top.edif -blif top.blif" top.v \
		`cat verilog.includes | grep -v "^#" | tr '\012' ' '` 

ice40:
	@echo "Generating ICE40 files"
	yosys -p "synth_ice40 -edif top_ice40.edif -blif top_ice40.blif -json top_ice40.json" top.v `cat verilog.includes | grep -v "^#" | tr '\012' ' '` 

ecp5:
	@echo "Generating ECP5 files"
	yosys -p "synth_ecp5 -edif top_ecp5.edif -blif top_ecp5.blif -json top_ecp5.json" top.v `cat verilog.includes | grep -v "^#" | tr '\012' ' '` 
