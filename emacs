;; Joongi's .emacs
;; -*- mode: lisp; tab-indent: 2 -*-
;; Some parts are taken from netj's dotfiles repository:
;; https://github.com/netj/dotfiles/blob/master/.emacs

(set-language-environment "UTF-8")
(set-language-environment-input-method "Korean")
(setq shell-command-switch "-ic")

;; Emacs24 package manager
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives
               '("elpa" . "http://tromey.com/elpa/") t)
  (add-to-list 'package-archives
  	     '("melpa" . "http://melpa.milkbox.net/packages/") t)
  (add-to-list 'package-archives
               '("marmalade" . "http://marmalade-repo.org/packages/") t)
)

;; Respect local config
(load "~/.emacs_local" t)

;; My customization of default environment
(icomplete-mode)
(setq case-fold-search t)
(setq kill-whole-line t)
(setq make-backup-files nil)
(auto-compression-mode t)
(setq-default auto-fill-function 'do-auto-fill)
(setq fill-column 78)
(tool-bar-mode 0)
(menu-bar-mode 1)
(column-number-mode t)
(global-linum-mode t)

;; Indentation: default is 4 spaces
(setq-default indent-tabs-mode nil)
(setq tab-width 4)
(defvaralias 'c-basic-offset 'tab-width)
(defvaralias 'cperl-indent-level 'tab-width)

;; Line numbers
(unless window-system
  (add-hook 'linum-before-numbering-hook
	    (lambda ()
	      (setq linum-format-fmt
			  (let ((w (length (number-to-string
					    (count-lines (point-min) (point-max))))))
			    (concat "%" (number-to-string w) "d"))))))
(defun linum-format-func (line)
  (concat
   (propertize (format linum-format-fmt line) 'face 'linum)
   (propertize " " 'face 'linum)))
(unless window-system
  (setq linum-format 'linum-format-func))

;; Custom packages
(unless (require 'sr-speedbar nil 'noerror)
  (message "sr-speedbar package is not installed!"))
(when (require 'smart-tabs-mode nil 'noerror)
  (smart-tabs-insinuate 'c 'c++ 'javascript))

;; Color theme
(if (require 'solarized-theme nil 'noerror)
  (progn (setq solarized-contrast 'high)
         (load-theme 'solarized-dark t))
  (progn (message "solarized-theme is not installed; falling back to wombat.")
         (load-theme 'wombat)))

;; Font
(when (eq system-type 'darwin)
  (create-fontset-from-fontset-spec
   "-*-*-*-*-*-*-16-160-*-*-*-*-fontset-j,
      latin:-apple-Consolas-*-*-*-*-*-*-*-*-m-*-iso10646-1,
     hangul:-apple-나눔고딕코딩-*-*-*-*-*-*-*-*-p-*-iso10646-1")
  (frame-attr '(font . "-*-16-*-fontset-j"))
)
(when (eq system-type 'windows-nt)
  (set-face-font 'default "-outline-Consolas-normal-normal-normal-mono-13-*-*-*-c-*-iso10646-1")
  (set-fontset-font "fontset-default" 'hangul '("NanumGothicCoding" . "unicode-bmp"))
  (global-set-key [C-kanji] 'set-mark-command)
)

;;(add-to-list 'load-path "~/.emacs.d/elpa/org-20131206/")
;;(require 'org)
;; Org-mode configurations
(org-babel-do-load-languages
 (quote org-babel-load-languages)
 (quote ((emacs-lisp . t)
         (dot . t)
         (ditaa . t)
         (R . t)
         (python . t)
         (ruby . t)
         (gnuplot . t)
         (clojure . t)
         (sh . t)
         (ledger . t)
         (org . t)
         (plantuml . t)
         (latex . t))))

