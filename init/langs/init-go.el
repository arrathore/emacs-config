;;; init-go.el --- golang configuration -*- lexical-binding: t; -*-

;;; Commentary:
;;; golang specific support

;;; Code:

(use-package go-ts-mode
  :ensure nil ; Built-in package
  :mode "\\.go\\'"
  :hook (go-ts-mode . eglot-ensure)
  :config
  ;; Run gofmt/goimports before saving
  (add-hook 'before-save-hook #'eglot-format-buffer nil t))

(provide 'init-go)
;;; init-go.el ends here
