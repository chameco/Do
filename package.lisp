(defpackage :do
  (:use :cl :cl-ppcre :getopt)
  (:export :print-section
           :add-line
           :flush-changes
           :plist->sections
           :sections->plist
           :parse-file
           :slurp-file
           :main))
