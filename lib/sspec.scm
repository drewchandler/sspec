(define (assert x . args)
  (let ((message (if (null? args)
                   "Expected value to be truthy"
                   (car args))))
    (if (not x)
      (fail message))))

(define (fail message)
  (error message))

(define (restart-if-spec-fails thunk)
  (bind-condition-handler '()
   (lambda (condition)
     (invoke-restart (find-restart 'spec) (condition/report-string condition)))
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
    (restart-if-spec-fails (run-spec (lambda ()
      (body)
      (display "PASSES")
      (newline))))))
