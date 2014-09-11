(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp"
                                       (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(with-output-to-string (*standard-output*)
 (ql:quickload "do"))

(defun debug-ignore (c h) (declare (ignore h)) (print c) (abort))

(defun main ()
  (setf *debugger-hook* #'debug-ignore)
  (let ((cli-args
          #+sbcl sb-ext:*posix-argv*
          #+clisp ext:*args*
          #-(or sbcl clisp) (progn (error "Unsupported platform") nil)))
    (do:main cli-args)))

#+sbcl (sb-ext:save-lisp-and-die "todo" :executable t :toplevel 'main)
#+clisp (main)
#-(or sbcl clisp) (error "Unsupported platform")
