;; init-git.el --- Version Control Configuations	-*- lexical-binding: t -*-

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
;;  Version Control Configuations
;;

;;; Code:

(use-package magit
  :commands (magit magit-blame)
  :ensure t
  ;; :hook (magit-blame-mode . (lambda () (setq magit-blame--style
  ;;                                            '(headings (heading-format . "%H %-20a %C %s\n")))))
  :config
  (require 'evil-magit)
  (require 'general)
  (+funcs/define-major-key with-editor-mode-map
                           "c" '(with-editor-finish :which-key "with-editor-finish")
                           "k" '(with-editor-cancel :which-key "with-editor-cancel"))

  (evil-define-key 'normal magit-blame-mode-map
    "q" 'magit-blame-quit
    "c" 'magit-blame-cycle-style))

(provide 'init-git)

;;; init-git.el ends here
