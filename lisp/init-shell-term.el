;; init-shell-term.el --- Shell and Terminal Configurations	-*- lexical-binding: t -*-

;; Author: Zsxh Chen <bnbvbchen@gmail.com>
;; URL: https://github.com/zsxh/emacs.d

;;; Commentary:
;;
;;  Shell and Terminal Configurations
;;

;;; Code:

(eval-when-compile
  (require 'init-custom))

(use-package shell-pop
  :ensure t
  :commands shell-pop
  :config
  (setq shell-pop-term-shell personal-shell-executable)
  (cond ((functionp 'vterm)
         (setq shell-pop-shell-type '("vterm" "*vterm*" (lambda () (vterm)))))
        ((functionp 'multi-term)
         (setq shell-pop-shell-type '("multi-term" "*multi-term*" (lambda () (multi-term)))))
        (t (setq shell-pop-shell-type '("ansi-term" "*ansi-term*" (lambda () (ansi-term shell-pop-term-shell))))))
  (setq shell-pop-window-position "bottom")
  ;; The last line is needed or no picked up by 'shell-pop'
  (shell-pop--set-shell-type 'shell-pop-shell-type shell-pop-shell-type))

(defun +shell/projectile-shell-pop ()
  "Open a term buffer at projectile project root."
  (interactive)
  (let ((default-directory (projectile-project-root)))
    (call-interactively 'shell-pop)))

;; HIGHLY RECOMMENDED
;; https://github.com/akermu/emacs-libvterm
;; On ArchLinux or Manjaro:
;; sudo pacman -S libvterm
;;
;; Compile and Build emacs-libvterm module
;; it take times because cmake will automatically download some requied libraries from the internet.
;; M-x vterm-module-compile
;; or
;; You can compile and install the module yourself.
;; cd ~/.emacs.d/elpa/vterm-<version>
;; mkdir -p build
;; cd build
;; cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ..
;; make
(use-package vterm
  ;; :quelpa (vterm :fetcher github :repo "akermu/emacs-libvterm"
  ;;                :files (:defaults "*.c" "*.h" "CMakeLists.txt"))
  :ensure t
  :init (setq vterm-install t)
  :if (and (executable-find "vterm-ctrl")
           (executable-find "make")
           (executable-find "cmake")
           (fboundp 'module-load))
  :commands (vterm vterm-other-window)
  :bind (:map vterm-mode-map
              ("M-u" . ace-window))
  :config
  (with-eval-after-load 'evil
    (evil-set-initial-state 'vterm-mode 'insert))
  (with-eval-after-load 'doom-themes
    (setf (elt ansi-color-names-vector 0) (doom-color 'bg)))
  (defun vterm-kill-buffer-after-exit (buf)
    (when (buffer-live-p buf)
      (kill-buffer buf)))
  (add-hook 'vterm-exit-functions 'vterm-kill-buffer-after-exit))

(use-package term
  :ensure nil
  :defer t
  :config
  ;; https://oremacs.com/2015/01/01/three-ansi-term-tips/
  (setq explicit-shell-file-name personal-shell-executable)

  (defun +term/term-exec-hook ()
    (let* ((buff (current-buffer))
           (proc (get-buffer-process buff)))
      (set-process-sentinel
       proc
       `(lambda (process event)
          (if (string= event "finished\n")
              (kill-buffer ,buff))))))
  (add-hook 'term-exec-hook '+term/term-exec-hook)

  (with-eval-after-load 'evil
    (evil-define-key 'normal term-raw-map "p" 'term-paste)
    (evil-define-key 'insert term-raw-map "\C-y" 'term-paste)))

;; https://www.emacswiki.org/emacs/MultiTerm
(use-package multi-term
  :quelpa (multi-term :fetcher wiki)
  :commands multi-term
  :config
  (setq multi-term-program personal-shell-executable))

;; Better eshell
;; https://github.com/manateelazycat/aweshell
;; (use-package aweshell
;;   :commands aweshell-new
;;   :quelpa ((aweshell :fetcher github :repo "manateelazycat/aweshell")))


(provide 'init-shell-term)

;;; init-shell-term.el ends here
