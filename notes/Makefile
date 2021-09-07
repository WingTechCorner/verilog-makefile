help:
	@echo "Makefile to create Xilinx bit file"
	@echo " - xst "
	@echo " - ngd "
	@echo " - map "
	@echo " - par "
	@echo " - trace "
	@echo " - bit "
	@echo " - all (all of the above)"

xst:
	mkdir -p build/xst/tmp
	xst -intstyle ise -ifn top.xst -ofn build/top.syr
ngd:
	mkdir -p build/xst/tmp
	ngdbuild -intstyle ise -dd _ngo -nt timestamp -i -p xc6slx9-tqg144-2 build/top.ngc build/top.ngd
map:
	mkdir -p build/xst/tmp
	map -intstyle ise -p xc6slx9-tqg144-2 -w -logic_opt off -ol high -t 1 -xt 0 -register_duplication off -r 4 -global_opt off -mt off -ir off -pr off -lc off -power off -o build/top_map.ncd build/top.ngd build/top.pcf 
par:
	mkdir -p build/xst/tmp
	par -w -intstyle ise -ol high -mt off build/top_map.ncd build/top.ncd build/top.pcf
trace:
	mkdir -p build/xst/tmp
	trce -intstyle ise -v 3 -s 3 -n 3 -fastpaths -xml build/top.twx build/top.ncd -o build/top.twr build/top.pcf 
bit:
	mkdir -p build/xst/tmp
	bitgen -w -l -intstyle ise  build/top.ncd build/top.bit build/top.pcf

clean:
	rm -rf build
	mkdir -p build/xst/tmp

all: xst ngd map par trace bit
