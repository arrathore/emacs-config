;;; splash-screen.el --- An alternative splash screen -*- lexical-binding: t; -*-

;; Copyright (C) 2020 Nicolas .P Rougier

;; Author: Nicolas P. Rougier <nicolas.rougier@inria.fr>
;; URL: https://github.com/rougier/emacs-splash
;; Keywords: startup
;; Version: 0.1
;; Package-Requires: 

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;;  An alternative splash screen:
;;
;;  +–—————————––––––––––––––––––––––––––––————————————————————+
;;  |                                                          |
;;  |                                                          |
;;  |                                                          |
;;  |                                                          |
;;  |                                                          |
;;  |                                                          |
;;  |                       www.gnu.org                        |
;;  |                  GNU Emacs version XX.Y                  |
;;  |                   a free/libre editor                    |
;;  |                                                          |
;;  |                                                          |
;;  |                                                          |
;;  |                                                          |
;;  |                                                          |
;;  |        GNU Emacs comes with ABSOLUTELY NO WARRANTY       |
;;  |     Copyright (C) 2020 Free Software Foundation, Inc.    |
;;  |                                                          |
;;  +––––––––––––––––––––––––––––––––––––––————————————————————+
;;
;; Features:
;;
;;  - No logo, no moddeline, no scrollbars
;;  - "q" or <esc> kills the splash screen
;;  - Any other key open the about-emacs buffer
;;  - With emacs-mac (Mituharu), splash screen is faded out after 3 seconds
;;
;; Note: The screen is not shown if there are opened file buffers. For
;;       example, if you start emacs with a filename on the command
;;       line, the splash is not shown.
;;
;; Usage:
;; 
;;  (require 'splash-screen)
;;
;;; Code:
(require 'cl-lib)


(defun splash-screen ()
  "Emacs splash screen"
  
  (interactive)
  (let* ((splash-buffer  (get-buffer-create "*splash*"))
         (recover-session (and auto-save-list-file-prefix
                               (file-directory-p (file-name-directory
                                                  auto-save-list-file-prefix))))
         (height         (- (window-body-height nil) 1))
         (width          (window-body-width nil))
         (padding-center (- (/ height 2) 1))
         (padding-bottom (- height (/ height 2) 3)))

    ;; If there are buffer associated with filenames,
    ;;  we don't show splash screen.
    (if (eq 0 (length (cl-loop for buf in (buffer-list)
                              if (buffer-file-name buf)
                              collect (buffer-file-name buf))))
        
        (with-current-buffer splash-buffer
          (erase-buffer)
          
          ;; Buffer local settings
          (if (one-window-p)
              (setq mode-line-format nil))
          (setq cursor-type nil)
          (setq vertical-scroll-bar nil)
          (setq horizontal-scroll-bar nil)
          (setq fill-column width)
          (face-remap-add-relative 'link :underline nil)
	  
          ;; Vertical padding to center
          (insert-char ?\n padding-center)

          ;; Central text
	  
          (insert-text-button " www.gnu.org "
                     'action (lambda (_) (browse-url "https://www.gnu.org"))
                     'help-echo "Visit www.gnu.org website"
                     'follow-link t)
          (center-line) (insert "\n")
	  	  

          (insert (concat
                   (propertize "GNU Emacs"  'face 'bold)
                   " " "version "
                   (format "%d.%d" emacs-major-version emacs-minor-version)))
          (center-line) (insert "\n")
          (insert (propertize "A free/libre editor" 'face 'shadow))
          (center-line)


          ;; Vertical padding to bottom
          (insert-char ?\n padding-bottom)

          ;; Recover session button
          (when recover-session
            (delete-char -2)
            (insert-text-button " [Recover session] "
                 'action (lambda (_) (call-interactively 'recover-session))
                   'help-echo "Recover previous session"
                   'face 'warning
                   'follow-link t)
            (center-line) (insert "\n") (insert "\n"))

          ;; Copyright text
          (insert (propertize
                   "GNU Emacs comes with ABSOLUTELY NO WARRANTY" 'face 'shadow))
          (center-line) (insert "\n")
          (insert (propertize
                   "Copyright (C) 2020 Free Software Foundation, Inc." 'face 'shadow))
          (center-line) (insert "\n")

          (goto-char 0)
          (read-only-mode t)
          
          (local-set-key [t]               'splash-screen-fade-to-about)
          (local-set-key (kbd "C-[")       'splash-screen-fade-to-default)
          (local-set-key (kbd "<escape>")  'splash-screen-fade-to-default)
          (local-set-key (kbd "q")         'splash-screen-fade-to-default)
          (local-set-key (kbd "<mouse-1>") 'mouse-set-point)
          (local-set-key (kbd "<mouse-2>") 'operate-this-button)
          ;; (local-set-key " "               'splash-screen-fade-to-default)
          ;; (local-set-key "x"               'splash-screen-fade-to-default)
          ;; (local-set-key (kbd "<RET>")     'splash-screen-fade-to-default)
           ;; (local-set-key (kbd "<return>")  'splash-screen-fade-to-default)
          (display-buffer-same-window splash-buffer nil)
          (run-with-idle-timer 10.0 nil    'splash-screen-fade-to-about)))))


;; Mac animation, only available from
;;  https://bitbucket.org/mituharu/emacs-mac/src/master/
;;  https://github.com/railwaycat/homebrew-emacsmacport
(defvar mac-animation-locked-p nil)
(defun mac-animation-toggle-lock ()
  (setq mac-animation-locked-p (not mac-animation-locked-p)))
(defun mac-animation-fade-out (duration &rest args)
  (unless mac-animation-locked-p
    (mac-animation-toggle-lock)
    (mac-start-animation nil :type 'fade-out :duration duration)
    (run-with-timer duration nil 'mac-animation-toggle-lock)))

(defun splash-screen-fade-to (about duration)
  "Fade out current frame for duration and goes to command-or-bufffer"
  (interactive)
  (defalias 'mac-animation-fade-out-local
    (apply-partially 'mac-animation-fade-out duration))
  (if (get-buffer "*splash*")
      (progn (if (and (display-graphic-p) (fboundp 'mac-start-animation))
                 (advice-add 'set-window-buffer
                             :before 'mac-animation-fade-out-local))
             (if about (about-emacs))
             (kill-buffer "*splash*")
             (if (and (display-graphic-p) (fboundp 'mac-start-animation))
                 (advice-remove 'set-window-buffer
                                'mac-animation-fade-out-local)))))
(defun splash-screen-fade-to-about ()
  (interactive) (splash-screen-fade-to 1 1.0))
(defun splash-screen-fade-to-default ()
  (interactive) (splash-screen-fade-to nil 0.25))

(defun splash-screen-kill ()
  "Kill the splash screen buffer (immediately)."
  (interactive)
  (if (get-buffer "*splash*")
        (kill-buffer "*splash*")))

;; Suppress any startup message in the echo area
(run-with-idle-timer 0.05 nil (lambda() (message nil)))

;; Install hook after frame parameters have been applied and only if
;; no option on the command line
(if (and (not (member "-no-splash"  command-line-args))
         (not (member "--file"      command-line-args))
         (not (member "--insert"    command-line-args))
         (not (member "--find-file" command-line-args))
         (not inhibit-startup-screen)
         )
    (progn
      (add-hook 'window-setup-hook 'splash-screen)
      (setq inhibit-startup-screen t 
            inhibit-startup-message t
            inhibit-startup-echo-area-message t)))

(provide 'splash-screen)
;;; splash-screen.el ends here

