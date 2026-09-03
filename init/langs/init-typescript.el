;;; init-typescript.el --- typescript programming configuration -*- lexical-binding: t -*-

;;; Commentary:
;;; TypeScript Web (React) config with lsp-mode, treesitter, tailwind, TSX
;;; https://www.ovistoica.com/blog/2024-7-05-modern-emacs-typescript-web-tsx-config

;;; Code:

;; user tree-sitter modes
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js-ts-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . tsx-ts-mode))

;; start lsp
(dolist (hook
	 '(typescript-ts-mode-hook
	   tsx-ts-mode-hook
	   js-ts-mode-hook))
  (add-hook hook #'lsp-deferred))

(defun my/install-treesit-grammars ()
  (interactive)

  (setq treesit-language-source-alist
        '((typescript . ("https://github.com/tree-sitter/tree-sitter-typescript"
                         "master"
                         "typescript/src"))
          (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript"
                  "master"
                  "tsx/src"))
          (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript"))
          (css . ("https://github.com/tree-sitter/tree-sitter-css"))
          (json . ("https://github.com/tree-sitter/tree-sitter-json"))))

  (dolist (lang '(typescript tsx javascript css json))
    (unless (treesit-language-available-p lang)
      (treesit-install-language-grammar lang))))

(provide 'init-typescript)
;;; init-typescript.el ends here
