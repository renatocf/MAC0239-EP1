# Directories
BIN := $(shell pwd)/bin
LIB := $(shell pwd)/lib
MINISAT := $(LIB)/minisat

# Commands
CP   := cp -p
MV   := mv 
RM   := rm -f
MAKE += MROOT=$(MINISAT) --no-print-directory

all: $(BIN)/minisat

$(BIN)/minisat: $(MINISAT)
	@ $(MAKE) -C $(MINISAT)/core
	@ $(CP) $(MINISAT)/core/minisat $(BIN)

clean:
	rm -f $(BIN)/minisat
	@ $(MAKE) -C $(MINISAT)/core clean 
