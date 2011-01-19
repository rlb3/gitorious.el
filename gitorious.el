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
     (http-get url (or callback 'default-callback params)))))

(defun xml-callback (status)
  (goto-char (point-min))
  (search-forward "<?xml")
  (let ((xml (gitorious-xml-cleanup (xml-parse-region (match-beginning 0) (point-max)))))
    (with-temp-buffer (get-buffer-create "*xml*"))
    (print xml (get-buffer-create "*xml*"))
    (switch-to-buffer (get-buffer-create "*xml*"))))

(defun gitorious-xml-cleanup (xml-list)
  (mapcar 'gitorious-xml-cleanup-node xml-list))

(defun gitorious-xml-cleanup-node (node)
  (apply 'list
         (xml-node-name node)
         (xml-node-attributes node)
         (let (new)
           (dolist (child (xml-node-children node))
             (if (stringp child)
                 (or (string-match "\\`[ \t\n]+\\'" child)
                     (push child new))
               (push (gitorious-xml-cleanup-node child) new)))
           (nreverse new))))


(gitorious-request "https://www.example.net/cpanel-whm/cpanel-whm/merge_requests" 'xml-callback)

;;; (gitorious-request "https://www.example.net/cpanel-whm/cpanel-whm/merge_requests" nil '(("key1" . "val%ue1")
;;;                                                                                                  ("key2" . "value2")))

