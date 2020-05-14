;; init-custom.el --- Customizations	-*- lexical-binding: t -*-

;; Author: Zsxh Chen <bnbvbchen@gmail.com>
;; URL: https://github.com/zsxh/emacs.d

;;; Commentary:
;;
;;  Customizations
;;

;;; Code:

(defgroup personal nil
  "Personal Emacs customizations."
  :group 'convenience)

(defcustom personal-package-archives 'melpa
  "Set package archives from which to fetch."
  :type '(choice
          (const :tag "Melpa" melpa)
          (const :tag "Melpa Mirror" melpa-mirror)
          (const :tag "Emacs-China" emacs-china)
          (const :tag "Tencent" tencent)
          (const :tag "Tuna" tuna)))

(defcustom personal-dump-file "~/.emacs.d/emacs.pdump"
  "Dump file path."
  :type 'string)

(defvar personal-dumped-p nil
  "non-nil if dump file is loaded.")

(defvar personal-dumped-load-path nil
  "By default dump files doesn’t save ‘load-path’.
We need to manually save and restore it.")

(defcustom personal-eaf-grip-token nil
  "Github personal access token for eaf-markdown-previewer.
https://github.com/manateelazycat/emacs-application-framework#markdown-previewer"
  :type 'string)

(defcustom personal-gui-theme-day 'doom-solarized-light
  "Customize GUI with doom-themes, \"doom-one\", \"doom-nord-light\" for example.
Check https://github.com/hlissner/emacs-doom-themes"
  :type 'symbol)

(defcustom personal-gui-theme-night 'doom-solarized-dark
  "Customize GUI with doom-themes, \"doom-one\", \"doom-nord-light\" for example.
Check https://github.com/hlissner/emacs-doom-themes"
  :type 'symbol)

(defcustom personal-gui-theme (let* ((hour (nth 2 (decode-time (current-time)))))
                                (if (member hour (number-sequence 7 19))
                                    personal-gui-theme-day
                                  personal-gui-theme-night))
  "Customize GUI with doom-themes, \"doom-one\", \"doom-nord-light\" for example.
Check https://github.com/hlissner/emacs-doom-themes"
  :type 'symbol)

(defcustom personal-tui-theme personal-gui-theme-night
  "Customize Terminal UI with doom-themes, \"doom-one\", \"doom-nord-light\" for example.
Check https://github.com/hlissner/emacs-doom-themes"
  :type 'symbol)

(defcustom personal-elfeed-feeds nil
  "RSS feeds, eg: ((\"https://oremacs.com/atom.xml\" oremacs))."
  :type 'cons)

(defcustom personal-frame-startup-size 'max
  "Startup frame size. `'max' means maximized frame and `'fullscreen' means fullscreen frame."
  :type '(choice
          (const :tag "Max" max)
          (const :tag "Fullscreen" fullscreen)))

(defcustom personal-shell-executable "/usr/bin/zsh"
  "Shell used in `term' and `ansi-term'."
  :type 'string)

(defcustom personal-proxy-http-host "127.0.0.1"
  "Set http(s) proxy host."
  :type 'string)

(defcustom personal-proxy-http-port 1081
  "Set http(s) proxy port."
  :type 'integer)

(defcustom personal-proxy-socks5-port 1080
  "Set socks5 proxy port."
  :type 'integer)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(if (file-exists-p custom-file)
    (load custom-file))


(provide 'init-custom)

;;; init-custom.el ends here
