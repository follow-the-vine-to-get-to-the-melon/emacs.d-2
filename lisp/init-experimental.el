;; init-experimental.el --- Experimental Feature	-*- lexical-binding: t -*-

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
;;  Experimental Feature
;;

;;; Code:

(let ((default-directory (expand-file-name "experimental" user-emacs-directory)))
  (normal-top-level-add-subdirs-to-load-path))

;; https://github.com/manateelazycat/emacs-application-framework
(use-package eaf
  :commands eaf-open)


;; Pdf viewer settings
(add-to-list 'auto-mode-alist
             '("\\.pdf\\'" . (lambda ()
                               (let ((filename buffer-file-name))
                                 (eaf-open filename)
                                 (kill-buffer (file-name-nondirectory filename))))))

;; Better eshell
;; https://github.com/manateelazycat/aweshell
(use-package aweshell
  :commands aweshell-new
  :quelpa ((aweshell :fetcher github :repo "manateelazycat/aweshell")))

;; Emacs ripgrep plugin
(use-package color-rg
  :commands (color-rg-search-input color-rg-search-project)
  :quelpa ((color-rg :fetcher github :repo "manateelazycat/color-rg")))

(provide 'init-experimental)

;;; init-experimental.el ends here
