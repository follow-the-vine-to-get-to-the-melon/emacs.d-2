;; init-jupyter.el --- Emacs Jupyter Configurations	-*- lexical-binding: t -*-

;; Author: Zsxh Chen <bnbvbchen@gmail.com>
;; URL: https://github.com/zsxh/emacs.d

;;; Commentary:
;;
;; Emacs Jupyter Configurations
;;

;;; Code:

;; An interface ot communicate with Jupyter kernels in Emacs
(use-package jupyter
  :ensure t
  :commands (jupyter-run-repl jupyter-connect-repl))

(with-eval-after-load 'jupyter-repl
  (set-face-foreground 'jupyter-repl-input-prompt "#4F894C")
  (set-face-background 'jupyter-repl-traceback "#FBF8EF"))

(use-package ein
  :ensure t
  :commands (ein:notebooklist-open ;; run jupter notebook first
             ein:notebooklist-login
             ein:jupyter-server-start)
  :config
  ;; FIXME: found out a proper way to solve keybindings problem
  ;; (since ein:notebook-mode-map have higher priority, and poly-minor-mode-map prefix is pretty annoying)
  (require 'poly-ein)
  (setq ein:polymode nil)
  (define-key poly-ein-mode-map (format "%s%s" (or polymode-prefix-key "\M-n") ".") 'ipython-notebook-hydra/body)

  (require 'ein-subpackages)
  (setq ein:completion-backend 'ein:use-company-backend)

  (defun +ein/set-company-backend ()
    (setq-local company-backends '(ein:company-backend company-files))
    ;; disable company box to improve performance
    (when (bound-and-true-p company-box-mode)
      (company-box-mode -1)))

  (add-hook 'poly-ein-mode-hook '+ein/set-company-backend)

  (with-eval-after-load 'ein-cell
    (setq ein:cell-traceback-level nil) ;; Show all traceback
    (set-face-background 'ein:cell-input-area "#E0E0E0")

    ;; you can use 'ansi-color-filter-apply instead of 'ansi-color-apply to escape ansi code
    (advice-add 'ein:output-area-convert-mime-types :around (lambda (orig-fun &rest args)
                                                              (let* ((json (apply orig-fun args))
                                                                     (text (plist-get json :text)))
                                                                (when (plist-member json :text)
                                                                  (plist-put json :text (ansi-color-apply text)))
                                                                json))))

  (when (not (bound-and-true-p ein:polymode))
    (with-eval-after-load 'ein-notebook
      (add-hook 'ein:notebook-mode-hook #'+ein/set-company-backend))

    (require 'ein-multilang)

    (defun ein:ml-lang-setup-julia ()
      ;; (when (featurep 'julia-mode))
      (require 'julia-mode)
      (setq-local mode-name "EIN[Julia]")
      (setq-local indent-line-function
                  (apply-partially #'ein:ml-indent-line-function #'julia-indent-line))
      (set-syntax-table julia-mode-syntax-table)
      (set-keymap-parent ein:notebook-multilang-mode-map julia-mode-map))

    (+funcs/set-leader-keys-for-major-mode ein:notebook-multilang-mode-map
                                           "." 'ipython-notebook-hydra/body
                                           "y" 'ein:worksheet-copy-cell
                                           "p" 'ein:worksheet-yank-cell
                                           "d" 'ein:worksheet-kill-cell
                                           "h" 'ein:notebook-worksheet-open-prev-or-last
                                           "i" 'ein:worksheet-insert-cell-below
                                           "I" 'ein:worksheet-insert-cell-above
                                           "j" 'ein:worksheet-goto-next-input
                                           "k" 'ein:worksheet-goto-prev-input
                                           "l" 'ein:notebook-worksheet-open-next-or-first
                                           "H" 'ein:notebook-worksheet-move-prev
                                           "J" 'ein:worksheet-move-cell-down
                                           "K" 'ein:worksheet-move-cell-up
                                           "L" 'ein:notebook-worksheet-move-next
                                           "t" 'ein:worksheet-toggle-output
                                           "R" 'ein:worksheet-rename-sheet
                                           "o" 'ein:worksheet-insert-cell-below
                                           "O" 'ein:worksheet-insert-cell-above
                                           "u" 'ein:worksheet-change-cell-type
                                           "RET" 'ein:worksheet-execute-cell-and-goto-next
                                           ;; Output
                                           "C-l" 'ein:worksheet-clear-output
                                           "C-S-l" 'ein:worksheet-clear-all-output
                                           ;;Console
                                           "C-o" 'ein:console-open
                                           ;; Merge cells
                                           "C-k" 'ein:worksheet-merge-cell
                                           "C-j" '+ein/ein:worksheet-merge-cell-next
                                           "s" 'ein:worksheet-split-cell-at-point
                                           ;; Notebook
                                           "C-s" 'ein:notebook-save-notebook-command
                                           "C-r" 'ein:notebook-rename-command
                                           "1" 'ein:notebook-worksheet-open-1th
                                           "2" 'ein:notebook-worksheet-open-2th
                                           "3" 'ein:notebook-worksheet-open-3th
                                           "4" 'ein:notebook-worksheet-open-4th
                                           "5" 'ein:notebook-worksheet-open-5th
                                           "6" 'ein:notebook-worksheet-open-6th
                                           "7" 'ein:notebook-worksheet-open-7th
                                           "8" 'ein:notebook-worksheet-open-8th
                                           "9" 'ein:notebook-worksheet-open-last
                                           "+" 'ein:notebook-worksheet-insert-next
                                           "-" 'ein:notebook-worksheet-delete
                                           "x" 'ein:notebook-close
                                           "fs" 'ein:notebook-save-notebook-command)

    ;; keybindings mirror ipython web interface behavior
    (evil-define-key 'insert ein:notebook-multilang-mode-map
      (kbd "<C-return>") 'ein:worksheet-execute-cell
      (kbd "<S-return>") 'ein:worksheet-execute-cell-and-goto-next)

    ;; keybindings mirror ipython web interface behavior
    (evil-define-key 'hybrid ein:notebook-multilang-mode-map
      (kbd "<C-return>") 'ein:worksheet-execute-cell
      (kbd "<S-return>") 'ein:worksheet-execute-cell-and-goto-next)

    (evil-define-key 'normal ein:notebook-multilang-mode-map
      ;; keybindings mirror ipython web interface behavior
      (kbd "<C-return>") 'ein:worksheet-execute-cell
      (kbd "<S-return>") 'ein:worksheet-execute-cell-and-goto-next
      "gj" 'ein:worksheet-goto-next-input
      "gk" 'ein:worksheet-goto-prev-input)

    (define-key ein:notebook-multilang-mode-map (kbd "M-j") 'ein:worksheet-move-cell-down)
    (define-key ein:notebook-multilang-mode-map (kbd "M-k") 'ein:worksheet-move-cell-up))

  (with-eval-after-load 'ein-traceback
    (+funcs/set-leader-keys-for-major-mode ein:traceback-mode-map
                                           "RET" 'ein:tb-jump-to-source-at-point-command
                                           "n" 'ein:tb-next-item
                                           "p" 'ein:tb-prev-item
                                           "q" 'bury-buffer))

  (defun +ein/ein:worksheet-merge-cell-next ()
    (interactive)
    (ein:worksheet-merge-cell (ein:worksheet--get-ws-or-error) (ein:worksheet-get-current-cell) t t))

  (defhydra ipython-notebook-hydra (:hint nil)
    "
 Operations on Cells^^^^^^            On Worksheets^^^^              Other
 ----------------------------^^^^^^   ------------------------^^^^   ----------------------------------^^^^
 [_k_/_j_]^^     select prev/next     [_h_/_l_]   select prev/next   [_t_]^^         toggle output
 [_K_/_J_]^^     move up/down         [_H_/_L_]   move left/right    [_C-l_/_C-S-l_] clear/clear all output
 [_C-k_/_C-j_]^^ merge above/below    [_1_.._9_]  open [1st..last]   [_C-o_]^^       open console
 [_O_/_o_]^^     insert above/below   [_+_/_-_]   create/delete      [_C-s_/_C-r_]   save/rename notebook
 [_y_/_p_/_d_]   copy/paste/delete    [_s_]^^     split cell         [_x_]^^         close notebook
 [_u_]^^^^       change type          ^^^^                           [_q_]^^         quit
 [_RET_]^^^^     execute"
    ("h" ein:notebook-worksheet-open-prev-or-last)
    ("j" ein:worksheet-goto-next-input)
    ("k" ein:worksheet-goto-prev-input)
    ("l" ein:notebook-worksheet-open-next-or-first)
    ("H" ein:notebook-worksheet-move-prev)
    ("J" ein:worksheet-move-cell-down)
    ("K" ein:worksheet-move-cell-up)
    ("L" ein:notebook-worksheet-move-next)
    ("t" ein:worksheet-toggle-output)
    ("d" ein:worksheet-kill-cell)
    ("R" ein:worksheet-rename-sheet)
    ("y" ein:worksheet-copy-cell)
    ("p" ein:worksheet-yank-cell)
    ("o" ein:worksheet-insert-cell-below)
    ("O" ein:worksheet-insert-cell-above)
    ("u" ein:worksheet-change-cell-type)
    ("RET" ein:worksheet-execute-cell-and-goto-next)
    ;; Output
    ("C-l" ein:worksheet-clear-output)
    ("C-S-l" ein:worksheet-clear-all-output)
    ;;Console
    ("C-o" ein:console-open)
    ;; Merge and split cells
    ("C-k" ein:worksheet-merge-cell)
    ("C-j" +ein/ein:worksheet-merge-cell-next)
    ("s" ein:worksheet-split-cell-at-point)
    ;; Notebook
    ("C-s" ein:notebook-save-notebook-command :exit t)
    ("C-r" ein:notebook-rename-command :exit t)
    ("1" ein:notebook-worksheet-open-1th)
    ("2" ein:notebook-worksheet-open-2th)
    ("3" ein:notebook-worksheet-open-3th)
    ("4" ein:notebook-worksheet-open-4th)
    ("5" ein:notebook-worksheet-open-5th)
    ("6" ein:notebook-worksheet-open-6th)
    ("7" ein:notebook-worksheet-open-7th)
    ("8" ein:notebook-worksheet-open-8th)
    ("9" ein:notebook-worksheet-open-last)
    ("+" ein:notebook-worksheet-insert-next)
    ("-" ein:notebook-worksheet-delete)
    ("x" ein:notebook-close :exit t)
    ("q" nil :exit t))

  (when (version<= "27" emacs-version)
    ;; (defalias 'json-encode 'json-serialize)

    (defun ein:json-read-from-string (string)
      (json-parse-string string :object-type 'plist :array-type 'list))

    (defun ein:json-read ()
      "Read json from `url-retrieve'-ed buffer.

* `json-object-type' is `plist'. This is mainly for readability.
* `json-array-type' is `list'.  Notebook data is edited locally thus
  data type must be edit-friendly.  `vector' type is not."
      (goto-char (point-max))
      (backward-sexp)
      (json-parse-buffer :object-type 'plist :array-type 'list))))

(use-package magic-latex-buffer
  :ensure t
  :defer t
  ;; enable magic-latex-buffer when ein:notebook-multilang-mode initialize successfully
  ;; :hook (ein:notebook-multilang-mode . (lambda () (run-with-timer 3 nil 'magic-latex-buffer)))
  :init
  (with-eval-after-load 'ein-multilang
    (+funcs/set-leader-keys-for-major-mode
     ein:notebook-multilang-mode-map
     "m" '(magic-latex-buffer :which-key "toggle-latex-preview"))))


(provide 'init-jupyter)

;;; init-jupyter.el ends here
