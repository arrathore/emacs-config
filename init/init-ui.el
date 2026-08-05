;;; init-ui.el --- user interface configuration -*- lexical-binding: t; -*-

;;; Commentary:
;;; visual appearance and general emacs UI behavior

;;; Code:

;; start maximized
(add-to-list 'default-frame-alist
	     '(fullscreen . maximized))

;; window navigation
(windmove-default-keybindings)

;; ace-window
(add-to-list 'load-path
	     (expand-file-name "ace-window/" user-emacs-directory))
(load "ace-window.el")

(global-set-key (kbd "M-o") #'ace-window)

;; transparency
(set-frame-parameter (selected-frame)
		     'alpha
		     '(85 85))

(add-to-list 'default-frame-alist
	     '(alpha 85 85))

;; line numbers
(global-display-line-numbers-mode)

;; tab bar
(tab-bar-mode 1)

;; battery display
(add-to-list 'tab-bar-format
	     'tab-bar-format-align-right
	     'append)

(add-to-list 'tab-bar-format
	     'tab-bar-format-global
	     'append)

(display-battery-mode)

;; clock display
(add-to-list 'tab-bar-format
	     'tab-bar-format-align-right
	     'append)

(add-to-list 'tab-bar-format
	     'tab-bar-format-global
	     'append)

(setq display-time-format "%a %b %d %I:%M:%S %p")
(setq display-time-interval 1)

;; (display-time-mode)

;; comfirm before exiting
(setq confirm-kill-emacs 'y-or-n-p)

(provide 'init-ui)
;;; init-ui.el ends here
