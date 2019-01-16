CC  := gcc
C_FLAGS := -Wall -Wextra

MY_FLAGS := 1 2 3

BIN  := bin
SRC  := src
INCLUDE := include
LIB  := lib

EXECUTABLE := main

all: $(BIN)/$(EXECUTABLE)

clean:
	-$(RM) $(BIN)/$(EXECUTABLE)

run: all
	#./$(BIN)/$(EXECUTABLE)
	$(THREAD_FLAGS) ./$(BIN)/$(EXECUTABLE)

$(BIN)/$(EXECUTABLE): $(SRC)/*
	$(CC) $(C_FLAGS) -I$(INCLUDE) -L$(LIB) $^ -o $@ $(SUNOPTS) $(OMP_FLAGS)
