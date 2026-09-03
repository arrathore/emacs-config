;;; init-programming.el --- general programming configuration -*- lexical-binding: t -*-

;;; Commentary:
;;; general programming language support
;;; language-specific config belongs in langs/

;;; Code:

;; syntax checking
(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode))

;; language server protocol
(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)

  :custom
  (lsp-prefer-flymake nil)
  (lsp-headerline-breadcrumb-enable t)
  (lsp-enable-snippet t)

  ;; performance
  (lsp-idle-delay 0.3)
  (lsp-log-io nil)
  (lsp-completion-provider :capf))

;; lsp ui enhancements
(use-package lsp-ui
  :after lsp-mode

  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-position 'bottom)
  (lsp-ui-sideline-enable t))

;; project tree integration
(use-package treemacs-projectile)

;; editor code assistant
(use-package eca
  :vc (:url "https://github.com/editor-code-assistant/eca-emacs" :rev :newest))

;; load language specific configs
(require 'init-java)
(require 'init-typescript)

(provide 'init-programming)
;;; init-programming.el ends here

