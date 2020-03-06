;; init-git.el --- Version Control Configuations	-*- lexical-binding: t -*-

;; Author: Zsxh Chen <bnbvbchen@gmail.com>
;; URL: https://github.com/zsxh/emacs.d

;;; Commentary:
;;
;;  Version Control Configuations
;;

;;; Code:

(use-package magit
  :commands (magit magit-blame magit-file-popup)
  :defer 10
  :config
  ;; https://github.com/magit/magit/issues/2371#issuecomment-152746346
  ;; value nil, vc mode-line update when buffer changed. t, update every auto-revert-interval seconds
  ;; (setq auto-revert-check-vc-info t)
  (setq magit-bury-buffer-function 'magit-mode-quit-window))

(use-package evil-magit
  :after magit
  :config
  (with-eval-after-load 'with-editor
    (evil-define-minor-mode-key 'normal 'with-editor-mode
      ",c" 'with-editor-finish
      ",k" 'with-editor-cancel))
  (with-eval-after-load 'magit-blame
    (evil-define-minor-mode-key 'normal 'magit-blame-mode
      "q" 'magit-blame-quit
      "c" 'magit-blame-cycle-style)))

;; https://github.com/alphapapa/magit-todos
(use-package magit-todos
  :hook (magit-mode . magit-todos-mode)
  :custom
  (magit-todos-exclude-globs '("node_modules" "*.json"))
  :config
  (setq magit-todos-auto-group-items 'always)
  (with-eval-after-load 'evil-collection
    (evil-collection-init 'magit-todos))
  (with-eval-after-load 'evil
    (evil-collection-define-key nil 'magit-todos-item-section-map
      "j" nil)))

;; TODO: config forge and github, gitlab ...
;; (use-package forge
;;   :after magit)

;; Walk through git revisions of a file
(use-package git-timemachine
  :defer t
  :config
  (evil-define-minor-mode-key 'normal 'git-timemachine-mode
    "p" 'git-timemachine-show-previous-revision
    "n" 'git-timemachine-show-next-revision
    "q" 'git-timemachine-quit
    "b" 'git-timemachine-blame
    "gtg" 'git-timemachine-show-nth-revision
    "gtt" 'git-timemachine-show-revision-fuzzy
    "gty" 'git-timemachine-kill-abbreviated-revision
    "gtY" 'git-timemachine-kill-revision))


(provide 'init-git)

;;; init-git.el ends here
