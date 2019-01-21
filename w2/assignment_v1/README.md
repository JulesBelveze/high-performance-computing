# README

## Folder structure

The current directory contains 3 folders:

- src: all the source code
- bin: includes the executable program
- visualization: bash scripts and python tools to visualize and manipulate data

## How to run the program

- run `make`
- run `bin/jacob_gauss.gcc`

The program excepts the following parameters:

- 1st parameter: version to run. Supported versions [0,1,2,4,5,6,8] (explanation of each version bellow)
- 2nd parameter: matrix size
- 3rd parameter: maximum number of iterations
- 4th parameter: threshold

### Versions of the program

- 0: Serial jacobi
- 1: Serial gauss
- 2: Naive parallel jacobi
- 4: Parallel version 1 jacobi
- 5: Parallel version 2 jacobi
- 6: Parallel version 3 jacobi
- 8: Parallel version 4 jacobi
