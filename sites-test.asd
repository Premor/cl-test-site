(defsystem "sites-test"
  :defsystem-depends-on ("prove-asdf")
  :author "Premor"
  :license ""
  :depends-on ("sites"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "sites"))))
  :description "Test system for sites"
  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
