;;; custom.el --- user customization file    -*- no-byte-compile: t -*-
;;; Commentary:
;;;       Copy custom-template.el to custom.el and change the configurations, then restart Emacs.
;;;       Put your own configurations in custom-post.el to override default configurations.
;;; Code:


;; Github token string for eaf-markdown-previewer
(setq personal-eaf-grip-token nil)

;; Emacs theme "doom-vibrant" "doom-nord-light"
(setq personal-doom-theme "doom-nord-light")

;; Rss feeds
(setq personal-elfeed-feeds
      '(("https://emacs-china.org/latest.rss" emacs china)
        ("https://emacs-china.org/posts.rss" emacs china)))

;; Frame startup size, "max" or "fullscreen"
(setq personal-frame-startup-size "max")


;;; custom.el ends here
