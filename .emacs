(require 'package)
(setq warning-minimum-level :emergency)

;; macro for updating lists in place
(defmacro append-to-list (target suffix)
  "Append SUFFIX to TARGET in place."
  `(setq ,target (append ,target ,suffix)))

;; set up emacs package archives with 'package
(append-to-list package-archives
		'(("melpa" . "http://melpa.org/packages/") ;; main package archive
		  ("melpa-stable" . "http://stable.melpa.org/packages/") ;; some packages might only do stable releases?
		  ("org-elpa" . "https://orgmode.org/elpa/"))) ;; org packages

(package-initialize)

;; ensure use-package is present. from here on out, all packages are loaded
;; with use-package, a macro for importing and install packages. also, refresh the package archive on load so we can pull the latest packages.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq
 use-package-always-ensure t ;; makes sure to download new packages if they aren't alraedy downloaded
 use-package-verbose t) ;; package install logging. packages break, it's nice to know why

;; slurp environment variables from the shell
(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("0325a6b5eea7e5febae709dab35ec8648908af12cf2d2b569bedc8da0a3a81c1" default))
 '(package-selected-packages '(doom-themes exec-path-from-shell)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; (use-package doom-themes
;;  :init
;;  (load-theme 'doom-horizon t))

 (use-package ef-themes
   :init
   (load-theme 'ef-melissa-light t))

;; (load-theme 'tao-theme-yang t)

;; (load-theme 'poet t)

;; (add-hook 'text-mode-hook
;; 	  (lambda ()
;; 	    (variable-pitch-mode 1)))

;; (set-face-attribute 'default nil :family "DejaVu Sans Mono" :height 130)
;; (set-face-attribute 'fixed-pitch nil :family "DejaVu Sans Mono")
;; (set-face-attribute 'variable-pitch nil :family "IBM Plex Serif")

;; custom splash screen
(load "~/.emacs.d/custom-splash.el")

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
	"straight/repos/straight.el/bootstrap.el"
	(or (bound-and-true-p straight-base-dir)
	    user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
	 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;;(use-package splash-screen
;;  :straight (:host github :repo "rougier/emacs-splash"))

;;(require 'splash-screen)

;; any customize-based settings should live in custom.el, not here
(setq custom-file "~/.emacs.d/custom.el") ;; without this emacs will dump generated custom settings in this file
(load custom-file 'noerror)

;;; OS specific config
(defconst *is-a-mac* (eq system-type 'darwin))
(defconst *is-a-linux* (eq system-type 'gnu/linux))

;; mac ux improvements
(when *is-a-mac*
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier nil)
  (setq default-input-method "MacOSX"))

;; linux improvements
(when *is-a-linux*
  (setq x-super-keysym 'meta))

;; fullscreen by default, as early as possible
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; make M-x and other mini-buffers sortable, filterable
(use-package ivy
  :init
  (ivy-mode 1)
  (setq ivy-height 15
	ivy-use-virtual-buffers t
	ivy-use-selectable-prompt t))

(use-package counsel
  :after ivy
  :init
  (counsel-mode 1)
  :bind (:map ivy-minibuffer-map))

(windmove-default-keybindings)

;; window manager
(add-to-list 'load-path "~/.emacs.d/ace-window/")
(load "ace-window.el")
(global-set-key (kbd "M-o") 'ace-window)

;; project management
(use-package projectile
  :init
  (projectile-mode t) ;; enable immediately
  :config
  (setq projectile-enable-caching t ;; better performance on large projects
	projectile-completion-system 'ivy)) ;; ideally the minibuffer should look similar

;; counsel and projectile should work together
(use-package counsel-projectile
  :init
  (counsel-projectile-mode))

;; directory tree ui that works with projectile
(use-package treemacs-projectile)

;; view csv files
;; (use-package csv-mode)
;; ;; different colors for different columns
;; (require 'color)
;; (defun csv-highlight (&optional separator)
;;   (interactive (list (when current-prefix-arg (read-char "Separator: "))))
;;   (font-lock-mode 1)
;;   (let* ((separator (or separator ?\.))
;; 	 (n (count-matches (string separator) (pos-bol) (pos-eol)))
;; 	 (colors (cl-loop for i from 0 to 1.0 by (/ 2.0 n)
;; 			  collect (apply #'color-rgb-to-hex
;; 					 (color-hsl-to-rgb i 0.3 0.5)))))
;;     (cl-loop for i from 2 to n by 2
;; 	     for c in colors
;; 	     for r = (format "^\\([^%c\n]+%c\\)\\{%d\\}" separator separator i)
;; 	     do (font-lock-add-keywords nil `((,r (1 '(face (:foreground ,c)))))))))
;; (add-hook 'csv-mode-hook 'csv-highlight)
;; (add-hook 'csv-mode-hook 'csv-align-mode)
;; (add-hook 'csv-mode-hook #(lambda () (interactive) (toggle-truncate-lines nil))))

  

(use-package company
  :bind (("C-." . company-complete))
  :custom
  (company-idle-delay 0) ;; always use completion, no delay
  (company-deabbrev-downcase nil "Don't downcase returned candidates.")
  (company-show-numbers t "Numbers are helpful.")
  (company-tooltip-limit 10 "The more the merrier.")
  :config
  (global-company-mode) ;; we want completion everywhere

  ;; use numbers 0-9 to select company completion candidates
;;  (let ((map company-active-map))
;;    (mapc (lambda(x) (define-key map (format "%d" x)
;;				 `(lambda () (interactive) (company-complete-number ,x))))
  ;;	  (number-sequence 0 9)))
  )

;; flycheck is the newer version of flymake and is needed to make lsp-mode not freak out
(use-package flycheck
  :config
  (add-hook 'prog-mode-hook 'flycheck-mode) ;; always lint my code
  (add-hook 'after-init-hook #'global-flycheck-mode))

;; package for interacting with language servers
(use-package lsp-mode
  :commands lsp
  :config
  (setq lsp-prefer-flymake nil) ;; flymake is outdated
  (add-hook 'prog-mode-hook #'lsp))


;; texlab support via lsp
;;(add-to-list 'load-path "~/.emacs.d")
;;(require 'lsp-latex)
;; (setq lsp-latex-texlab-executable "~/.cargo/bin/texlab")

;; (with-eval-after-load "tex-mode"
;;   (add-hook 'tex-mode-hook 'lsp)
;;   (add-hook 'latex-mode'hook 'lsp))

;; ;; for YaTeX
;; (with-eval-after-load "yatex"
;;   (add-hook 'yatex-mode-hook 'lsp))

;; ;; for bibtex
;; (with-eval-after-load "bibtex"
;;   (add-hook 'bibtex-mode-hook 'lsp))

;; java support via lsp
(use-package lsp-java
  :after lsp-mode
  :config
  (add-hook 'java-mode-hook #'lsp))

;; lsp ui for better visuals
(use-package lsp-ui
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable t
	lsp-ui-doc-position 'bottom
	lsp-ui-sideline-enable t))

;; debugging support for java
(use-package dap-mode
  :after lsp-mode
  :config
  (dap-auto-configure-mode))

(defun better-locals ()
  "update locals and go back"
  (interactive)
  (dap-ui-locals)
  (other-window -1))

(global-set-key (kbd "M-n") 'dap-next)
(global-set-key (kbd "M-]") 'better-locals)

;; extra java functionalities
(use-package lsp-treemacs
  :after lsp)

;; slime
(setq inferior-lisp-program "sbcl")

;; -- common lisp SLIME --
;; install packages
;; (dolist (package '(slime paredit rainbow-delimiters))
;;   (unless (package-installed-p package)
;;     (package-install package)))

;; ;; configure sbcl as the lisp program for SLIME
;; (add-to-list 'exec-path "/usr/local/bin")
;; (setq inferior-lisp-program "sbcl")



;; cosmetics

;; show line numbers
(global-display-line-numbers-mode)

;; show tab bar
(tab-bar-mode 1)

;; show battery in tab bar
(add-to-list 'tab-bar-format 'tab-bar-format-align-right 'append)
(add-to-list 'tab-bar-format 'tab-bar-format-global 'append)
(display-battery-mode)

;; show time in tab bar
(add-to-list 'tab-bar-format 'tab-bar-format-align-right 'append)
(add-to-list 'tab-bar-format 'tab-bar-format-global 'append)
(setq display-time-format "%a %b %d %I:%M:%S %p")
(setq display-time-interval 1) ;; update every second
(display-time-mode)

;; mail settings
;; load mu4e from the installation path

;; (use-package mu4e
;;   :load-path "/usr/local/share/emacs/site-lisp/mu/mu4e/")

;; ;; for sending mails
;; (require 'smtpmail)

;; ;; install with port
;; (setq mu4e-mu-binary (executable-find "mu"))

;; ;; mail directory
;; (setq mu4e-maildir "~/.maildir")

;; ;; command called to sync imap servers
;; (setq mu4e-get-mail-command (concat (executable-find "mbsync") " -a"))
;; ;; how often to sync in seconds
;; (setq mu4e-update-interval 300)

;; ;; save attachment to desktop by default
;; (setq mu4e-attachment-dir "~/Desktop")

;; ;; rename files when moving - needed for mbsync
;; (setq mu4e-change-filenames-when-moving t)

;; ;; list of email addresses
;; (setq mu4e-user-mail-address-list '("apoorav.rathore@icloud.com")
;;       )

;; ;; shortcuts
;; (setq mu4e-maildir-shortcuts
;;       '(("/icloud/INBOX" . ?i)
;; 	("/icloud/Sent Messages" . ?I)))

;; ;; bookmarks
;; (add-to-list 'mu4e-bookmarks
;; 	     (make-mu4e-bookmark
;; 	      :name "Inbox - iCloud"
;; 	      :query "maildir:/icloud/INBOX"
;; 	      :key ?i))

;; ;; contexts
;; (setq mu4e-contexts
;;       `(,(make-mu4e-context
;; 	  :name "icloud"
;; 	  :enter-func
;; 	  (lambda () (mu4e-message "Enter apoorav.rathore@icloud.com context"))
;; 	  :leave-func
;; 	  (lambda () (mu4e-message "Leave apoorav.rathore@icloud.com context"))
;; 	  :match-func
;; 	  (lambda (msg)
;; 	    (when msg
;; 	      (mu4e-message-contact-field-matches msg
;; 						  :to "dummy@icloud.com")))
;; 	  :vars '((user-mail-address . "apoorav.rathore@icloud.com" )
;; 		  (user-full-name . "Apoorav Rathore")
;; 		  (mu4e-drafts-folder . "/icloud/Drafts")
;; 		  (mu4e-refile-folder . "/icloud/Archive")
;; 		  (mu4e-sent-folder . "/icloud/Sent Messages")
;; 		  (mu4e-trash-folder . "/icloud/Deleted Messages")))

;; 	))

;; (setq mu4e-context-policy 'pick-first) ;; start with the first (default) context
;; (setq mu4e-compose-context-policy 'ask) ;; ask for context if no context matches

;; ;; gpg encryption & decryption
;; (require 'epa-file)
;; (epa-file-enable)
;; (setq epa-pinetry-mode 'loopback)
;; (auth-source-forget-all-cached)

;; ;; don't keep message compose buffers around after sending
;; (setq message-kill-buffer-on-exit t)

;; ;; send function
;; (setq send-mail-function 'sendmail-send-it
;;       message-send-mail-function 'sendmail-send-it)

;; ;; send program
;; (setq sendmail-program (executable-find "msmtp"))

;; ;; select the right sender email from the context
;; (setq message-sendmail-envelope-from 'header)

;; ;; choose from account before sending
;; ;; custom function
;; (defun timu/set-msmtp-account ()
;;   (if (message-mail-p)
;;       (save-excursion
;; 	(let*
;; 	    ((from (save-restriction
;; 		     (message-narrow-to-headers)
;; 		     (message-fetch-field "from")))
;; 	     (account
;; 	      (cond
;; 	       ((string-match "apoorav.rathore@icloud.com" from) "icloud")
;; 	       )
;; 	      (setq message-sendmail-extra arguments (list '"-a" account))))))))

;; (add-hook 'message-send-mail-hook 'timu/set-msmtp-account)

;; ;; mu4e cc & bcc
;; ;; custom function
;; (add-hook 'mu4e-compose-mode-hook
;; 	  (defun timu/add-cc-and-bcc ()
;; 	    "My Function to automatically add Cc & Bcc: headers.
;; This is in the mu4e compose mode."
;; 	    (save-excursion (message-add-header "Cc:\n"))
;; 	    (save-excursion (message-add-header "Bcc:\n"))))

;; (add-hook 'mu4e-compose-mode-hook 'company-mode)

;; ;; optional
;; ;; store link to message if in header view, not to header query
;; (setq org-mu4e-link-query-in-headers-mode nil)
;; ;; don't have to confirm when quitting
;; ;; (setq mu4e-confirm-quit nil)
;; ;; number of visible headers in horizontal split view
;; (setq mu4e-headers-visible-lines 20)
;; ;; don't show threading by default
;; ;; (setq mu4e-headers-show-threads nil)
;; ;; hide retreiving mail msg in minibuffer
;; ;; (setq mu4e-hide-index-messagse t)
;; ;; cusotmize reply-quote-string
;; (setq message-citation-line-format "%N @ %Y=%m-%d %H:%M :\n")
;; ;; M-x find-function RET message-citation-line-format for docs
;; (setq message-citation-line-function 'message-insert-formatted-citation-line)
;; ;; by default do not show related emails
;; ;; (setq mu4e-headers-include-related nil)
