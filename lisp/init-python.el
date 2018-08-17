;; init-python.el --- python configurations	-*- lexical-binding: t -*-

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
;;  Python Configurations
;;

;;; Code:

;; Somehow pipenv cant really active virtulenv, but i found pyvenv do a good job for this
(use-package pyvenv
  :ensure t
  :commands pyvenv-activate)

(use-package pyenv-mode
  :ensure t
  :commands pyenv-mode
  :hook (python-mode . pyenv-mode))

(use-package pipenv
  :ensure t
  :commands pipenv-mode
  :hook (python-mode . pipenv-mode)
  :init
  (setq pipenv-projectile-after-switch-function
        #'pipenv-projectile-after-switch-extended))

(use-package lsp-python
  :ensure t
  :requires init-lsp
  :commands lsp-python-enable
  :hook (python-mode . (lambda ()
                         (setq-local python-indent-offset 2)
                         (lsp-python-enable)
                         (+python/python-setup-shell))))

;; Extra Keybindings
(with-eval-after-load 'lsp-python
  (require 'general)
  (zsxh/define-major-key python-mode-map
                         "'"  '(+python/repl :which-key "repl")
                         "c"  '(nil :which-key "compile-exec")
                         "cc" '(+python/python-execute-file :which-key "execute-file")
                         "cC" '(+python/python-execute-file-focus :which-key "execute-file-focus")
                         "g"  '(nil :which-key "go")
                         "gd" '(xref-find-definitions :which-key "goto-definition")
                         "gr" '(xref-find-references :which-key "find-references")
                         "r"  '(nil :which-key "refactor")
                         "rr" '(lsp-rename :which-key "rename")))

(defun +python/pyenv-executable-find (command)
  (executable-find command))

(defun +python/python-setup-shell (&rest args)
  (if (+python/pyenv-executable-find "ipython")
      (progn (setq python-shell-interpreter "ipython")
             (if (version< (replace-regexp-in-string "[\r\n|\n]$" "" (shell-command-to-string "ipython --version")) "5")
                 (setq python-shell-interpreter-args "-i")
               (setq python-shell-interpreter-args "--simple-prompt -i")))
    (progn
      (setq python-shell-interpreter-args "-i")
      (setq python-shell-interpreter "python"))))

(defun +python/python-toggle-breakpoint ()
  "Add a break point, highlight it."
  (interactive)
  (let ((trace (cond ((+python/pyenv-executable-find "trepan3k") "import trepan.api; trepan.api.debug()")
                     ((+python/pyenv-executable-find "wdb") "import wdb; wdb.set_trace()")
                     ((+python/pyenv-executable-find "ipdb") "import ipdb; ipdb.set_trace()")
                     ((+python/pyenv-executable-find "pudb") "import pudb; pudb.set_trace()")
                     ((+python/pyenv-executable-find "ipdb3") "import ipdb; ipdb.set_trace()")
                     ((+python/pyenv-executable-find "pudb3") "import pudb; pudb.set_trace()")
                     (t "import pdb; pdb.set_trace()")))
        (line (thing-at-point 'line)))
    (if (and line (string-match trace line))
        (kill-whole-line)
      (progn
        (back-to-indentation)
        (insert trace)
        (insert "\n")
        (python-indent-line)))))

;;;###autoload
(defun +python/repl ()
  "Open the Python REPL."
  (interactive)
  ;; (process-buffer (run-python nil t t))
  (pop-to-buffer (process-buffer (python-shell-get-or-create-process)))
  (evil-insert-state))

(defun +python/python-execute-file (arg)
  "Execute a python script in a shell."
  (interactive "P")
  ;; set compile command to buffer-file-name
  ;; universal argument put compile buffer in comint mode
  (let ((universal-argument t)
        (compile-command (format "%s %s"
                                 (+python/pyenv-executable-find python-shell-interpreter)
                                 (file-name-nondirectory buffer-file-name))))
    (if arg
        (call-interactively 'compile)
      (compile compile-command t)
      (with-current-buffer (get-buffer "*compilation*")
        ;; python-shell--interpreter default value is void...
        ;; Fix inferior-python-mode initialization error
        (setq python-shell--interpreter nil)
        (setq python-shell--interpreter-args nil)
        (inferior-python-mode)))))

(defun +python/python-execute-file-focus (arg)
  "Execute a python script in a shell and switch to the shell buffer in
 'normal state'."
  (interactive "P")
  (+python/python-execute-file arg)
  (switch-to-buffer-other-window "*compilation*")
  (end-of-buffer)
  (evil-normal-state))


(provide 'init-python)

;;; init-python.el ends here
