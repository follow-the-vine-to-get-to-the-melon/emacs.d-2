;; init-ivy.el --- Ivy Configuations	-*- lexical-binding: t -*-

;; Author: Zsxh Chen <bnbvbchen@gmail.com>
;; URL: https://github.com/zsxh/emacs.d

;;; Commentary:
;;
;;  Ivy for Completion
;;

;;; Code:

;; ivy
(use-package ivy
  :bind ((:map ivy-minibuffer-map
               ("C-k" . ivy-previous-line)
               ("C-j" . ivy-next-line)
               ("C-M-j" . ivy-immediate-done)
               ("C-c C-o" . ivy-occur)
               ([escape] . keyboard-escape-quit))
         (:map ivy-switch-buffer-map
               ("C-k" . ivy-previous-line))
         (:map ivy-occur-mode-map
               ("e" . ivy-wgrep-change-to-wgrep-mode)
               ("C-d" . ivy-occur-delete-candidate)
               ("RET" . ivy-occur-press-and-switch))
         (:map ivy-occur-grep-mode-map
               ("e" . ivy-wgrep-change-to-wgrep-mode)
               ("C-d" . ivy-occur-delete-candidate)
               ("RET" . ivy-occur-press-and-switch)))
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  ;; use timer to improve the ivy-read performance,
  ;; see https://github.com/abo-abo/swiper/issues/1218
  (setq ivy-dynamic-exhibit-delay-ms 250)
  ;; https://github.com/abo-abo/swiper#frequently-asked-questions
  (setq ivy-use-selectable-prompt t)

  (when (fboundp '+ivy/pinyin-config)
    ;; initial input ":" to match pinyin
    (+ivy/pinyin-config)

    (defun ivy--pinyin-regex (str)
      (or (pinyin-to-utf8 str)
          (ivy--regex-plus str)))

    (setq ivy-re-builders-alist
          '((ivy-switch-buffer . ivy--regex-plus)
            (swiper . ivy--pinyin-regex)
            (t . ivy--pinyin-regex))))

  (setq ivy-initial-inputs-alist nil)

  ;; ivy's fuzzy matcher
  ;; (with-eval-after-load 'flx
  ;;   (defun ivy--pinyin-regex-fuzzy (str)
  ;;     (or (pinyin-to-utf8 str)
  ;;         (ivy--regex-fuzzy str)))

  ;;   (setq ivy-re-builders-alist
  ;;         '((ivy-switch-buffer . ivy--regex-plus)
  ;;           (swiper . ivy--pinyin-regex)
  ;;           (t . ivy--pinyin-regex-fuzzy)))

  ;;   ;; no need with initial "^", since using fuzzy
  ;;   (setq ivy-initial-inputs-alist nil))

  (with-eval-after-load 'man
    (cl-pushnew '(Man-completion-table . "^") ivy-initial-inputs-alist))
  (with-eval-after-load 'woman
    (cl-pushnew '(woman . "^") ivy-initial-inputs-alist)))

;; swiper
(use-package swiper
  :commands swiper
  :bind ("C-s" . swiper))

;; counsel
(use-package counsel
  :bind (("C-x C-f" . counsel-find-file)
         ("M-x" . counsel-M-x))
  :config
  ;; TODO: counsel rg or swiper
  ;; no need with initial "^"
  (setq ivy-initial-inputs-alist nil))

(use-package ivy-rich
  :after ivy
  :config
  (setq ivy-format-function #'ivy-format-function-line)
  (plist-put ivy-rich--display-transformers-list '+projectile/ivy-switch-buffer
             (plist-get ivy-rich--display-transformers-list 'ivy-switch-buffer))
  (ivy-rich-mode 1))

;; ivy-posframe
(use-package ivy-posframe
  ;; :after ivy
  :defer t
  :config
  ;; (setq ivy-display-function #'ivy-posframe-display)
  (setq ivy-display-function #'ivy-posframe-display-at-frame-bottom-left)
  (ivy-posframe-enable))

(with-eval-after-load 'ivy-posframe
  ;; Override ivy-posframe--display
  (defun ivy-posframe--display-advice (str &optional poshandler)
    "Show STR in ivy's posframe."
    (if (not (ivy-posframe-workable-p))
        (ivy-display-function-fallback str)
      (with-selected-window (ivy--get-window ivy-last)
        (posframe-show
         ivy-posframe-buffer
         :font ivy-posframe-font
         :string
         (with-current-buffer (get-buffer-create " *Minibuf-1*")
           (let ((point (point))
                 (string (if ivy-posframe--ignore-prompt
                             str
                           (concat (buffer-string) "  " str))))
             (add-text-properties (- point 1) point '(face ivy-posframe-cursor) string)
             string))
         :position (point)
         :poshandler poshandler
         ;; :background-color (face-attribute 'ivy-posframe :background)
         :background-color "#E0E0E0"
         :foreground-color (face-attribute 'ivy-posframe :foreground)
         :height (or ivy-posframe-height ivy-height)
         ;; :width (or ivy-posframe-width (/ (window-width) 2))
         :width (or ivy-posframe-width (frame-width))
         :min-height (or ivy-posframe-min-height 10)
         :min-width (or ivy-posframe-min-width 50)
         :internal-border-width ivy-posframe-border-width
         :override-parameters ivy-posframe-parameters))))
  (advice-add #'ivy-posframe--display :override #'ivy-posframe--display-advice))

(use-package ivy-xref
  :init
  (setq xref-show-xrefs-function #'ivy-xref-show-xrefs) ; Emacs< 27
  (setq xref-show-definitions-function #'ivy-xref-show-defs) ; Emacs >= 27
  :commands ivy-xref-show-xrefs)

(defun +ivy/pinyin-config ()
  ;; Contribute pengpengxp
  ;; https://emacs-china.org/t/ivy-read/2432/3
  (use-package pinyinlib
    :commands pinyinlib-build-regexp-string)

  (defun my-pinyinlib-build-regexp-string (str)
    (progn
      (cond ((equal str ".*")
             ".*")
            (t
             (pinyinlib-build-regexp-string str t)))))

  (defun my-pinyin-regexp-helper (str)
    (cond ((equal str " ")
           ".*")
          ((equal str "")
           nil)
          (t
           str)))

  (defun pinyin-to-utf8 (str)
    (cond ((equal 0 (length str))
           nil)
          ((equal (substring str 0 1) ":")
           (mapconcat 'my-pinyinlib-build-regexp-string
                      (remove nil (mapcar 'my-pinyin-regexp-helper (split-string
                                                                    (replace-regexp-in-string ":" "" str) "")))
                      ""))
          nil)))


(provide 'init-ivy)

;;; init-ivy.el ends here
