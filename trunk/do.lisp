(in-package :do)

(defvar *data* ())

(defun print-section (section)
  (let ((lines (getf *data* section)))
    (dolist (line lines) (format t "~a~%" line))))

(defun add-line (section line)
  (push line (getf *data* section)))

(defun flush-changes (path)
  (let ((file-contents (format nil "~{\@~a~%~a~%~}" (plist->sections *data*))))
    (with-open-file (stream path :direction :output :if-exists :supersede)
      (princ file-contents stream))))

(defun plist->sections (plist)
  (if plist
    (append (list (string-downcase (string (car plist))) (format nil "~{~A~^~%~}" (cadr plist))) (plist->sections (cddr plist)))
    '()))

(defun sections->plist (sections)
  (if sections
    (append (list (intern (string-upcase (remove-if-not #'alphanumericp (car sections))) :keyword) (split "\\n" (cadr sections))) (sections->plist (cddr sections)))
    '()))

(defun parse-file (file-contents)
  (let ((sections (split "(@\\w+\\n)" file-contents :with-registers-p t)))
    (setf *data* (sections->plist (cdr sections)))))

(defun slurp-file (path)
  (with-open-file (stream path :if-does-not-exist :create)
    (let ((data (make-string (file-length stream))))
      (read-sequence data stream)
      data)))

(defun main (argv)
  (multiple-value-bind (args alist) (getopt argv
                                            '(("a" :optional)
                                              ("f" :optional)
                                              ("l" :optional)
                                              ("s" :optional)))
   (let ((section (or (cdr (assoc "s" alist :test #'string=)) "default"))
         (path (or (cdr (assoc "f" alist :test #'string=)) "todo.txt")))
     (parse-file (slurp-file path))
     (when (cdr (assoc "a" alist :test #'string=))
       (add-line (intern (string-upcase (remove-if-not #'alphanumericp section)) :keyword) (format nil " -- ~a" (cdr (assoc "a" alist :test #'string=))))
       (flush-changes path))
     (when (assoc "l" alist :test #'string=)
       (format t "@~a~%" section)
       (print-section (intern (string-upcase (remove-if-not #'alphanumericp section)) :keyword))))))
