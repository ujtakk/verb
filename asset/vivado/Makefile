IPTOP = top
BOARD = zedboard
APP   = hello

.PHONY: run sw hw zybo zedboard ip all clean

run:
	xsct run.tcl ${BOARD} ${APP}

all: clean ip ${BOARD} hw sw run

sw:
	xsct sw.tcl ${BOARD} ${APP}

hw:
	vivado -nojournal -nolog -mode batch -source hw.tcl -tclargs ${BOARD}

ip:
	vivado -nojournal -nolog -mode batch -source ip.tcl

zedboard:
	vivado -nojournal -nolog -mode batch -source zedboard.tcl

zybo:
	vivado -nojournal -nolog -mode batch -source zybo.tcl

clean:
	rm -rf ip zybo zedboard .Xil
	rm -f vivado*
	rm -f hs_err_pid*.log

