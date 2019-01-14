;; init-syntax-checking.el --- Syntax Checking Configuations	-*- lexical-binding: t -*-

;; Author: Zsxh Chen <bnbvbchen@gmail.com>
;; URL: https://github.com/zsxh/emacs.d

;;; Commentary:
;;
;;  Syntax Checking Configuations
;;

;;; Code:

;;;;;;;;;;;;;; FLYMAKE ;;;;;;;;;;;;;;

(use-package flymake-diagnostic-at-point
  :quelpa ((flymake-diagnostic-at-point :fetcher github :repo "meqif/flymake-diagnostic-at-point"))
  :after flymake
  :hook (flymake-mode . flymake-diagnostic-at-point-mode))

;;;;;;;;;;;;;; FLYCHECK ;;;;;;;;;;;;;;

(use-package flycheck
  :ensure t
  :defer t
  ;; :hook (lsp-mode . flycheck-mode)
  :config
  (setq flycheck-indication-mode 'right-fringe)
  (setq flycheck-emacs-lisp-load-path 'inherit)
  ;; Only check while saving and opening files
  (setq flycheck-check-syntax-automatically '(save mode-enabled))

  ;; Custom flycheck fringe icons
  (define-fringe-bitmap 'my-flycheck-fringe-indicator
    (vector #b00111111
            #b00111111
            #b00111111
            #b00111111
            #b00111111
            #b00111111
            #b00111111
            #b00111111
            #b00111111
            #b00111111
            #b00111111
            #b00111111
            #b00111111
            #b00111111
            #b00111111
            #b00111111
            #b00111111))
  (let ((bitmap 'my-flycheck-fringe-indicator))
    (flycheck-define-error-level 'error
      :severity 2
      :overlay-category 'flycheck-error-overlay
      :fringe-bitmap bitmap
      :error-list-face 'flycheck-error-list-error
      :fringe-face 'flycheck-fringe-error)
    (flycheck-define-error-level 'warning
      :severity 1
      :overlay-category 'flycheck-warning-overlay
      :fringe-bitmap bitmap
      :error-list-face 'flycheck-error-list-warning
      :fringe-face 'flycheck-fringe-warning)
    (flycheck-define-error-level 'info
      :severity 0
      :overlay-category 'flycheck-info-overlay
      :fringe-bitmap bitmap
      :error-list-face 'flycheck-error-list-info
      :fringe-face 'flycheck-fringe-info))

  (push '("^\\*Flycheck.+\\*$"
          :regexp t
          :dedicated t
          :position bottom
          :stick t
          :noselect t)
        popwin:special-display-config)

  (with-eval-after-load 'evil-collection
    (evil-collection-init 'flycheck)
    (evil-define-key 'normal flycheck-error-list-mode-map
      "j" 'flycheck-error-list-next-error
      "k" 'flycheck-error-list-previous-error)))

;; Display Flycheck errors in GUI tooltips
(if (display-graphic-p)
    (use-package flycheck-posframe
      :after flycheck
      :ensure t
      :hook (flycheck-mode . flycheck-posframe-mode))
  (use-package flycheck-popup-tip
    :after flycheck
    :ensure t
    :hook (flycheck-mode . flycheck-popup-tip-mode)))

;; toggle flycheck window
(defun +flycheck/toggle-flycheck-error-list ()
  "Toggle flycheck's error list window.
If the error list is visible, hide it.  Otherwise, show it."
  (interactive)
  (-if-let (window (flycheck-get-error-list-window))
      (quit-window nil window)
    (flycheck-list-errors)))

(defun +flycheck/goto-flycheck-error-list ()
  "Open and go to the error list buffer."
  (interactive)
  (unless (get-buffer-window (get-buffer flycheck-error-list-buffer))
    (flycheck-list-errors)
    (switch-to-buffer-other-window flycheck-error-list-buffer)))

(defun +flycheck/popup-errors ()
  "Show the error list for the current buffer."
  (interactive)
  (unless flycheck-mode
    (user-error "Flycheck mode not enabled"))
  ;; Create and initialize the error list
  (unless (get-buffer flycheck-error-list-buffer)
    (with-current-buffer (get-buffer-create flycheck-error-list-buffer)
      (flycheck-error-list-mode)))
  (flycheck-error-list-set-source (current-buffer))
  ;; Reset the error filter
  (flycheck-error-list-reset-filter)
  ;; Popup the error list in the bottom window
  (popwin:popup-buffer flycheck-error-list-buffer)
  ;; Finally, refresh the error list to show the most recent errors
  (flycheck-error-list-refresh))

;; Jump to and fix syntax errors via `avy'
;; (use-package avy-flycheck
;;   :after flycheck
;;   :ensure t
;;   :hook (flycheck-mode . avy-flycheck-setup))

(provide 'init-syntax-checking)

;;; init-syntax-checking.el ends here