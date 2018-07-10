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

@route GET "/pidor2"
(lambda (&key |name|)
  (format t "Something as ~A~%" |name|)
  (render #P"pidor.html"))


;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
