(require 'site-gentoo)
(package-initialize)
(add-to-list 'load-path "~/.emacs.d/emacs-lisp")
(load "~/.emacs.d/emacs-lisp/imathconv.el")
(require 'anything)
;;(require 'ipython)
;;(setq py-python-command-args '("--matplotlib" "--colors" "LightBG"))

(require 'smart-tab)
(global-smart-tab-mode 1)

(require 'anything-config)
(setq anything-sources
      (list
       anything-c-source-man-pages
       anything-c-source-locate
       anything-c-source-occur
       anything-c-source-buffers
       anything-c-source-emacs-commands))

(setq inhibit-startup-message t)		     
(setq default-major-mode 'text-mode)
;;(add-hook 'text-mode-hook 'turn-on-auto-fill)
;; (normal-erase-is-backspace-mode)
;; add conf files to auto-mode-alist
(setq auto-mode-alist (cons '("\\.conf$" . shell-script-mode) auto-mode-alist))
;; add fortran 95 files to auto-mode-alist
(setq auto-mode-alist (cons '("\\.f95$" . f90-mode) auto-mode-alist))
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(add-to-list 'auto-mode-alist '("SConstruct" . python-mode))
(add-to-list 'auto-mode-alist '("SConscript" . python-mode))
(add-to-list 'auto-mode-alist '("\\.cu$" . c-mode))
(add-to-list 'auto-mode-alist '("\\.imath$" . imath-mode))

(setq url-proxy-services
      '(("no_proxy" . "^\\(localhost\\|10.*\\)")
	("http" . "odysseus:3128")
	("https" . "odysseus:3128")))


(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;; setting up python according to http://www.emacswiki.org/emacs/PythonProgrammingInEmacs#toc5
(setq
 python-shell-interpreter "ipython"
 python-shell-interpreter-args ""
 python-shell-prompt-regexp "In \\[[0-9]+\\]: "
 python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
 python-shell-completion-setup-code
   "from IPython.core.completerlib import module_completion"
 python-shell-completion-module-string-code
   "';'.join(module_completion('''%s'''))\n"
 python-shell-completion-string-code
   "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")

;;imath helper
(defun imath-clean ()
  "Cleans latex from imath mode"
  (interactive)
  (replace-regexp "\&{latex.*?latex}" ""))

;;ido
(require 'ido)
(ido-mode t)

;; ident or complete using tab
(defun indent-or-expand (arg)
  "Either indent according to mode, or expand the word preceding
point."
  (interactive "*P")
  (if (and
       (or (bobp) (= ?w (char-syntax (char-before))))
       (or (eobp) (not (= ?w (char-syntax (char-after))))))
      (dabbrev-expand arg)
    (indent-according-to-mode)))

;;flycheck
;; turn on flychecking globally
;; use web-mode for .jsx files
(require 'flycheck)
(add-to-list 'auto-mode-alist '("\\.jsx$" . web-mode))
(add-hook 'after-init-hook #'global-flycheck-mode)
;; disable jshint since we prefer eslint
(setq-default flycheck-disabled-checkers
	      (append flycheck-disabled-checkers
		      '(javascript-jshint)))
;; use eslint with web-mode for jsx files
(flycheck-add-mode 'javascript-eslint 'web-mode)
;; disable json-jsonlist checking for json files
(setq-default flycheck-disabled-checkers
	      (append flycheck-disabled-checkers
		      '(json-jsonlist)))

(add-to-list 'auto-mode-alist '("\\.html$" . web-mode))
(require 'web-mode)
(defun my-web-mode-hook ()
  "hooks for web mode"
  (setq web-mode-code-indent-offset 4)
  (setq web-mode-markup-indent-offset 4)
  (setq web-mode-css-indent-offset 4))
(add-hook 'web-mode-hook 'my-web-mode-hook)

(setq imaxima-use-maxima-mode-flag t)

;;(defun indent-or-complete ()
;;  "Complete if point is at end of line, and indent line."
;;  (interactive)
;;  (if (looking-at "$")
;;      (hippie-expand nil))
;;  (indent-for-tab-command)
;;)
;; map that to tab in files
;;(add-hook 
;; 'find-file-hooks 
;; (function (lambda ()
;;	     (local-set-key (kbd "TAB") 'indent-or-complete))))
;;(defun my-tab-fix ()
;;  (local-set-key [tab] 'indent-or-expand))
;;(local-set-key [tab] 'indent-or-expand)
;;(add-hook 'c-mode-hook          'my-tab-fix)
;;(add-hook 'sh-mode-hook         'my-tab-fix)
;;(add-hook 'emacs-lisp-mode-hook 'my-tab-fix)
;;(add-hook 'c++-mode-hook        'my-tab-fix)

;; MELPA
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)

;; semantic
(package-initialize)

(show-paren-mode t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" default)))
 '(ecb-layout-name "pel1")
 '(ecb-options-version "2.40")
 '(global-font-lock-mode t nil (font-lock))
 '(global-smart-tab-mode t)
 '(org-agenda-files (quote ("~/org/notes.org" "~/marion/notes.org")))
 '(yas-global-mode t nil (yasnippet))
 )

(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (load-theme 'solarized-dark)
     ))


;(setq org-default-notes-file (concat org-directory "/notes.org"))
;(define-key global-map "\C-cc" 'org-capture)
;(define-key global-map "\C-ca" 'org-agenda)

(put 'narrow-to-region 'disabled nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;;; init.el ends here

