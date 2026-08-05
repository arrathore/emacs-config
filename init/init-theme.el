;;; init-theme.el --- theme and appearance configuration -*- lexical-binding: t; -*-

;;; Commentary:
;;; theme loading, custom theme paths, and splash screen config

;;; Code:

;; additional theme directories
(add-to-list 'custom-theme-load-path
	     "~/.emacs.d/themes/")

(add-to-list 'custom-theme-load-path
	     "~/.emacs.d/themes/custom")

;; theme packages
(use-package ef-themes
  :config
  (load-theme 'ef-melissa-light t))

(use-package circadian
  :after ef-themes
  
  :config
  (setq circadian-themes
	'(("5:00" . ef-melissa-light)
	  ("18:00" . ef-melissa-dark)))

  (circadian-setup))

;; custom splash screen
(load "~/.emacs.d/custom-splash.el")

(provide 'init-theme)
;;; init-theme.el ends here

