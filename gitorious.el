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


(let* ((gitorious-user "robert@example.net")
       (gitorious-pass "")
       (gitorious-host "www.example.net")
       (url-request-extra-headers '(("Accept" . "text/xml")))
       (callback (lambda (status)
                   (switch-to-buffer (current-buffer)))))
  (url-get-authentication (format "http://%s"  gitorious-host) nil "basic" t)
  (url-retrieve (concat "http://" gitorious-host)  callback))


