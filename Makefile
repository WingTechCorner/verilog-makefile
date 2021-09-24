default:
	@echo "The following Targets are available:"
	@echo "vcd    - create the vcd output using iverilog and suitable test bench"
	@echo "xc6    - Generate Xilinx Spartan6"
	@echo "ice40  - Lattice ICE40"
	@echo "ecp5   - Lattice ECP5"

clean:
	@rm -rf *.json *.blif *.edif *.out *.vcd *.values
	@rm -rf builds
	@mkdir -p builds libs tb_libs
	@ls -l

all: clean vcd xc6 ice40 ecp5

vcd:
	@echo "Generating the VDD executable script from Verilog files"
	@mkdir -p builds/vcd
	iverilog -Wall -o builds/vcd/top.out top.v top_tb.v libs/*.v tb_libs/*.v
	@echo "Running the top.out file to generate gtkwave file."
	@(cd builds/vcd; ./top.out)

view: vcd
	vcdcat builds/vcd/top_tb.vcd > builds/vcd/top_tb.values
	./scripts/vcdcat_clean_view.py builds/vcd/top_tb.values

ice40:
	@echo "Generating ICE40 files"
	@mkdir -p builds/ice40
	@yosys -p "synth_ice40 -edif builds/ice40/top_ice40.edif -blif builds/ice40/top_ice40.blif -json builds/ice40/top_ice40.json" top.v libs/*.v

ecp5:
	@echo "Generating ECP5 files"
	@mkdir -p builds/ecp5
	@yosys -p "synth_ecp5 -edif builds/ecp5/top_ecp5.edif -blif builds/ecp5/top_ecp5.blif -json builds/ecp5/top_ecp5.json" top.v libs/*.v
