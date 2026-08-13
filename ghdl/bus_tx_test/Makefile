#
# build and run a GHDL simulation
#

# run GHDL
GHDLRUN = /usr/bin/ghdl
GTKWAVE = /usr/bin/gtkwave

GHDLOPT = --ieee=synopsys --std=08
GHDLA = $(GHDLRUN) -a $(GHDLOPT)
GHDLE = $(GHDLRUN) -e $(GHDLOPT)
GHDLR = $(GHDLRUN) -r $(GHDLOPT)

# list all VHDL source files here, order is important!
# (testbench should go last)
VHDL = uart_tx.vhd uart_bus_tx.vhd tb.vhd

STOP = 750us

all: tb.ghw

view: tb_view

tb.ghw: analyze.ready
	$(GHDLE) tb
# NOTE:  stop time after 20us
	$(GHDLR) tb --stop-time=$(STOP) --wave=tb.ghw

tb_view: tb.ghw tb.tcl analyze.ready
	$(GTKWAVE) tb.ghw -S tb.tcl

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
