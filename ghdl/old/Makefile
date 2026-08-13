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

# list all VHDL source files here
VHDL =	 uart_new.vhd uart_tx.vhd uart_bus.vhd uart_bus_tb.vhd

all: uart_bus_tb.ghw

view: uart_bus_tb_view

uart_bus_tb.ghw: analyze.ready
	$(GHDLE) uart_bus_tb
# NOTE:  stop time after 20us
	$(GHDLR) uart_bus_tb --stop-time=20us --wave=uart_bus_tb.ghw

uart_bus_tb_view: uart_bus_tb.ghw uart_bus_tb.tcl analyze.ready
	$(GTKWAVE) uart_bus_tb.ghw -S uart_bus_tb.tcl

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
