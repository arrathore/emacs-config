;; init.el

;; silence byte-compilation warnings
(setq warning-minimum-level :emergency:)

;; setup package.el with melpa and others
(require 'package)
(setq package-archives
	'(("melpa" . "http://melpa.org/packages/")
	  ("melpa-stable" . "https://stable.melpa.org/packages/")
	  ("org-elpa" . "https://orgmode.org/elpa/")
	  ("gnu" . "https://elpa.gnu.org/packages/")))
  (package-initialize)

;; boostrap use-package if needed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; set up straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
	(expand-file-name "straight/repos/straight.el/bootstrap.el"
			  user-emacs-directory))
	(bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
	 'silent 'inhibit-cookies)
	(goto-char (point-max))
	(eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; delgate to .emacs
(load-file (expand-file-name "~/.emacs"))
