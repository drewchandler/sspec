sspec
=====

RSpec style framework for MIT Scheme


```scheme
(describe "SSpec"
  (it "asserts that a value is truthy" (lambda ()
    (assert #t)))

  (it "gets angry when your value is falsey" (lambda ()
    (assert #f)))

  (it "supports error messages" (lambda ()
    (assert #f "I AM A STABBING ROBOT")))

  (it "handles errors in specs" (lambda ()
    (donkey)))

  (it "can assert error messages" (lambda ()
    (assert-error (lambda () (error "my error message")) "my error message")))
)
```

```
$ sspec my_specs.scm
SSpec
  asserts that a value is truthy... PASSES
  gets angry when your value is falsey... FAILS - Expected value to be truthy
  supports error messages... FAILS - I AM A STABBING ROBOT
  handles errors in specs... FAILS - Unbound variable: donkey
```
