;;; init.el --- main configuration -*- lexical-binding: t; -*-

;;; Commentary:
;;; main init file, calls all other modules

;;; Code:

;; add to configuration directory
(add-to-list 'load-path
	     (expand-file-name "init" user-emacs-directory))
(add-to-list 'load-path
	     (expand-file-name "init/langs" user-emacs-directory))

;; keep Customize separate
(setq custom-file
      (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

;; load modules
(require 'init-packages)
(require 'init-os)
(require 'init-theme)
(require 'init-ui)
(require 'init-editor)
(require 'init-keybinds)
(require 'init-completion)
(require 'init-programming)
(require 'init-org)

(setq gc-cons-threshold (* 50 1000 1000))

;; open a term if no file is given
(setq inhibit-splash-screen t)
(when (null command-line-args-left)
  (term shell-file-name))

;;; init.el ends here
