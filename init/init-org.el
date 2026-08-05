;;; init-org.el --- org mode configuration -*- lexical-binding: t; -*-

;;; Commentary:
;;; org mode enhancements and workflow configuration

;;; Code:

;; org list behvaior
(use-package org-autolist
  :hook
  (org-mode . org-autolist-mode))

;; open file links in current window
(defun mda/org-open-current-window ()
  "Open Org link in the current window."
  (interactive)
  (let ((org-link-frame-setup
	 (cons '(file . find-file)
	       org-link-frame-setup)))
    (org-open-at-point)))

(add-hook 'org-mode-hook
	  (lambda ()
	    (local-set-key (kbd "C-c RET")
			   #'mda/org-open-current-window)))

;; automatically update parent TODO states
(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, otherwise TODO."
  (let (org-log-done
	org-todo-log-states)
    (org-todo (if (= n-not-done 0)
		  "DONE"
		"TODO"))))

(add-hook 'org-after-todo-statistics-hook
	  #'org-summary-todo)

;; org indentation
(add-hook 'org-mode-hook
	  #'org-indent-mode)

(provide 'init-org)
;;; init-org.el ends here
