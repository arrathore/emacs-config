;;; init-nix.el --- nix lang configuration *-* lexical-binding: t; -*-

;;; Commentary:
;;; nix-specific language support

;;; Code:

(use-package nix-ts-mode
  :ensure t
  :mode "\\.nix\\'"
  :init

  (setq treesit-font-lock-level 4))

(provide 'init-nix)
;;; init-nix.el ends here
