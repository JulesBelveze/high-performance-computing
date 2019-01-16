CC		  := gcc
C_FLAGS := -Wall -Wextra -g -Ofast
EXECUTABLE	:= jacob_gauss.$(CC)

BIN  := bin
SRC  := src
INCLUDE := include
LIB  := lib

LIBRARIES	:=


all: $(BIN)/$(EXECUTABLE)

run: clean all
	./$(BIN)/$(EXECUTABLE)

$(BIN)/$(EXECUTABLE): $(SRC)/*.c
	$(CC) $(C_FLAGS) -I$(INCLUDE) -L$(LIB) $^  -o $@ $(LIBRARIES)

clean:
	-rm -r $(BIN)/*
