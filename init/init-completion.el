;;; init-completion.el --- completion framework config -*- lexical-binding: t; -*-

;;; Commentary:
;;; interactive completion and in-buffer completion

;;; Code:

;; interactive completion
 (use-package ivy
   :init
   (ivy-mode 1)

   :custom
   (ivy-height 15)
   (ivy-use-virtual-buffers t)
   (ivy-use-selectable-prompt t)
   (ivy-wrap t))

(use-package ivy-rich
  :ensure t
  :after ivy
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :ensure t
  :after ivy
  :bind
  (("M-x" . counsel-M-x)
   ("C-x C-f" . counsel-find-file)
   ("C-x b" . counsel-switch-buffer)
   ("M-y" . counsel-yank-pop))
  :config
  (counsel-mode 1))

 ;; in-buffer completion
 (use-package company
   :bind
   (("C-." . company-complete))
   
   :custom
   (company-minimum-prefix-length 1)
   (company-idle-delay 0.1)
   (company-deabbrev-downcase nil) ;; don't downcase returned candidates
   (company-show-numbers t)
   (company-tooltip-limit 10)
   
   :config
   (global-company-mode)

   ;; use numbers 0-9 to select company completion candidates
   (setq company-show-quick-access t))



(provide 'init-completion)
;;; init-completion.el ends here
