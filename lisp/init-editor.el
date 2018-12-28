;; init-editor.el --- Editor Configurations	-*- lexical-binding: t -*-

;; Author: Zsxh Chen <bnbvbchen@gmail.com>
;; URL: https://github.com/zsxh/emacs.d

;;; Commentary:
;;
;;  Editor Configurations
;;

;;; Code:

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; Miscs
;; (setq initial-scratch-message nil)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets) ; Show path if names are same
(setq adaptive-fill-regexp "[ t]+|[ t]*([0-9]+.|*+)[ t]*")
(setq adaptive-fill-first-line-regexp "^* *$")
(setq delete-by-moving-to-trash t)         ; Deleting files go to OS's trash folder
(setq make-backup-files nil)               ; Forbide to make backup files
(setq set-mark-command-repeat-pop t)       ; Repeating C-SPC after popping mark pops it again
(setq-default kill-whole-line t)           ; Kill line including '\n'
(fset 'yes-or-no-p 'y-or-n-p)
;; (setq auto-save-default nil)               ; Disable default auto save
(setq frame-title-format "emacs@%b")       ; Show buffer name in title

(setq sentence-end "\\([。！？]\\|……\\|[.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*")
(setq sentence-end-double-space nil)
;; auth-sources
(setq epg-pinentry-mode 'loopback)
;; (setq epa-file-select-keys 0)
;; ask encryption password once
;; (setq epa-file-cache-passphrase-for-symmetric-encryption t)
;; (epa-file-enable)
(add-hook 'kill-emacs-hook (lambda () (shell-command "pkill gpg-agent")))

(setq read-file-name-completion-ignore-case t) ; file ignores case

(setq-default truncate-lines t)

;; Tab and Space
;; Permanently indent with spaces, never with TABs
(setq-default c-basic-offset   2
              tab-width        2
              indent-tabs-mode nil)

;; Automatically reload files was modified by external program
(use-package autorevert
  :ensure nil
  :hook (after-init . global-auto-revert-mode))

;; An all-in-one comment command to rule them all
(use-package comment-dwim-2
  :ensure t
  :bind ("M-;" . comment-dwim-2))

;; A comprehensive visual interface to diff & patch
(use-package ediff
  :ensure nil
  :commands ediff
  :config
  (setq ediff-window-setup-function 'ediff-setup-windows-plain)
  (setq ediff-split-window-function 'split-window-horizontally)
  (setq ediff-merge-split-window-function 'split-window-horizontally))

;; automatic parenthesis pairing for non prog mode
(use-package elec-pair
  :ensure nil
  :hook (after-init . electric-pair-mode))

;; Increase selected region by semantic units
(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))

(setq mouse-drag-copy-region t)

;; Framework for mode-specific buffer indexes
(use-package imenu-list
  :ensure t
  :commands imenu-list-smart-toggle
  :init
  (progn
    (setq imenu-list-focus-after-activation t
          imenu-list-auto-resize t)))

;; Easy way to jump/swap window
(use-package ace-window
  :ensure t
  :bind (("C-u" . ace-window))
  :commands (ace-window ace-swap-window))

;; Treat undo history as a tree
(use-package undo-tree
  :ensure t
  :hook (after-init . global-undo-tree-mode))

;; Numbered window shortcuts
(use-package winum
  :ensure t
  :hook (after-init . winum-mode))

;; Use package auto-save instead of default auto save
(use-package auto-save
  :quelpa ((auto-save :fetcher github :repo "manateelazycat/auto-save"))
  :init (setq auto-save-default nil)
  :config
  (auto-save-enable)
  (setq auto-save-slient t)
  (dolist (hook (list 'prog-mode-hook 'yaml-mode-hook))
    (add-hook hook (lambda () (setq-local auto-save-delete-trailing-whitespace t)))))

;; It allows you to select and edit matches interactively
(use-package evil-multiedit
  :ensure t
  :commands evil-multiedit-toggle-marker-here)

;; jumping to visible text using a char-based decision tree
(use-package avy
  :ensure t
  :bind (("C-c c" . avy-goto-char)
         ("C-c j" . avy-goto-char-in-line)
         ("C-c l" . avy-goto-line)
         ("C-c w" . avy-goto-word-1)
         ("C-c e" . avy-goto-word-0))
  :config (setq avy-style 'pre))

;; inserting numeric ranges
;; https://oremacs.com/2014/12/26/the-little-package-that-could/
(use-package tiny
  :ensure t
  :commands tiny-expand
  :config (tiny-setup-default))

;; look through everything you've killed
(use-package browse-kill-ring
  :ensure t
  :bind (("M-C-y" . browse-kill-ring)
         :map browse-kill-ring-mode-map
         ("j" . browse-kill-ring-forward)
         ("k" . browse-kill-ring-previous))
  :config
  (setq browse-kill-ring-highlight-current-entry t)
  (setq browse-kill-ring-highlight-inserted-item t))

;; fuzzy complete/search engine
(use-package flx
  :ensure t)

;; Emacs ripgrep plugin
(use-package color-rg
  :commands (color-rg-search-input color-rg-search-project)
  :quelpa ((color-rg :fetcher github :repo "manateelazycat/color-rg")))

;; M-<up> move-line-up
;; M-<down> move-line-down
;; Dont try moving region in evil normal state, use V DD P instead
(use-package move-dup
  :ensure t
  :hook (emacs-startup . global-move-dup-mode))

(use-package popwin
  :ensure t)


(provide 'init-editor)

;;; init-editor.el ends here
