(cl:in-package #:asdf-user)

(defsystem :vfile-tree
  :version "0.1.0"
  :description "A hierarchical virtual file"
  :author "Cayman Nava"
  :license "MIT"
  :depends-on (:path-string :vfile :uiop)
  :components ((:module "src"
        :serial t
		:components
		((:file "package")
		 (:file "vfile-tree"))))
  :long-description #.(uiop:read-file-string
		       (uiop:subpathname *load-pathname* "README.md"))
  :in-order-to ((test-op (test-op vfile-tree-test))))
		 
