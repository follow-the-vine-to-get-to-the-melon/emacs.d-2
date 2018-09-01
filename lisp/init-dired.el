;; init-dired.el --- Dired	-*- lexical-binding: t -*-

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
;;  Dired
;;

;;; Code:

;; Dired Configs
(use-package dired
  :ensure nil
  :init
  ;; dired "human-readable" format
  (setq dired-listing-switches "-alh")
  :config
  ;;narrow dired to match filter
  (use-package dired-narrow
    :ensure t
    :commands dired-narrow)

  (with-eval-after-load 'evil-collection
    (evil-collection-init 'dired)
    (evil-define-key 'normal dired-mode-map
      (kbd "SPC") nil
      "," nil))
  (+funcs/try-general-major-key dired-mode-map
                                "/" '(dired-narrow :which-key "dired-narrow")
                                "r" '(dired-narrow-regexp :which-key "dired-narrow-regexp")))

;; Editable Dired mode configs
(use-package wdired
  :ensure nil
  :defer t
  :config
  (+funcs/try-general-major-key wdired-mode-map
                                "c" '(wdired-finish-edit :which-key "finish edit")
                                "k" '(wdired-abort-changes :which-key "abort changes")
                                "q" '(wdired-exit :which-key "exit")))

(provide 'init-dired)

;;; init-dired.el ends here
