(in-package :cl-user)
(defpackage sites.web
  (:use :cl
        :caveman2
        :sites.config
        :sites.view
        :sites.db
        :datafly
        :sxql)
  (:export :*web*))
(in-package :sites.web)

;; for @route annotation
(syntax:use-syntax :annot)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)

;;
;; Routing rules

(defroute "/" ()
  (render #P"index.html"))

@route GET "/pidor/"
(lambda ()
  (render #P"pidor.html"))



@route GET "/test"
(lambda (&key |type|)
  (cond
    ((string= |type| "createTable")
     (with-connection (db)
       (execute
	(sql-compile
	 (create-table :admin
	     ((name :type 'text
		    :primary-key t)
					;(password :type 'string
					;:not-null t)
					;(type :type 'int ;0 content manager; 1 superadmin
					;	   :not-null nil
					;	   :default 0)
	      ))))))
    ((string= |type| "selectAll")
     (format nil "~A~%" (cadr (with-connection (db)
			  (retrieve-one
			   (select :*
			     (from :admin)))))))
    ((string= |type| "drop")
     (with-connection (db) (drop-table :admin :if-exists t)))
    ((string= |type| "insert")
     (with-connection (db)
       (execute
	(insert-into :admin
		      (set= :name "Антон")))))
    (t (format nil "type is ~A~%" |type|))
     )
  )

@route GET "/admin*"
(defun check-session ()
  ())

@route GET "/admin/"
(lambda ()
  (render #P"pidor.html"))




;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
