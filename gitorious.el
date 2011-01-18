(eval-when-compile (require 'cl))
(require 'xml)
(require 'url)

(defgroup gitorious nil
  "Gitorious customization group"
  :group 'gitorious
  :prefix 'gitorious-)

(defcustom gitorious-user ""
  "Gitorious login user"
  :type 'string
  :group 'gitorious)

(defcustom gitorious-pass ""
  "Gitorious login password"
  :type 'string
  :group 'gitorious)

(defcustom gitorious-host ""
  "Gitorious server"
  :type 'string
  :group 'gitorious)

(defmacro gitorious (&rest body)
  `(let* ((url-request-extra-headers `(("Accept" . "text/xml")
                                       ("Authorization" . ,(concat "Basic "
                                                                   (base64-encode-string
                                                                    (concat gitorious-user ":" gitorious-pass)))))))
     (labels ((http-get (&rest args)
                        (apply 'url-retrieve args))
              (default-callback (status)
                (switch-to-buffer (current-buffer))))
       ,@body)))

(defun gitorious-make-query-string (params)
  (mapconcat
   (lambda (param)
     (concat (url-hexify-string (car param)) "="
             (url-hexify-string (cdr param))))
   params "&"))

(defun gitorious-request (url &optional callback params)
  (let ((url-request-data (when params (gitorious-make-query-string params))))
    (gitorious
     (http-get "https://www.example.net/cpanel-whm/cpanel-whm/merge_requests" (or callback 'default-callback params)))))


(gitorious-make-query-string '(("key1" . "val%ue1")
                               ("key2" . "value2")))
(gitorious
 (http-get "https://www.example.net/cpanel-whm/cpanel-whm/merge_requests" 'default-callback))

(gitorious-request "https://www.example.net/cpanel-whm/cpanel-whm/merge_requests")
(gitorious-request "https://www.example.net/cpanel-whm/cpanel-whm/merge_requests" nil '(("key1" . "val%ue1")
                                                                                                 ("key2" . "value2")))

