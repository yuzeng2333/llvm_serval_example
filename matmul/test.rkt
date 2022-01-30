#lang rosette/safe

(require
  serval/lib/core
  serval/lib/unittest
  (only-in racket/base parameterize exn:fail?)
  (prefix-in llvm: serval/llvm)
  (prefix-in rust: "o/serval_example.globals.rkt")
  (prefix-in rust: "o/serval_example.map.rkt")
  (prefix-in rust: "o/serval_example.ll.rkt")
)

(define (assert-always c)
  (check-unsat? (solve (assert (not c))))
)

; Takes a optional second argument which received the counter-example
(define (assert-not-always c [cex-sink void])
  (define cex (solve (assert (not c))))
  (check-sat? cex)
  (cex-sink cex)
)

(define (display-cex cex)
  (display (format "Counter example:\n~a\n" cex))
)



(define (check-and-int)
  (parameterize ([llvm:current-machine (llvm:make-machine rust:symbols rust:globals)])

    ; manual tests
    ;(display (format "~a\n" (rust:@and_int (bv #x1 8) (bv #x2 8) (bv #x3 8))))
    ;(display (format "~a\n" (car (rust:@and_int (bv #x1 8) (bv #x2 8) (bv #x3 8)))))
    ;(display (format "~a\n" (cadr (rust:@and_int (bv #x1 8) (bv #x2 8) (bv #x3 8)))))

    ; symbolic inputs
    (define-symbolic a (bitvector 32))
    (define-symbolic b (bitvector 32))

    ; symbolic result
    (define r (rust:@and_int a b))

    (assert-always ((bitvector 32) r))

    ; prove correctness
    (assert-always (eq? r (bvand a b)))
))



(define (check-and-int-buggy)
  (parameterize ([llvm:current-machine (llvm:make-machine rust:symbols rust:globals)])

    ; manual tests
    ;(display (format "~a\n" (rust:@and_int_buggy (bv #x13 8) (bv #x37 8) (bv #x0 8))))

    ; symbolic inputs
    (define-symbolic a (bitvector 32))
    (define-symbolic b (bitvector 32))

    ; symbolic result
    (define r (rust:@and_int_buggy a b))

    (assert-always ((bitvector 32) r))


    ; prove that there is a bug
    (assert-always (eq? r (bvand a b))
      ; Uncomment to see the generated counter-example
      ;display-cex
    )

    ; prove that the bug is a || b == 0x1337
    (define (assert-bug-is-1337 cex)
      (assert (eq? (cex a) (bv #x13 32)))
      (assert (eq? (cex b) (bv #x37 32)))
    )
    (assert-not-always (eq? r (bvand a b)) assert-bug-is-1337)

    ; prove that these is only one bug
    (assert-always
      (implies
        (not (or (eq? a (bv #x13 32)) (eq? b (bv #x37 32))))
        (eq? r (bvand a b))
      )
    )

))



(define rust-tests
  (test-suite+
   "Tests for serval-example"
    (test-case+ "and_int test" (check-and-int))
    (test-case+ "and_int_buggy test" (check-and-int-buggy))
  ))

(module+ test
  (time (run-tests rust-tests)))
