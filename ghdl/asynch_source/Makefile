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

BENCH = uart_tb_test

# list all VHDL source files here, order is important!
# (testbench should go last)
VHDL =	 uart_tb_pkg.vhd uart_tb_test.vhd

STOP = 1000us

all: $(BENCH).ghw

view: $(BENCH)_view

$(BENCH).ghw: analyze.ready
	$(GHDLE) $(BENCH)
# NOTE:  stop time after 20us
	$(GHDLR) $(BENCH) --stop-time=$(STOP) --wave=$(BENCH).ghw

$(BENCH)_view: $(BENCH).ghw $(BENCH).tcl analyze.ready
	$(GTKWAVE) $(BENCH).ghw -S $(BENCH).tcl

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
