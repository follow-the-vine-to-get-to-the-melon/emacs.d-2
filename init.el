;; init.el --- init Emacs	-*- lexical-binding: t -*-

;; Copyright (C) 2018 Zsxh Chen

;; Author: Zsxh Chen <bnbvbchen@gmail.com>
;; URL: https://github.com/zsxh/emacs.d

;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or
;; (at your option) any later version.
;; ;; This program is distributed in the hope that it will be useful,;; but WITHOUT ANY WARRANTY; without even the implied warranty of
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
;;  intel.el
;;

;;; Code:

(setq debug-on-error t)

;; Emacs Version
(let ((minver "25.1"))
  (when (version< emacs-version minver)
    (error "Your Emacs is too old. This config requires v%s or higher" minver)))
(when (version< emacs-version "26.1")
  (message "Your Emacs is old, and some funcitonality in this config will be disabled. Please upgrade if possible."))

;; Speedup Boostrap
;; Adjust garbage collection thresholds during startup, and thereafter
(let ((normal-gc-cons-threshold (* 20 1024 1024))
      (init-gc-cons-threshold (* 128 1024 1024)))
  (setq gc-cons-threshold init-gc-cons-threshold)
  (add-hook 'after-init-hook (lambda ()
                               (setq gc-cons-threshold normal-gc-cons-threshold))))

;; Load Path
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "site-lisp" user-emacs-directory))
;; (add-to-list 'load-path (expand-file-name "experimental/emacs-application-framework" user-emacs-directory))

;; Package Configuations
(require 'init-package)

;; UI
(require 'init-ui)

;; Emacs environment
(require 'init-exec-path)

;; Load custom functions
(require 'init-funcs)

;; KeyBinding
(require 'init-evil)
(require 'init-keybinding)

;; Feature
(require 'init-dired)
(require 'init-ibuffer)
(require 'init-neotree)
(require 'init-org)

;; Completion in Emacs
(require 'init-ivy)

;; Programing
(require 'init-edit)
(require 'init-company)
(require 'init-yasnippet)
(require 'init-flycheck)
(require 'init-git)
(require 'init-highlight)
(require 'init-projectile)
;; (require 'init-lsp)

;; Language
(require 'init-python)
(require 'init-emacs-lisp)

;; Experimental
;; (require 'eaf)


(provide 'init)

;;; init.el ends here
