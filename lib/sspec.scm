(define (assert x . args)
  (let ((message (if (null? args)
                   "Expected value to be truthy"
                   (car args))))
    (if (not x)
      (fail message))))

(define (assert-error l expected-error)
  (restart-if-error (lambda ()
    (call-with-current-continuation
     (lambda (kappa)
       (with-restart
        'assert-error
        "This restart is named assert-error."
        (lambda (message)
          (if (string=? message "__NO_ERROR__")
            (fail "No error was thrown")
            (assert (string=? message expected-error) "Error messages do not match"))
          (kappa #f))
        #f
        (lambda () (l) (error "__NO_ERROR__")))))) 'assert-error))

(define (fail message)
  (error message))

(define (restart-if-error thunk restart)
  (bind-condition-handler '()
   (lambda (condition)
     (invoke-restart (find-restart restart) (condition/report-string condition)))
   thunk))

(define (run-spec thunk)
  (lambda ()
    (call-with-current-continuation
     (lambda (kappa)
       (with-restart
        'spec
        "This restart is named spec."
        (lambda (message)
          (display "FAILS - ")
          (display message)
          (newline)
          (kappa #f))
        #f
        thunk)))))

(define (describe description . specs)
  (display description)
  (newline)
  (for-each (lambda (spec) (spec)) specs))

(define (it description body)
  (lambda ()
    (display "  ")
    (display description)
    (display "... ")
    (restart-if-error (run-spec (lambda ()
      (body)
      (display "PASSES")
      (newline))) 'spec)))
