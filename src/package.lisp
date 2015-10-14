(cl:in-package #:cl-user)

(defpackage #:vfile-tree
  (:use #:cl #:vfile)
  (:import-from #:path-string
		#:*sep*
                #:basename
		#:dirname)
  (:import-from #:uiop
		#:directory-files
                #:directory-exists-p
		#:subdirectories)
  (:export #:vfile-node
	   #:vfile-directory-node
	   #:vfile-directory-p
	   #:vfile-children
	   #:traverse-filesystem
           #:make-vfile-tree))
