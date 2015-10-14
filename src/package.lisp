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
           #:vfile-directory-open
           #:traverse-filesystem
           #:make-vfile-tree))
