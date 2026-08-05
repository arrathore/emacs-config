;;; init-editor.el --- core editor behavior -*- lexical binding: t; -*-

;;; Commentary:
;;; general editing behavior and buffer settings

;;; Code:

(electric-pair-mode 1)

;; disable automatic backups and autosave
(setq auto-save-default nil)
(setq make-backup-files nil)

(provide 'init-editor)
;;; init-editor.el ends here
