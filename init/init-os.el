;;; init-os.el --- operating system specific configuration -*- lexical-binding: t; -*-

;;; Commentary:
;;; OS-specific settings and integration

;;; Code:

;;; OS detection
(defconst *is-a-mac*
     (eq system-type 'darwin)
     "Non-nil when running on macOS.")

(defconst *is-a-linux*
  (eq system-type 'gnu/linux)
  "Non-nil when running on Linux.")

;; macOS configuration
(when *is-a-mac*

  ;; use standard macOS modifier behavior
  (setq mac-option-modifier 'meta)
  (setq mac-command-modifier 'super)

  ;; make macOS shortcuts work
  (global-set-key (kbd "s-c") #'kill-ring-save)
  (global-set-key (kbd "s-v") #'yank)
  (global-set-key (kbd "s-x") #'kill-region)
  (global-set-key (kbd "s-a") #'mark-whole-buffer)

  ;; use native macOS input method
  (setq default-input-method "MacOSX")
  
  ;; default shell
  (setq explicit-shell-file-name "/bin/bash"))

;; linux configuration
(when *is-a-linux*
  (setq x-super-keysym 'meta))


(provide 'init-os)
;;; init-os.el ends here
