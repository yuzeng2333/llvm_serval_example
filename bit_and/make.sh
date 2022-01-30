rm -rf o
mkdir -p o
clang -S -emit-llvm src/lib.c -o o/serval_example.ll
clang src/lib.c -o o/serval_example.o

echo "\tSERVAL-DWARF o/serval_example.o"
echo "#lang reader serval/lang/dwarf" > o/serval_example.globals.rkt~
objdump --dwarf=info o/serval_example.o >> o/serval_example.globals.rkt~
mv o/serval_example.globals.rkt~ o/serval_example.globals.rkt

echo "\tSERVAL-NM o/serval_example.o"
echo "#lang reader serval/lang/nm" > o/serval_example.map.rkt~
nm --print-size --numeric-sort o/serval_example.o >> o/serval_example.map.rkt~
mv o/serval_example.map.rkt~ o/serval_example.map.rkt

echo "\tSERVAL-LLVM o/serval_example.ll"
racket serval-llvm.rkt < o/serval_example.ll > o/serval_example.ll.rkt~
mv o/serval_example.ll.rkt~ o/serval_example.ll.rkt

echo "\tTEST test.rkt"
raco test test.rkt
