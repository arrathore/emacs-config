;;; early-init.el --- early initialization tasks

;; disable package.el at startup
(setq package-enable-at-startup nil)

;; speed up startup
(setq gc-cons-threshold most-positive-fixnum)

;;; early-init.el ends here
