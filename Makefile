default:
	@echo "The following Targets are available:"
	@echo "vcd    - create the vcd output using iverilog and suitable test bench"
	@echo "xc6    - Generate Xilinx Spartan6"
	@echo "ice40  - Lattice ICE40"
	@echo "ecp5   - Lattice ECP5"

clean:
	rm -rf *.json *.blif *.edif *.out *.vcd *.values
	rm -rf ice40 ecp5 
	@ls -l

vcd:
	@echo "Generating the VDD executable script from Verilog files"
	iverilog -Wall -o top.out top.v top_tb.v \
		`cat verilog.includes | grep -v "^#" | tr '\012' ' '`
	@echo "Running the top.out file to generate gtkwave file."
	./top.out

view: vcd
	@WW=`grep "^#" top_tb.vcd | tail -1 | wc -c`
	vcdcat top_tb.vcd > top_tb.values
	./vcdcat_clean_view.py top_tb.values

xc6:
	#     -family {xcup|xcu|xc7|xc6s}
	@echo "Generating Spartan6 files"
	yosys -p "synth_xilinx -family xc6s -edif top.edif -blif top.blif" top.v \
		`cat verilog.includes | grep -v "^#" | tr '\012' ' '` 

ice40:
	@echo "Generating ICE40 files"
	@mkdir -p ice40
	@yosys -p "synth_ice40 -edif ice40/top_ice40.edif -blif ice40/top_ice40.blif -json ice40/top_ice40.json" top.v `cat verilog.includes | grep -v "^#" | tr '\012' ' '` 

ecp5:
	@echo "Generating ECP5 files"
	@mkdir -p ecp5
	@yosys -p "synth_ecp5 -edif ecp5/top_ecp5.edif -blif ecp5/top_ecp5.blif -json ecp5/top_ecp5.json" top.v `cat verilog.includes | grep -v "^#" | tr '\012' ' '` 
