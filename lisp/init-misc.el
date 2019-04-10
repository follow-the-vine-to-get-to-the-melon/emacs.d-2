;; init-misc.el --- Some other things	 -*- lexical-binding: t -*-

;; Author: Zsxh Chen <bnbvbchen@gmail.com>
;; URL: https://github.com/zsxh/emacs.d

;;; Commentary:
;;
;;  Some other things
;;

;;; Code:

(eval-when-compile
  (require 'init-custom))

;; Rss reader
;; https://github.com/skeeto/elfeed
(use-package elfeed
  :ensure t
  :commands elfeed
  :config
  (when personal-elfeed-feeds
    (setq elfeed-feeds personal-elfeed-feeds))
  (when (featurep 'evil-collection)
    (evil-collection-init 'elfeed)))

;; Youdao
(use-package youdao-dictionary
  :ensure t
  :commands (youdao-dictionary-search-at-point+
             youdao-dictionary-search-at-point-tooltip
             youdao-dictionary-play-voice-at-point)
  :config
  (setq url-automatic-caching t)
  (with-eval-after-load 'evil
    (evil-define-key 'normal youdao-dictionary-mode-map "q" 'quit-window)))

;; Markdowm
(with-eval-after-load 'markdown-mode
  (defun eaf-markdown-previewer ()
    "Markdown Previewer."
    (interactive)
    (eaf-open buffer-file-name))
  (+funcs/set-leader-keys-for-major-mode
   markdown-mode-map
   "y" '(youdao-dictionary-search-at-point-tooltip :which-key "translate-at-point")
   "v" '(youdao-dictionary-play-voice-at-point :which-key "voice-at-point")
   "p" '(eaf-markdown-previewer :which-key "previewer")
   "t" '(nil :which-key "toggle")
   "ti" '(markdown-toggle-inline-images :which-key "inline-images")))

;; This extension will ask me Chinese words and then insert translation as variable or function name.
;; https://github.com/manateelazycat/insert-translated-name
(use-package insert-translated-name
  :commands insert-translated-name-insert
  :quelpa ((insert-translated-name :fetcher github :repo "manateelazycat/insert-translated-name")))

;; Leetcode
;; https://github.com/kaiwk/leetcode.el
;; Remember to set your account and password
(use-package leetcode
  :commands leetcode
  :preface
  (use-package furl :ensure t :defer t)
  (use-package graphql :ensure t :defer t)
  :quelpa ((leetcode :fetcher github :repo "kaiwk/leetcode.el")))

;; Socks Proxy
(use-package socks
  :ensure nil
  :defer t
  :init
  (defun proxy-mode-socks-enable ()
    "Enable Socks proxy."
    (setq url-gateway-method 'socks)
    (setq socks-noproxy '("localhost"))
    (setq socks-server '("Default server" "socks" 1080 5))
    (message "socks proxy %s enabled" socks-server))

  (defun proxy-mode-socks-disable ()
    "Disable Socks proxy."
    (setq url-gateway-method 'native)
    (message "socks proxy diabled")))

;;;###autoload
(defun toggle-socks-proxy ()
  "Toggle socks proxy."
  (interactive)
  (if (equal url-gateway-method 'native)
      (proxy-mode-socks-enable)
    (proxy-mode-socks-disable)))

(provide 'init-misc)

;;; init-misc.el ends here
