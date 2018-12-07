;; init-emacs-lisp.el --- Initialize Emacs Lisp Configurations	-*- lexical-binding: t -*-

;; Copyright (C) 2018 Zsxh Chen

;; Author: Zsxh Chen <bnbvbchen@gmail.com>
;; URL: https://github.com/zsxh/emacs.d

;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.
;;

;;; Commentary:
;;
;;  Emacs Lisp configurations
;;

;;; Code:

;; Emacs lisp mode
(use-package elisp-mode
  :ensure nil
  :bind (:map emacs-lisp-mode-map
              ("C-c C-z" . ielm)
              ("C-c C-c" . eval-defun)
              ("C-c C-b" . eval-buffer)
              ("C-c C-:" . pp-eval-expression)
              ("C-c C-d" . edebug-defun))
  :hook (emacs-lisp-mode . (lambda ()
                             (setq-local company-backends '((company-capf)))))
  :config
  (+funcs/set-leader-keys-for-major-mode
   (emacs-lisp-mode-map lisp-interaction-mode-map)
   "'" '(ielm :which-key "ielm")
   "e" '(nil :which-key "eval")
   "ed" '(eval-defun :which-key "eval-defun")
   "ep" '(pp-eval-expression :which-key "eval-expression")
   "ee" '(pp-eval-last-sexp :which-key "eval-last-sexp")
   "ej" '(eval-print-last-sexp :which-key "eval-print-last-sexp")
   "d" '(nil :which-key "debug")
   "df" '(edebug-defun :which-key "edebug-defun")
   "m" '(nil :which-key "macro")
   "mc" '(pp-macroexpand-last-sexp :which-key "macroexpand-last-sexp")
   "me" '(pp-macroexpand-expression :which-key "macroexpand-expression")
   "ms" '(macrostep-expand :which-key "macrostep-expand")
   "g" '(nil :which-key "goto")
   "gd" '(evil-goto-definition :which-key "goto-definition")))

;; Show function arglist or variable docstring
;; `global-eldoc-mode' is enabled by default.
(use-package eldoc
  :ensure nil
  :diminish eldoc-mode
  :hook ((emacs-lisp-mode . turn-on-eldoc-mode)
         (lisp-interaction-mode . turn-on-eldoc-mode)
         (lisp-mode . turn-on-eldoc-mode))
  ;; :config
  ;; ;; Whenever the listed commands are used, ElDoc will automatically refresh the minibuffer.
  ;; (eldoc-add-command
  ;;  'paredit-backward-delete
  ;;  'paredit-close-round)
  )

;; Interactive macro expander
(use-package macrostep
  :ensure t
  :bind (:map emacs-lisp-mode-map
              ("C-c e" . macrostep-expand)
              :map lisp-interaction-mode-map
              ("C-c e" . macrostep-expand))
  :config
  (with-eval-after-load 'evil
    (evil-define-minor-mode-key 'normal 'macrostep-mode
      "q" 'macrostep-collapse)))

;; Semantic code search for emacs lisp
(use-package elisp-refs
  :ensure t)

;; Set lisp-interaction-mode company-backends
(add-hook 'lisp-interaction-mode-hook
          #'(lambda () (setq-local company-backends '((company-capf)))))

(provide 'init-emacs-lisp)

;;; init-emacs-lisp.el ends here
