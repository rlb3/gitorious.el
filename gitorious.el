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

(defmacro gitorious-with-auth (&rest body)
  `(let* ((url-request-extra-headers `(("Accept" . "text/xml")
                                       ("Authorization" . ,(concat "Basic "
                                                                   (base64-encode-string
                                                                    (concat gitorious-user ":" gitorious-pass)))))))
     (labels ((retrieve (&rest args) (apply 'url-retrieve args))
              (default-callback (status) (switch-to-buffer (current-buffer))))
       ,@body)))

(gitorious-with-auth
 (retrieve "http://www.example.net" 'default-callback))







