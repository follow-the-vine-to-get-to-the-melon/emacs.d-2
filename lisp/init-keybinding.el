;; init-keybinding.el --- KeyBindings	-*- lexical-binding: t -*-

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
;;  KeyBindings
;;

;;; Code:

(require 'init-funcs)

(use-package which-key
  :ensure t
  :config
  (which-key-mode)
  (which-key-setup-side-window-bottom))

;; Global keybinding
(use-package general
  :after evil-collection
  :ensure t
  :config
  (setq general-override-states '(insert
                                  emacs
                                  hybrid
                                  normal
                                  visual
                                  motion
                                  operator
                                  replace))
  (general-override-mode)
  (general-define-key
   :states '(normal visual motion emacs)
   :keymaps 'override
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "/"   '(counsel-rg :which-key "ripgrep")
   "TAB" '(evil-switch-to-windows-last-buffer :which-key "last buffer")
   "SPC" '(counsel-M-x :which-key "M-x")
   "'"   '(shell-pop :which-key "shell-pop")
   ";"   '(comment-dwim-2 :which-key "comment-line")
   "0"   '(neotree-show :which-key "neotree")
   "1"   '(winum-select-window-1 :which-key "select-window-1")
   "2"   '(winum-select-window-2 :which-key "select-window-2")
   "3"   '(winum-select-window-3 :which-key "select-window-3")
   "4"   '(winum-select-window-4 :which-key "select-window-4")
   ;; Buffers
   "b"   '(nil :which-key "buffer")
   "bb"  '(ibuffer :which-key "buffers list")
   "bd"  '(kill-current-buffer :which-key "kill-current-buffer")
   "bs"  `(,(zsxh/switch-to-buffer-or-create "*scratch*") :which-key "*scratch*")
   "bm"  `(,(zsxh/switch-to-buffer-or-create "*Messages*") :which-key "*Messages*")
   "bn"  '(zsxh/new-empty-buffer :which-key "empty-buffer")
   ;; Error Flycheck
   "e"   '(nil :which-key "error")
   "el"  '(flycheck-list-errors :which-key "flycheck-list-errors")
   "ev"  '(flycheck-verify-setup :which-key "flycheck-verify-setup")
   ;; Files
   "f"   '(nil :which-key "file")
   "ff"  '(counsel-find-file :which-key "find files")
   ;; Help
   "h"   '(nil :which-key "help")
   "hd"  '(nil :which-key "details")
   "hdm" '((lambda () (interactive) (describe-variable 'major-mode)) :which-key "major-mode")
   "hdn" '((lambda () (interactive) (describe-variable 'minor-mode-list)) :which-key "minor-mode-list")
   "hf"  '(helpful-callable :which-key "helpful-callable")
   "hk"  '(helpful-key :which-key "helpful-key")
   "hv"  '(helpful-variable :which-key "helpful-variable")
   "hp"  '(helpful-at-point :which-key "helpful-at-point")
   ;; Jump
   "j"   '(nil :which-key "jump")
   "jd"  '(dired-jump :which-key "dired-jump")
   "jc"  '(avy-goto-char :which-key "avy-goto-char")
   "jl"  '(avy-goto-line :which-key "avy-goto-line")
   "jw"  '(avy-goto-word-1 :which-key "avy-goto-word-1")
   "je"  '(avy-goto-word-0 :which-key "avy-goto-word-0")
   ;; Org
   "o"   '(nil :which-key "org")
   "oa"  '(org-agenda :which-key "org-agenda")
   "oc"  '(org-capture :which-key "org-capture")
   ;; Text
   "t"   '(nil :which-key "text")
   "tm"  '(evil-multiedit-toggle-marker-here :which-key "multiedit-marker")
   "ts"  '(hydra-zoom/body :which-key "scale")
   ;; Window
   "w"   '(nil :which-key "window")
   "wl"  '(windmove-right :which-key "move right")
   "wh"  '(windmove-left :which-key "move left")
   "wk"  '(windmove-up :which-key "move up")
   "wj"  '(windmove-down :which-key "move bottom")
   "w/"  '(split-window-right :which-key "split right")
   "w-"  '(split-window-below :which-key "split bottom")
   "wd"  '(delete-window :which-key "delete window")
   "wm"  '(delete-other-windows :which-key "max")
   "ws"  '(hydra-window-scale/body :which-key "scale")
   ;; Toggle
   "T"   '(nil :which-key "toggle")
   "Tl"  '(toggle-truncate-lines :which-key "truncate-lines")
   ;; Others
   "a"   '(nil :which-key "application")
   "g"   '(nil :which-key "git")
   "gs"  '(magit :which-key "magit")))

(use-package hydra
  :ensure t
  :config
  (defhydra hydra-zoom (:hint nil)
    "zoom"
    ("k" text-scale-increase "zoom-in" :color pink)
    ("j" text-scale-decrease "zoom-out" :color pink))
  (defhydra hydra-window-scale (:hint nil)
    "scale window"
    ("h" shrink-window-horizontally "shrink-window-horizontally" :color pink)
    ("l" enlarge-window-horizontally "enlarger-window-horizontally" :color pink)
    ("j" shrink-window "shrink-window" :color pink)
    ("k" enlarge-window "enlarge-window" :color pink)
    ("f" balance-windows "balance" :color pink)))

(provide 'init-keybinding)

;;; init-keybinding.el ends here
