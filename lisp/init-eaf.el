;; init-eaf.el --- Emacs Application Framework	-*- lexical-binding: t -*-

;; Author: Zsxh Chen <bnbvbchen@gmail.com>
;; URL: https://github.com/zsxh/emacs.d

;;; Commentary:
;;
;;  Emacs Application Framework
;;

;;; Code:

(eval-when-compile
  (require 'init-custom))

;; https://github.com/manateelazycat/emacs-application-framework
(use-package eaf
  :commands (eaf-open eaf-open-url eaf-open-dash)
  :preface
  (defun eaf-qutebrowser ()
    (interactive)
    (eaf-open "eaf-qutebrowser"))
  :config
  (require 'dash)
  (when personal-eaf-grip-token
    (setq eaf-grip-token personal-eaf-grip-token))

  (when personal-http-proxy
    (let* ((host-port (split-string personal-http-proxy ":"))
           (host (nth 0 host-port))
           (port (nth 1 host-port)))
      (setq eaf-http-proxy-host host
            eaf-http-proxy-port port)))

  ;; hack eaf for evil-mode
  ;; send-key only in evil-emacs-state
  (add-hook 'eaf-mode-hook
            (lambda ()
              (company-mode -1)
              (setq-local evil-motion-state-map nil)
              ;; "C-z" normal-state -> emacs-state
              ;; ":" evil-ex
              (setq-local evil-normal-state-map
                          '(keymap
                            (58 . evil-ex)
                            (26 . evil-emacs-state)))))

  (defun +eaf/switch-to-eww ()
    (let* ((url buffer-url)
           (eww-buffer (car (-filter (lambda (buffer)
                                       (with-current-buffer buffer
                                         (and (derived-mode-p 'eww-mode)
                                              (equal url (plist-get eww-data :url)))))
                                     (buffer-list)))))
      (if eww-buffer
          (switch-to-buffer eww-buffer)
        (eww url))))

  (setq eaf-pdfviewer-keybinding
        '(("j" . "scroll_up")
          ("k" . "scroll_down")
          ("d" . "scroll_up_page")
          ("u" . "scroll_down_page")
          ("t" . "switch_to_read_mode")
          ("." . "scroll_to_home")
          ("," . "scroll_to_end")
          ("0" . "zoom_reset")
          ("=" . "zoom_in")
          ("-" . "zoom_out")
          ("g" . "jump_to_page")
          ("p" . "jump_to_percent")
          ("[" . "remember_current_position")
          ("]" . "remeber_jump")
          ("i" . "toggle_inverted_mode")))

  (setq eval-normal-state-eaf-browser-keybinding
        '(("F" . "history_forward")
          ("H" . "history_backward")
          ("M-q" . "clean_all_cookie")
          ("-" . "zoom_out")
          ("=" . "zoom_in")
          ("0" . "zoom_reset")
          ("j" . "scroll_up")
          ("k" . "scroll_down")
          ("d" . "scroll_up_page")
          ("u" . "scroll_down_page")
          ("M-<" . "scroll_to_begin")
          ("M->" . "scroll_to_bottom")))

  (defun eaf-open-dash (url &optional args)
    (interactive)
    (eaf-open url "browser" nil))

  (defun eaf-monitor-key-event ()
    (unless
        (ignore-errors
          (with-current-buffer (buffer-name)
            (when (eq major-mode 'eaf-mode)
              (let* ((event last-command-event)
                     (key (make-vector 1 event))
                     (key-command (format "%s" (key-binding key)))
                     (key-desc (key-description key)))

                ;; Uncomment for debug.
                ;; (message (format "!!!!! %s %s %s %s %s" event key key-command key-desc buffer-app-name))

                (cond
                 ;; Fix #51 , don't handle F11 to make emacs toggle frame fullscreen status successfully.
                 ((equal key-desc "<f11>")
                  t)
                 ((and (member buffer-app-name '("browser" "markdown-previewer"))
                       (not (or (evil-emacs-state-p) (evil-insert-state-p))))
                  (cond
                   ((string-equal key-desc "h")
                    (eaf-call "send_key" buffer-id "<left>"))
                   ((string-equal key-desc "l")
                    (eaf-call "send_key" buffer-id "<right>"))
                   ((string-equal key-desc "T")
                    (+eaf/switch-to-eww))
                   (t
                    (eaf-handle-app-key buffer-id key-desc eval-normal-state-eaf-browser-keybinding))))
                 ;; Just send event when user insert single character.
                 ;; Don't send event 'M' if user press Ctrl + M.
                 ((and (or
                        (equal key-command "self-insert-command")
                        (equal key-command "completion-select-if-within-overlay"))
                       (equal 1 (string-width (this-command-keys))))
                  (cond ((equal buffer-app-name "pdf-viewer")
                         (eaf-handle-app-key buffer-id key-desc eaf-pdfviewer-keybinding))
                        ((equal buffer-app-name "video-player")
                         (eaf-handle-app-key buffer-id key-desc eaf-videoplayer-keybinding))
                        ((equal buffer-app-name "image-viewer")
                         (eaf-handle-app-key buffer-id key-desc eaf-imageviewer-keybinding))
                        ((equal buffer-app-name "camera")
                         (eaf-handle-app-key buffer-id key-desc eaf-camera-keybinding))
                        (t
                         (eaf-call "send_key" buffer-id key-desc))))
                 ((string-match "^[CMSs]-.*" key-desc)
                  (cond ((equal buffer-app-name "browser")
                         (let ((function-name-value (assoc key-desc eaf-browser-keybinding)))
                           (if function-name-value
                               (eaf-call "execute_function" buffer-id (cdr function-name-value))
                             (let ((key-alias-value (assoc key-desc eaf-browser-key-alias)))
                               (if key-alias-value
                                   (eaf-call "send_key" buffer-id (cdr key-alias-value)))))))
                        ((equal buffer-app-name "terminal")
                         (let ((function-name-value (assoc key-desc eaf-terminal-keybinding)))
                           (when function-name-value
                             (eaf-call "execute_function" buffer-id (cdr function-name-value)))))))
                 ((or
                   (equal key-command "nil")
                   (equal key-desc "RET")
                   (equal key-desc "DEL")
                   (equal key-desc "TAB")
                   (equal key-desc "SPC")
                   (equal key-desc "<backtab>")
                   (equal key-desc "<home>")
                   (equal key-desc "<end>")
                   (equal key-desc "<left>")
                   (equal key-desc "<right>")
                   (equal key-desc "<up>")
                   (equal key-desc "<down>")
                   (equal key-desc "<prior>")
                   (equal key-desc "<next>"))
                  (eaf-call "send_key" buffer-id key-desc))
                 (t
                  (unless (or
                           (equal key-command "keyboard-quit")
                           (equal key-command "kill-this-buffer")
                           (equal key-command "eaf-open"))
                    (ignore-errors (call-interactively (key-binding key)))))))
              ;; Set `last-command-event' with nil, emacs won't notify me buffer is ready-only,
              ;; because i insert nothing in buffer.
              (setq last-command-event nil))))
      ;; If something wrong in `eaf-monitor-key-event', emacs will remove `eaf-monitor-key-event' from `pre-command-hook' hook list.
      ;; Then we add `eaf-monitor-key-event' in `pre-command-hook' list again, hahahaha.
      (run-with-timer
       0.1
       nil
       (lambda ()
         (progn
           (add-hook 'pre-command-hook #'eaf-monitor-key-event)))))))


;; Pdf viewer settings
(add-to-list 'auto-mode-alist
             '("\\.pdf\\'" . (lambda ()
                               (let ((filename buffer-file-name))
                                 (eaf-open filename)
                                 (kill-buffer (file-name-nondirectory filename))))))


(provide 'init-eaf)

;;; init-eaf.el ends here
