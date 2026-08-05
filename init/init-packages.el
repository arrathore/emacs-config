;;; init-packages.el --- package management configuration -*- lexical-binding: t; -*-

;;; Commentary:
;;; handles package.el and use-package
;;; other configuration files should assume use-package is available

;;; Code:

(require 'package)

(setq warning-minimum-level :emergency)

;; package archives
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
	("melpa" . "https://melpa.org/packages/")
	("melpa-stable" . "https://stable.melpa.org/packages/")
	("org" . "https://orgmode.org/elpa")))
(package-initialize) ;; disabled in early-init

;; bootstrap use-package
(unless (package-installed-p 'use-package)
;;  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

(setq use-package-always-ensure nil
      use-package-verbose t)

;; import shell environment variables
;;(use-package exec-path-from-shell
;;  :config
;;  (exec-path-from-shell-initialize))

(provide 'init-packages)
;;; init-packages.el ends here
