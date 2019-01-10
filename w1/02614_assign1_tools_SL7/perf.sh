#!/bin/bash

timestamp=`date +"%T"`

COMPILER_OPTIONS=(O0 O1 O2 O3 Os Og Ofast)

FUNC=(knm nkm kmn)

mkdir "${timestamp}"
for f in "${FUNC}"; do
	mkdir ${timestamp}/${f}
	for c in "${COMPILER_OPTIONS[@]}"; do
		mkdir ${timestamp}/${f}/${c}
		for i in `seq 100 20 2000`;do
			make clean
			COMPILER_OPTIONS=-$c make
			./matmult_c.gcc ${f} $i $i $i >>${timestamp}/${f}/${c}/${i}.txt 2>&1
		done
	done
done