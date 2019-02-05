;; init-ui.el --- Emacs UI, Startup Screen Settings	-*- lexical-binding: t -*-

;; Author: Zsxh Chen <bnbvbchen@gmail.com>
;; URL: https://github.com/zsxh/emacs.d

;;; Commentary:
;;
;;  Emacs UI, Startup Screen Settings
;;

;;; Code:

(eval-when-compile
  (require 'init-custom))

;; Minimal UI in init.el when emacs-version < 27
(when (version< emacs-version "27")
  (scroll-bar-mode -1)
  (tool-bar-mode   -1)
  (tooltip-mode    -1)
  (menu-bar-mode   -1))

;; Show buffer name in title
(setq frame-title-format "emacs@%b")

;; Disable cursor blinking
(blink-cursor-mode 0)

;; Startup frame size
(if (string= personal-frame-startup-size "max")
    (toggle-frame-maximized)
  (toggle-frame-fullscreen))

;; Installing Fonts
;; https://github.com/domtronn/all-the-icons.el#installing-fonts
(use-package all-the-icons
  :ensure t
  :defer t)

;; Theme
(use-package doom-themes
  :ensure t
  :if (display-graphic-p)
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme (intern personal-doom-theme) t)

  ;; Enable flashing mode-line on errors
  ;; (doom-themes-visual-bell-config)

  ;; Enable custom neotree theme
  (setq doom-neotree-file-icons t)
  (doom-themes-neotree-config) ; all-the-icons fonts must be installed!

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package doom-modeline
  :ensure t
  :defer t
  :preface
  (defun my-doomline-init ()
    (doom-modeline-init)
    (with-current-buffer "*Messages*"
      (doom-modeline-set-modeline 'main)))
  :hook (after-init . my-doomline-init)
  :config
  (setq doom-modeline-major-mode-icon nil)
  (setq doom-modeline-buffer-file-name-style 'buffer-name))

;; Display time on modeline
(setq display-time-format "%Y/%m/%d 周%a %H:%M")
(setq display-time-default-load-average nil) ; don't show load avera
(display-time-mode)

(defun +ui/toggle-display-time-mode ()
  (if (<= (window-width) 110)
      (display-time-mode -1)
    (display-time-mode 1)))

(add-hook 'window-configuration-change-hook '+ui/toggle-display-time-mode)

;; Frame font
;; english and others charsets SF Mono
;; chinese and some other charsets Source Han Serirf
;; download ans install default fonts:
;; SF Mono: https://github.com/ZulwiyozaPutra/SF-Mono-Font
;; Source Han Serief: https://github.com/adobe-fonts/source-han-serif
(set-frame-font "SF Mono-13.5:weight=semi-bold" nil t)
;; (dolist (charset '(kana han symbol cjk-misc bopomofo))
;;   (set-fontset-font (frame-parameter nil 'font)
;;                     charset (font-spec :family "Source Han Serif"))
;;   (setq face-font-rescale-alist '(("Source Han Serif" . 1.24))))

;; Line Number
;; (use-package display-line-numbers
;;   :ensure nil
;;   :hook (prog-mode . display-line-numbers-mode))

;; Emacs startup *scratch* buffer
(setq initial-buffer-choice t)


(provide 'init-ui)

;;; init-ui.el ends here
