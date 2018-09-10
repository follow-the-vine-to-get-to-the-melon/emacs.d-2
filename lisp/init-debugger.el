;; init-debugger.el --- Debugger Settings	-*- lexical-binding: t -*-

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
;;  Debugger Settings
;;

;;; Code:

;; Debug/edebug evil keybindings
(with-eval-after-load 'evil-collection
  (with-eval-after-load 'debug
    (evil-collection-init 'debug)
    (evil-define-key 'normal debugger-mode-map (kbd "<return>") 'backtrace-help-follow-symbol))
  (with-eval-after-load 'edebug
    (evil-collection-init 'edebug)))

;; Realgud Configs
(use-package realgud
  :ensure t
  :commands (realgud:gdb realgud:ipdb realgud:jdb)
  :config
  (with-eval-after-load 'evil-collection
    (evil-collection-init 'realgud)))

;; dap-mode



(provide 'init-debugger)

;;; init-debugger.el ends here
