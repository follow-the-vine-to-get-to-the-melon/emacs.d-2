;; init-highlight.el --- Highlight EveryThing	-*- lexical-binding: t -*-

;; Author: Zsxh Chen <bnbvbchen@gmail.com>
;; URL: https://github.com/zsxh/emacs.d

;;; Commentary:
;;
;;  Highlighting EveryThing
;;

;;; Code:

;; Highlight matching parenthesis
(use-package paren
  :ensure nil
  :hook ((after-init . (lambda () (show-paren-mode -1)))
         ((prog-mode org-mode markdown-mode) . show-paren-local-mode))
  :config
  (setq show-paren-when-point-inside-paren t)
  (setq show-paren-when-point-in-periphery t)

  (defun show-paren-function-advice (fn)
    "Highlight enclosing parens."
    (cond ((looking-at-p "\\s(") (funcall fn))
          (t (save-excursion
               (ignore-errors (backward-up-list))
               (funcall fn)))))

  (advice-add 'show-paren-function :around #'show-paren-function-advice)

  (defun show-paren-local-mode ()
    (interactive)
    (setq-local show-paren-mode t)))

;; Highlight Symbol
(use-package symbol-overlay
  :defer t
  :config
  (defun symbol-overlay-goto-first ()
    (interactive)
    (let* ((symbol (symbol-overlay-get-symbol))
           (keyword (symbol-overlay-assoc symbol))
           (a-symbol (car keyword))
           (before (symbol-overlay-get-list a-symbol 'car))
           (count (length before)))
      (symbol-overlay-jump-call 'symbol-overlay-basic-jump (- count))))

  (defun symbol-overlay-goto-last ()
    (interactive)
    (let* ((symbol (symbol-overlay-get-symbol))
           (keyword (symbol-overlay-assoc symbol))
           (a-symbol (car keyword))
           (after (symbol-overlay-get-list a-symbol 'cdr))
           (count (length after)))
      (symbol-overlay-jump-call 'symbol-overlay-basic-jump (- count 1))))

  (define-key symbol-overlay-map (kbd "<") 'symbol-overlay-goto-first)
  (define-key symbol-overlay-map (kbd ">") 'symbol-overlay-goto-last)
  (define-key symbol-overlay-map (kbd "h") 'nil)
  (define-key symbol-overlay-map (kbd "?") 'symbol-overlay-map-help))

;; Color String
(use-package rainbow-mode
  :diminish rainbow-mode
  :hook ((web-mode
          lisp-mode
          emacs-lisp-mode
          help-mode
          js-mode)
         . rainbow-mode))

;; Highlights delimiters such as parentheses, brackets or braces according to their depth
(use-package rainbow-delimiters
  :hook ((lisp-mode emacs-lisp-mode) . rainbow-delimiters-mode))

(use-package highlight-indent-guides
  :hook ((python-mode) . highlight-indent-guides-mode)
  :config
  (defun my-highlighter (level responsive display)
    (if (> 2 level)
        nil
      (highlight-indent-guides--highlighter-default level responsive display)))

  (setq highlight-indent-guides-method 'character
        highlight-indent-guides-character ?\|
        highlight-indent-guides-auto-character-face-perc 30
        highlight-indent-guides-auto-top-character-face-perc 60
        highlight-indent-guides-responsive 'top
        highlight-indent-guides-highlighter-function 'my-highlighter))

;; Poor Performance
;; Highlight uncommitted changes
;; (use-package diff-hl
;;   :hook ((after-init . global-diff-hl-mode)
;;          (dired-mode . diff-hl-dired-mode))
;;   :config
;;   (diff-hl-flydiff-mode)
;;   (with-eval-after-load 'magit
;;     (add-hook 'magit-post-refresh-hook #'diff-hl-magit-post-refresh))
;;   ;; There's no fringe when Emacs is running in the console,
;;   ;; but the navigation and revert commands still work.
;;   ;; Consider turning diff-hl-margin-mode on, to show the indicators in the margin instead.
;;   (unless (display-graphic-p)
;;     (diff-hl-margin-mode))
;;   )

;; TODO: try xterm-color?
(use-package ansi-color
  :ensure nil
  :commands ansi-color-apply-on-region)

;;;###autoload
(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region (point-min) (point-max))
  (toggle-read-only))

(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

;; highlight comment tags like TODO, BUG, FIXME, etc.
(use-package hl-todo
  :hook (prog-mode . hl-todo-mode))


(provide 'init-highlight)

;;; init-highlight.el ends here
