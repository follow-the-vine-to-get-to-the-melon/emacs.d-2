;; init-completion.el --- commpletion configurations	-*- lexical-binding: t -*-

;; Author: Zsxh Chen <bnbvbchen@gmail.com>
;; URL: https://github.com/zsxh/emacs.d

;;; Commentary:
;;
;;  Code Completion Configuations
;;

;;; Code:

(setq completion-ignore-case t)

(use-package company
  ;; :defines (company-dabbrev-ignore-case company-dabbrev-downcase)
  :bind (("M-/" . yas-expand)
         ("C-c C-y" . company-yasnippet)
         (:map company-active-map
               ("M-n" . nil)
               ("M-p" . nil)
               ("C-k" . company-select-previous)
               ("C-j" . company-select-next)
               ("TAB" . company-complete-common)
               ("<tab>" . company-complete-common)
               ("<backtab>" . company-select-previous))
         (:map company-search-map
               ("M-n" . nil)
               ("M-p" . nil)
               ("C-k" . company-select-previous)
               ("C-j" . company-select-next)))
  :hook (after-init . global-company-mode)
  :config
  (setq company-tooltip-align-annotations t ; aligns annotation to the right
        company-tooltip-limit 12            ; bigger popup window
        company-tooltip-maximum-width (/ (frame-width) 3)
        company-idle-delay 0 ; decrease delay before autocompletion popup shows
        company-echo-delay (if (display-graphic-p) nil 0) ; remove annoying blinking
        company-minimum-prefix-length 1
        ;; company-require-match nil
        ;; company-dabbrev-ignore-case nil
        company-dabbrev-downcase nil    ; No downcase when completion.
        company-require-match nil ; Don't require match, so you can still move your cursor as expected.
        company-backends '(company-capf company-files company-dabbrev)
        company-global-modes '(not shell-mode eshell-mode eaf-mode))
  (with-eval-after-load 'company-eclim
    ;;  Stop eclim auto save.
    (setq company-eclim-auto-save nil)))

(use-package flx
  :defer t)

;; FIXME: unknown backend information
(use-package company-fuzzy
  :defer t
  :config
  (with-eval-after-load 'elisp-mode
    (add-hook 'emacs-lisp-mode-hook 'company-fuzzy-mode)
    (add-hook 'lisp-interaction-mode-hook 'company-fuzzy-mode)))

(use-package prescient :defer t)

(use-package ivy-prescient
  :after counsel
  :config
  (ivy-prescient-mode))

(use-package yasnippet
  :hook (after-init . yas-global-mode)
  :config
  (use-package yasnippet-snippets)
  (with-eval-after-load 'snippet
    (+funcs/major-mode-leader-keys
     snippet-mode-map
     "t" '(yas-tryout-snippet :which-key "yas-tryout-snippet"))))

;; Popup documentation for completion candidates
(use-package company-quickhelp
  :if (or (< emacs-major-version 26)
          (not (display-graphic-p)))
  :after company
  :bind ((:map company-active-map
               ("M-h" . company-quickhelp-manual-begin)))
  :hook (global-company-mode . company-quickhelp-mode)
  :config (setq company-quickhelp-delay 0.3))

(use-package company-quickhelp-terminal
  :if (not (display-graphic-p))
  :after company
  :hook (global-company-mode . company-quickhelp-terminal-mode))

;; (use-package company-posframe
;;   :quelpa ((company-posframe :fetcher github :repo "tumashu/company-posframe"))
;;   :if (and (>= emacs-major-version 26)
;;            (display-graphic-p))
;;   :after company
;;   :hook (global-company-mode . company-posframe-mode)
;;   :config
;;   (setq company-posframe-quickhelp-delay 0.3
;;         company-posframe-show-indicator t
;;         company-posframe-show-metadata t))

;; Code from https://github.com/seagle0128/.emacs.d/blob/master/lisp/init-company.el
(use-package company-box
  :if (and (>= emacs-major-version 26)
           (display-graphic-p))
  :after company
  :hook (company-mode . company-box-mode)
  :init (setq company-box-backends-colors nil
              company-box-show-single-candidate t
              company-box-max-candidates 50
              company-box-doc-delay 0.2
              company-box-tooltip-maximum-width 90)
  :config
  (with-no-warnings
    ;; FIXME: Display common text correctly
    (defun my-company-box--update-line (selection common)
      (company-box--update-image)
      (goto-char 1)
      (forward-line selection)
      (let* ((beg (line-beginning-position))
             (txt-beg (+ company-box--icon-offset beg)))
        (move-overlay (company-box--get-ov) beg (line-beginning-position 2))
        (move-overlay (company-box--get-ov-common) txt-beg
                      (+ (length common) txt-beg)))
      (let ((color (or (get-text-property (point) 'company-box--color)
                       'company-box-selection)))
        (overlay-put (company-box--get-ov) 'face color)
        (overlay-put (company-box--get-ov-common) 'face 'company-tooltip-common-selection)
        (company-box--update-image color))
      (run-hook-with-args 'company-box-selection-hook selection
                          (or (frame-parent) (selected-frame))))
    (advice-add #'company-box--update-line :override #'my-company-box--update-line)

    (defun my-company-box--render-buffer (string)
      (let ((selection company-selection)
            (common (or company-common company-prefix)))
        (with-current-buffer (company-box--get-buffer)
          (erase-buffer)
          (insert string "\n")
          (setq mode-line-format nil
                display-line-numbers nil
                truncate-lines t
                cursor-in-non-selected-windows nil)
          (setq-local scroll-step 1)
          (setq-local scroll-conservatively 10000)
          (setq-local scroll-margin 0)
          (setq-local scroll-preserve-screen-position t)
          (add-hook 'window-configuration-change-hook 'company-box--prevent-changes t t)
          (company-box--update-line selection common))))
    (advice-add #'company-box--render-buffer :override #'my-company-box--render-buffer)

    ;; Prettify icons
    (defun my-company-box-icons--elisp (candidate)
      (when (derived-mode-p 'emacs-lisp-mode)
        (let ((sym (intern candidate)))
          (cond ((fboundp sym) 'Function)
                ((featurep sym) 'Module)
                ((facep sym) 'Color)
                ((boundp sym) 'Variable)
                ((symbolp sym) 'Text)
                (t . nil)))))
    (advice-add #'company-box-icons--elisp :override #'my-company-box-icons--elisp))

  (declare-function all-the-icons-faicon 'all-the-icons)
  (declare-function all-the-icons-material 'all-the-icons)
  (declare-function all-the-icons-octicon 'all-the-icons)
  (setq company-box-icons-all-the-icons
        `((Unknown . ,(all-the-icons-material "find_in_page" :height 0.8 :v-adjust -0.15))
          (Text . ,(all-the-icons-faicon "text-width" :height 0.8 :v-adjust -0.02))
          (Method . ,(all-the-icons-faicon "cube" :height 0.8 :v-adjust -0.02 :face 'all-the-icons-purple))
          (Function . ,(all-the-icons-faicon "cube" :height 0.8 :v-adjust -0.02 :face 'all-the-icons-purple))
          (Constructor . ,(all-the-icons-faicon "cube" :height 0.8 :v-adjust -0.02 :face 'all-the-icons-purple))
          (Field . ,(all-the-icons-octicon "tag" :height 0.85 :v-adjust 0 :face 'all-the-icons-lblue))
          (Variable . ,(all-the-icons-octicon "tag" :height 0.85 :v-adjust 0 :face 'all-the-icons-lblue))
          (Class . ,(all-the-icons-material "settings_input_component" :height 0.8 :v-adjust -0.15 :face 'all-the-icons-orange))
          (Interface . ,(all-the-icons-material "share" :height 0.8 :v-adjust -0.15 :face 'all-the-icons-lblue))
          (Module . ,(all-the-icons-material "view_module" :height 0.8 :v-adjust -0.15 :face 'all-the-icons-lblue))
          (Property . ,(all-the-icons-faicon "wrench" :height 0.8 :v-adjust -0.02))
          (Unit . ,(all-the-icons-material "settings_system_daydream" :height 0.8 :v-adjust -0.15))
          (Value . ,(all-the-icons-material "format_align_right" :height 0.8 :v-adjust -0.15 :face 'all-the-icons-lblue))
          (Enum . ,(all-the-icons-material "storage" :height 0.8 :v-adjust -0.15 :face 'all-the-icons-orange))
          (Keyword . ,(all-the-icons-material "filter_center_focus" :height 0.8 :v-adjust -0.15))
          (Snippet . ,(all-the-icons-material "format_align_center" :height 0.8 :v-adjust -0.15))
          (Color . ,(all-the-icons-material "palette" :height 0.8 :v-adjust -0.15))
          (File . ,(all-the-icons-faicon "file-o" :height 0.8 :v-adjust -0.02))
          (Reference . ,(all-the-icons-material "collections_bookmark" :height 0.8 :v-adjust -0.15))
          (Folder . ,(all-the-icons-faicon "folder-open" :height 0.8 :v-adjust -0.02))
          (EnumMember . ,(all-the-icons-material "format_align_right" :height 0.8 :v-adjust -0.15))
          (Constant . ,(all-the-icons-faicon "square-o" :height 0.8 :v-adjust -0.1))
          (Struct . ,(all-the-icons-material "settings_input_component" :height 0.8 :v-adjust -0.15 :face 'all-the-icons-orange))
          (Event . ,(all-the-icons-octicon "zap" :height 0.8 :v-adjust 0 :face 'all-the-icons-orange))
          (Operator . ,(all-the-icons-material "control_point" :height 0.8 :v-adjust -0.15))
          (TypeParameter . ,(all-the-icons-faicon "arrows" :height 0.8 :v-adjust -0.02))
          (Template . ,(all-the-icons-material "format_align_left" :height 0.8 :v-adjust -0.15)))
        company-box-icons-alist 'company-box-icons-all-the-icons))


(provide 'init-completion)

;;; init-completion.el ends here
