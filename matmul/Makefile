
# Debugging setup (run make V=1 for verbosity)
V ?= 0
ifeq ($(V),0)
Q = @
endif


CRATE = serval_example

test: build
	@echo "\tTEST test.rkt"
	$(Q)raco test test.rkt

build: o/$(CRATE).ll.rkt o/$(CRATE).globals.rkt o/$(CRATE).map.rkt

o/%.ll.rkt: o/%.ll
	$(Q)racket serval-llvm.rkt < $^ > $@~
	$(Q)mv $@~ $@

o/%.map.rkt: o/%.o
	@echo "\tSERVAL-NM $^"
	$(Q)echo "#lang reader serval/lang/nm" > $@~
	$(Q)nm --print-size --numeric-sort $^ >> $@~
	$(Q)mv $@~ $@

o/%.globals.rkt: o/%.o
	@echo "\tSERVAL-DWARF $^"
	$(Q)echo "#lang reader serval/lang/dwarf" > $@~
	$(Q)objdump --dwarf=info $^ >> $@~
	$(Q)mv $@~ $@

o/$(CRATE).o: $(shell find src -type f)
	clang $< -o o/$(CRATE).o

o/$(CRATE).ll: $(shell find src -type f)
	clang -S -emit-llvm $< -o o/$(CRATE).ll


# Directory for build artifacts
o:
	$(Q)mkdir -p o

clean:
	$(Q)rm -rf o
	$(Q)mkdir -p o

.PRECIOUS: o/%.o o/%.ll o/%.ll.rkt o/%.map.rkt o/%.globals.rkt
