#
# build and run a GHDL simulation
#

# run GHDL
GHDLRUN = /usr/bin/ghdl
GTKWAVE = /usr/bin/gtkwave

GHDLOPT = --ieee=synopsys
GHDLA = $(GHDLRUN) -a $(GHDLOPT)
GHDLE = $(GHDLRUN) -e $(GHDLOPT)
GHDLR = $(GHDLRUN) -r $(GHDLOPT)

# list all VHDL source files here, order is important!
# (testbench should go last)
VHDL =	 uart_tx.vhd  uart_new.vhd uart_tx_tb.vhd

STOP = 25us

all: uart_tx_tb.ghw

view: uart_tx_tb_view

uart_tx_tb.ghw: analyze.ready
	$(GHDLE) uart_tx_tb
# NOTE:  stop time after 20us
	$(GHDLR) uart_tx_tb --stop-time=$(STOP) --wave=uart_tx_tb.ghw

uart_tx_tb_view: uart_tx_tb.ghw uart_tx_tb.tcl analyze.ready
	$(GTKWAVE) uart_tx_tb.ghw -S uart_tx_tb.tcl

#---- don't touch ----
define analyze_VHDL
  $(GHDLA) $(1);
endef

analyze.ready: $(VHDL)
	rm -f work-obj93.cf
	$(foreach vf,$(VHDL), $(call analyze_VHDL, $(vf)))
	touch analyze.ready

clean:
	rm -f *~ *.cf *.vcd *.ghw *.db *.ready
