;; init-lang-go.el --- Go Lang Config	-*- lexical-binding: t -*-

;; Author: Zsxh Chen <bnbvbchen@gmail.com>
;; URL: https://github.com/zsxh/emacs.d

;;; Commentary:
;;
;;  Go Lang Config
;;

;;; Code:

;; Install gopls
;; https://github.com/golang/tools/blob/master/gopls/doc/user.md#installation
(use-package go-mode
  :mode ("\\.go\\'" . go-mode)
  :hook (go-mode . lsp-deferred)
  :config
  ;; Env vars
  (with-eval-after-load 'exec-path-from-shell
    (exec-path-from-shell-copy-envs '("GOPATH" "GO111MODULE" "GOPROXY")))

  (require 'lsp-go)
  (+language-server/set-common-leader-keys go-mode-map))

(use-package lsp-go
  :defer t
  :ensure lsp-mode)

(use-package dap-go
  :after lsp-go
  :ensure dap-mode)


(provide 'init-lang-go)

;;; init-lang-go.el ends here
