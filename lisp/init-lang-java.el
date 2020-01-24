;; init-lang-java.el --- Java Configurations	-*- lexical-binding: t -*-

;; Author: Zsxh Chen <bnbvbchen@gmail.com>
;; URL: https://github.com/zsxh/emacs.d

;;; Commentary:
;;
;;  Java Configurations
;;

;;; Code:

(require 'init-language-server)

(use-package lsp-java
  :quelpa ((lsp-java :fetcher github :repo "emacs-lsp/lsp-java"))
  :defer t
  :config
  (require 'lsp-java-boot)
  (defun +java/lsp ()
    (lsp-java-boot-lens-mode)
    (lsp)))

(with-eval-after-load 'cc-mode
  ;; FIXME: when i put these codes in +java/setup, i have to toggle emacs/evil mode to activate keybindings, i think it's a bug of evil mode
  (+language-server/set-common-leader-keys java-mode-map)

  (+funcs/major-mode-leader-keys
   java-mode-map
   "c" '(+java/compile :which-key "compile")
   "dr" '(dap-java-debug :which-key "run")
   "dt" '(dap-java-debug-test-method :which-key "debug-junit-test-method")
   "dT" '(dap-java-debug-test-class :which-key "debug-junit-class")
   "i" '(nil :which-key "implement")
   "ic" '(lsp-java-add-import :which-key "import-class")
   "im" '(lsp-java-add-unimplemented-methods :which-key "add-unimplemented-methods")
   "ig" '(lsp-java-generate-getters-and-setters :which-key "generate-getters-and-setters")
   "j" '(+java/set-jdk :which-key "set-jdk")
   "r" '(nil :which-key "run")
   "rt" '(dap-java-run-test-method :which-key "run-junit-test-method")
   "rT" '(dap-java-run-test-class :which-key "run-junit-class")))

(add-hook-run-once 'java-mode-hook '+java/setup)

(defun +java/setup ()
  (require 'lsp-java)
  (+java/lsp)
  (add-hook 'java-mode-hook '+java/lsp)

  (defvar jdks-installed-dir "/usr/local/"
    "JDKs intalled directory.")

  (defun +java/set-jdk (jdk-version)
    "Select JDK-VERSION in `jdks-installed-dir' as global version,
JDK-VERSION directory name prefix \"jdk-\" is required,
`jdks-installed-dir'/jdk/bin in $PATH is required."
    (interactive (list (completing-read "JDK-version: " (+java/list-jdk-version))))
    (let ((target (expand-file-name jdk-version jdks-installed-dir))
          (link-name (expand-file-name "jdk" jdks-installed-dir)))
      (+funcs/sudo-shell-command (concat "ln -nsf " target " " link-name))))

  (defun +java/list-jdk-version ()
    "Find all jdks which start with \"jdk-\" in `jdks-installed-dir'"
    (let ((files (directory-files jdks-installed-dir))
          (result nil))
      (dolist (file files)
        (if (string-match "\\(graalvm\\|jdk\\)-" file)
            (push file result)))
      result))

  (defun +java/compile ()
    (interactive)
    (let ((default-directory (projectile-project-root))
          (compile-command "mvn clean compile test-compile"))
      (compile compile-command)
      (switch-to-buffer-other-window "*compilation*")
      (end-of-buffer))))


(provide 'init-lang-java)

;;; init-lang-java.el ends here
