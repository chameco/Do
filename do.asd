(defpackage :do-system (:use :cl :asdf))
(in-package :do-system)

(defsystem :do
  :description "do - simple todo lists"
  :version "0.1"
  :author "Samuel Breese <sbreese@xitol.net>"
  :components ((:file "package")
               (:file "do" :depends-on ("package")))
  :depends-on (:cl-ppcre :getopt))
