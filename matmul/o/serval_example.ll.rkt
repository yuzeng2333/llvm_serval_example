; DO NOT MODIFY.
;
; This file was automatically generated.

#lang rosette

(provide (all-defined-out))

(require (prefix-in core: serval/lib/core)
         serval/llvm
         serval/ubsan)



(define (@and_int %0 %1)
; %2
  (define-label (%2) #:merge #f
    (set! %3 (alloca (core:mcell 4) #:align 4))
    (set! %4 (alloca (core:mcell 4) #:align 4))
    (set! %5 (alloca (core:mcell 4) #:align 4))
    (store %0 %3 (bitvector 32) #:align 4)
    (store %1 %4 (bitvector 32) #:align 4)
    (set! %6 (load %3 (bitvector 32) #:align 4))
    (set! %7 (load %4 (bitvector 32) #:align 4))
    (set! %8 (and %6 %7))
    (store %8 %5 (bitvector 32) #:align 4)
    (set! %9 (load %5 (bitvector 32) #:align 4))
    (ret %9))

  (define-value %3)
  (define-value %4)
  (define-value %5)
  (define-value %6)
  (define-value %7)
  (define-value %8)
  (define-value %9)
  (enter! %2))

(define (@and_int_buggy %0 %1)
; %2
  (define-label (%2) #:merge #f
    (set! %3 (alloca (core:mcell 4) #:align 4))
    (set! %4 (alloca (core:mcell 4) #:align 4))
    (set! %5 (alloca (core:mcell 4) #:align 4))
    (store %0 %3 (bitvector 32) #:align 4)
    (store %1 %4 (bitvector 32) #:align 4)
    (set! %6 (load %3 (bitvector 32) #:align 4))
    (set! %7 (icmp/eq %6 (bv #x00000013 32)))
    (br %7 %8 %14))

; %8
  (define-label (%8) #:merge #f
    (set! %9 (load %4 (bitvector 32) #:align 4))
    (set! %10 (icmp/eq %9 (bv #x00000037 32)))
    (br %10 %11 %14))

; %11
  (define-label (%11) #:merge #f
    (set! %12 (load %3 (bitvector 32) #:align 4))
    (set! %13 (sub %12 (bv #x00000001 32)))
    (store %13 %3 (bitvector 32) #:align 4)
    (br %14))

; %14
  (define-label (%14) #:merge #f
    (set! %15 (load %3 (bitvector 32) #:align 4))
    (set! %16 (load %4 (bitvector 32) #:align 4))
    (set! %17 (and %15 %16))
    (store %17 %5 (bitvector 32) #:align 4)
    (set! %18 (load %5 (bitvector 32) #:align 4))
    (ret %18))

  (define-value %3)
  (define-value %4)
  (define-value %5)
  (define-value %6)
  (define-value %7)
  (define-value %9)
  (define-value %10)
  (define-value %12)
  (define-value %13)
  (define-value %15)
  (define-value %16)
  (define-value %17)
  (define-value %18)
  (enter! %2))

(define (@main)
; %0
  (define-label (%0) #:merge #f
    (set! %1 (alloca (core:mcell 4) #:align 4))
    (store (bv #x00000000 32) %1 (bitvector 32) #:align 4)
    (set! %2 (call @and_int (bv #x00000001 32) (bv #x00000002 32)))
    (ret (bv #x00000000 32)))

  (define-value %1)
  (define-value %2)
  (enter! %0))
