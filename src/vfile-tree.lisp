(cl:in-package :vfile-tree)

(defclass vfile-node (vfile)
  ((%directory-p
    :initarg :directory-p
    :accessor vfile-directory-p
    :initform nil)))

(defclass vfile-directory-node (vfile-node)
  ((%directory-p
    :initarg :directory-p
    :accessor vfile-directory-p
    :initform t)
   (%children
     :initarg :children
     :accessor vfile-children
     :initform nil)))

(defmethod vfile-open ((n vfile-directory-node) &rest rest)
    (apply #'make-concatenated-stream
	   (loop for node in (vfile-children n)
	      collect (apply #'vfile-open node rest))))

(defun traverse-filesystem (path file-lambda directory-lambda &key (recurse-p t) hidden-p)
  (let* ((directory-p (directory-exists-p path))
         (path (cond
                 ((not directory-p) path)
                 ((char= (aref path (1- (length path))) *sep*) path)
                 (t (format nil "~A~C" path *sep*)))))
    (flet ((make-subfile-list (path subfile-func)
             (loop for file in (funcall subfile-func path)
		   for filename = (namestring file)
                   if (char= (aref (basename filename) 0) #\.)
                   if hidden-p
                   collect (traverse-filesystem filename file-lambda directory-lambda :recurse-p recurse-p :hidden-p hidden-p)
                   end else
                   collect (traverse-filesystem filename file-lambda directory-lambda :recurse-p recurse-p :hidden-p hidden-p))))
      (cond
	((not directory-p)
	 (funcall file-lambda path))
	((not recurse-p)
	 (funcall directory-lambda
		  path
		  (make-subfile-list path #'directory-files)))
	(t
	 (funcall directory-lambda
		  path
		  (append
		   (make-subfile-list path #'directory-files)
		   (make-subfile-list path #'subdirectories))))))))

(defun make-vfile-tree (path &key (base (dirname path)) (recurse-p t) hidden-p)
  (traverse-filesystem path
		       (lambda (file)
			 (make-instance 'vfile-node
					:base base
					:path file
					:contents (pathname file)))
		       (lambda (directory subfiles)
			 (make-instance 'vfile-directory-node
					:base base
					:path directory
					:contents (pathname directory)
					:children subfiles))
		       :recurse-p recurse-p
		       :hidden-p hidden-p))
