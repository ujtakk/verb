VERBOSE   = 0
SIMULATOR = vsim
MODULE    = top
TARGET    = test/test_$(MODULE).v.erb
INCLUDE   =

LINK_DIR  = .
DIST      = ../dist

include Makefile.dep
include ../utils/VERBMakefile

.PHONY: file test clean log

file: $(TARGET:.v.erb=.com)
test: $(TARGET:.v.erb=.log)

clean: clean-common

log:
	@$(EDITOR) $(TARGET:.v.erb=.log)

com:
	@$(EDITOR) $(TARGET:.v.erb=.com)

define DEP_IN
## -*- text -*-
## ignore list

ignore_file {
}

ignore_com {
}
endef
export DEP_IN
