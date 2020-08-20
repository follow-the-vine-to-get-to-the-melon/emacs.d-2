;; init-lang-julia.el --- Julia Lang Configurations	-*- lexical-binding: t -*-

;; Author: Zsxh Chen <bnbvbchen@gmail.com>
;; URL: https://github.com/zsxh/emacs.d

;;; Commentary:
;;
;;  Julia Lang Configurations
;;

;;; Code:

(require 'init-language-server)

;; Julia PkgServer/Mirrors https://discourse.juliacn.com/t/topic/2969
;; Install Julia LanguageServer
;; $ julia
;; julia> ]
;; pkg> add LanguageServer
(use-package julia-mode
  :mode ("\\.jl\\'" . julia-mode)
  :hook ((julia-mode . (lambda ()
                         (setq-local lsp-enable-folding t
                                     lsp-folding-range-limit 100)
                         (lsp-deferred)))
         (julia-mode . julia-repl-mode))
  :config
  (setq julia-indent-offset 2)

  (require 'lsp-julia)
  (+language-server/set-common-leader-keys julia-mode-map)

  ;; Code from https://github.com/ronisbr/doom-emacs/blob/develop/modules/lang/julia/config.el
  ;; Borrow matlab.el's fontification of math operators. From
  ;; <https://ogbe.net/emacsconfig.html>
  (dolist (mode '(julia-mode ess-julia-mode))
    (font-lock-add-keywords
     mode
     `((,(let ((OR "\\|"))
           (concat "\\("          ; stolen `matlab.el' operators first
                   ;; `:` defines a symbol in Julia and must not be highlighted
                   ;; as an operator. The only operators that start with `:` are
                   ;; `:<` and `::`. This must be defined before `<`.
                   "[:<]:" OR
                   "[<>]=?" OR
                   "\\.[/*^']" OR
                   "===" OR
                   "==" OR
                   "=>" OR
                   "\\<xor\\>" OR
                   "[-+*\\/^&|$]=?" OR ; this has to come before next (updating operators)
                   "[-^&|*+\\/~]" OR
                   ;; Julia variables and names can have `!`. Thus, `!` must be
                   ;; highlighted as a single operator only in some
                   ;; circumstances. However, full support can only be
                   ;; implemented by a full parser. Thus, here, we will handle
                   ;; only the simple cases.
                   "[[:space:]]!=?=?" OR "^!=?=?" OR
                   ;; The other math operators that starts with `!`.
                   ;; more extra julia operators follow
                   "[%$]" OR
                   ;; bitwise operators
                   ">>>" OR ">>" OR "<<" OR
                   ">>>=" OR ">>" OR "<<" OR
                   "\\)"))
        1 font-lock-type-face)))))

;; SymbolServer.jl takes a very long time to process project dependencies
;; https://github.com/julia-vscode/SymbolServer.jl/issues/56
;; This is a one-time process that shouldn’t cause issues once the dependencies are cached,
;; however it can take over a minute to process each dependency.
(use-package lsp-julia
  :defer t
  :custom
  (lsp-julia-package-dir nil)     ; use the globally installed version
  (lsp-julia-default-environment "~/.julia/environments/v1.5")
  :config
  (defun +julia/lsp-get-root (dir)
    "Get the (Julia) project root directory of the current file."
    (expand-file-name (if dir (or (locate-dominating-file dir "JuliaProject.toml")
                                  (locate-dominating-file dir "Project.toml")
                                  lsp-julia-default-environment)
                        lsp-julia-default-environment)))

  (advice-add 'lsp-julia--get-root :override
              (lambda ()
                (+julia/lsp-get-root (buffer-file-name)))))

(use-package julia-repl
  :commands julia-repl-mode)


(provide 'init-lang-julia)

;;; init-lang-julia.el ends here
