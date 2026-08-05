;;; init-java.el --- java language configuration -*- lexical-binding: t; -*-

;;; Commentary:
;;; java-specific language support

;;; Code:

;; java lsp support
(use-package lsp-java
  :after lsp-mode

  :config
  (add-hook 'java-mode-hook #'lsp))

;; debugging support
(use-package dap-mode
  :after lsp-mode

  :config
  (dap-auto-configure-mode)
  ;; debugger navigation
  (defun better-locals ()
    "Update locals view and return to previous window."
    (interactive)
    (dap-ui-locals)
    (other-window -1))

  (global-set-key (kbd "M-n") #'dap-next)
  (global-set-key (kbd "M-j") #'better-locals))

;; lsp project tree integration
(use-package lsp-treemacs
  :after lsp)

(provide 'init-java)
;;; init-java.el ends here
