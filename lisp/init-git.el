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

(use-package evil-magit
  :commands magit
  :ensure t)

(with-eval-after-load 'evil-magit
  (require 'general)
  (zsxh/define-major-key with-editor-mode-map
                         "c" '(with-editor-finish :which-key "with-editor-finish")
                         "k" '(with-editor-cancel :which-key "with-editor-cancel")))

(provide 'init-git)

;;; init-git.el ends here
