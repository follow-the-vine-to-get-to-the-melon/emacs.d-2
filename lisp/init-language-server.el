;; init-language-server.el --- language-server Configurations	-*- lexical-binding: t -*-

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
;;  language-server Configurations
;;

;;; Code:

;;;;;;;;;;;;;; Eglot ;;;;;;;;;;;;;;

(use-package eglot
  :ensure t
  :commands eglot-ensure
  :hook ((sh-mode . eglot-ensure)
         ;; ((js-mode typescript-mode) . eglot-ensure)
         (go-mode . eglot-ensure)))

;; Experimental
;; TODO: Move to init-go.el
(use-package go-mode
  :ensure t
  :init
  (add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))
  :commands go-mode)

;;;;;;;;;;;;;; Lsp-mode ;;;;;;;;;;;;;;

;; Lsp do not support temporary buffer yet
;; https://github.com/emacs-lsp/lsp-mode/issues/377
(use-package lsp-mode
  :quelpa ((lsp-mode :fetcher github :repo "emacs-lsp/lsp-mode"))
  :commands lsp
  :config
  (require 'lsp-clients)
  (setq lsp-auto-guess-root t
        lsp-prefer-flymake nil
        lsp-inhibit-message t
        lsp-eldoc-render-all nil
        lsp-keep-workspace-alive nil))

;; TODO: check out what lsp--auto-configure have done
;; (use-package company-lsp
;;   :after (company lsp)
;;   :ensure t
;;   :config
;;   (setq company-lsp-enable-snippet t
;;         company-lsp-cache-candidates nil
;;         company-transformers nil
;;         company-lsp-async t
;;         company-lsp-enable-recompletion t))

(use-package lsp-ui
  :after lsp
  :ensure t
  ;; disable lsp-ui doc and sideline
  :preface (setq lsp-ui-doc-enable nil
                 lsp-ui-sideline-enable nil)
  :bind (:map lsp-ui-peek-mode-map
              ("j" . lsp-ui-peek--select-next)
              ("k" . lsp-ui-peek--select-prev)
              ("C-j" . lsp-ui-peek--select-next)
              ("C-k" . lsp-ui-peek--select-prev))
  :config
  (setq lsp-ui-sideline-show-symbol t
        lsp-ui-sideline-show-hover t
        lsp-ui-sideline-show-code-actions t
        lsp-ui-sideline-update-mode 'point
        lsp-ui-sideline-ignore-duplicate t)
  (set-face-foreground 'lsp-ui-sideline-code-action "#FF8C00"))

;; Debug Adapter Protocol for Emacs
(use-package dap-mode
  :after lsp
  :ensure t
  :config
  (dap-mode t)
  (dap-ui-mode t)
  (add-hook 'dap-ui-repl-mode-hook
            (lambda ()
              (setq-local company-minimum-prefix-length 0))))

;; add minor mode(keybindings) for lsp debug
(with-eval-after-load 'dap-mode
  (defvar +dap/debug-mode-map
    (let ((map (make-sparse-keymap)))
      (define-key map (kbd "n") 'dap-next)
      (define-key map (kbd "s") 'dap-step-in)
      (define-key map (kbd "o") 'dap-step-out)
      (define-key map (kbd "b") 'dap-breakpoint-toggle)
      (define-key map (kbd "B") 'dap-breakpoint-condition)
      (define-key map (kbd "c") 'dap-continue)
      (define-key map (kbd "C") 'dap-disconnect)
      map)
    "my dap mode debug keybindings")

  (define-minor-mode +dap/debug-mode
    "A minor mode for dap debug key settings."
    :init-value nil
    :keymap +dap/debug-mode-map)

  (define-global-minor-mode global-dap/debug-mode +dap/debug-mode
    (lambda ()
      (when (memq major-mode '(java-mode python-mode))
        (+dap/debug-mode))))

  (with-eval-after-load 'evil
    (defun +dap/evil-debug-key-settings ()
      (evil-define-key 'normal +dap/debug-mode-map
        "n" 'dap-next
        "s" 'dap-step-in
        "o" 'dap-step-out
        "b" 'dap-breakpoint-toggle
        "B" 'dap-breakpoint-condition
        "c" 'dap-continue
        "C" 'dap-disconnect))
    (add-hook '+dap/debug-mode-hook #'+dap/evil-debug-key-settings))

  (defun +dap/debug-mode-disable (&optional args)
    (when +dap/debug-mode
      (global-dap/debug-mode -1)
      (message "+dap/debug mode disabled")))

  (defun +dap/debug-mode-enable (&optional args)
    (unless +dap/debug-mode
      (global-dap/debug-mode)
      ;; `evil-define-key' for minor mode does not take effect until a state transition
      ;; Issue: https://github.com/emacs-evil/evil/issues/301
      (when (and (featurep 'evil) evil-mode)
        (if (eq evil-state 'normal)
            (progn
              (evil-change-state 'emacs)
              (evil-change-state 'normal))
          (progn
            (let ((cur-state evil-state))
              (evil-change-state 'normal)
              (evil-change-state cur-state)))))
      (message "+dap/debug mode enabled")))

  ;; Manual toggle
  (defun +dap/debug-key-settings--toggle ()
    (interactive)
    (if +dap/debug-mode
        (+dap/debug-mode-disable)
      (+dap/debug-mode-enable)))

  ;; Auto toggle
  (add-hook 'dap-session-created-hook #'+dap/debug-mode-enable)
  (add-hook 'dap-terminated-hook #'+dap/debug-mode-disable))


(provide 'init-language-server)

;;; init-language-server.el ends here
