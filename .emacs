;; unix.emacs

(setq user-mail-address "lib.aca55a@gmail.com")

(setq load-path
      (nconc
       '(expand-file-name "~/apps/emacs" )
       '(expand-file-name "~/apps/emacs/packages" )
       '(expand-file-name "~/apps/emacs/packages/yasnippet" )
       '(expand-file-name "~/apps/emacs/packages/ensime/elisp" )
       '(expand-file-name "~/apps/emacs/packages/esense" )
       '(expand-file-name "~/apps/emacs/packages/erlang-mode" )
       '(expand-file-name "~/apps/emacs/packages/distel" )
       '(expand-file-name "~/apps/emacs/packages/wrangler" )
       '(expand-file-name "~/apps/emacs/packages/haskell-mode" )
       load-path))

;;(setq mac-command-modifier 'meta) ;;Sets the command (Apple) key as Meta

(load-library "emacs-general")
(load-library "emacs-keys")
(load-library "emacs-fontlock")
(load-library "emacs-packages")
(load-library "emacs-searchcurrent")

;; Remove unnecessary gui stuff
(setq inhibit-startup-message t)    ; no stupid messages about who did what
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

(setq auto-revert-interval 1)
;; (global-auto-revert-mode t)
(blink-cursor-mode 0) ;; no blink
(display-time)
(setq use-file-dialog nil)
(setq tags-case-fold-search nil)
(fset 'yes-or-no-p 'y-or-n-p)
;; "C-h d transient" for more info
(setq transient-mark-mode t)
(setq line-number-mode t)
(setq column-number-mode t)

(iswitchb-mode 1)        ; Show me my completions please
(setq iswitchb-case nil) ; completions are case sensitive.

; winner-mode for restoring windows configuration C-c Left/Right
(when (fboundp 'winner-mode)
  (winner-mode 1))

;; Delete trailing whitespace
(add-hook 'write-file-functions 'delete-trailing-whitespace)

;; Black Jeck
;; (set-background-color "black")
;; (set-face-background 'default "black")
;; (set-face-background 'region "black")
;; (set-face-foreground 'default "white")
;; (set-face-foreground 'region "gray60")
;; (set-foreground-color "white")
;; (set-cursor-color "red")

;; Chalk board
;(modify-frame-parameters (selected-frame) '((alpha . 75)))
(set-background-color "#2F3E35")
(set-face-background 'default "#2F3E35")
;; (set-face-background 'region "#2F3E35")
(set-face-foreground 'default "white")
(set-foreground-color "white")
(set-cursor-color "#dddddd")


;; end

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(blink-matching-paren-on-screen t)
 '(c-echo-syntactic-information-p nil)
 '(column-number-mode t)
 '(compilation-window-height 14)
 '(cscope-truncate-lines t)
 '(display-time-mode t)
 '(enable-local-variables :all)
 '(font-lock-global-modes t)
 '(global-font-lock-mode t nil (font-lock))
 '(haskell-program-name "ghci")
 '(inhibit-startup-screen t)
 '(menu-bar-mode nil)
 '(next-line-add-newlines nil)
 '(org-support-shift-select t)
 '(pc-selection-mode f nil (pc-select))
 '(show-paren-mode t nil (paren))
 '(show-paren-ring-bell-on-mismatch t)
 '(show-paren-style (quote parenthesis))
 '(tool-bar-mode nil)
 '(tooltip-mode nil)
 '(transient-mark-mode t)
 '(truncate-lines nil)
 '(truncate-partial-width-windows nil)
 '(vc-command-messages t)
 '(vc-initial-comment t)
 '(x-select-enable-clipboard t))

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#2F3E35" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 113 :width normal :foundry "unknown" :family "DejaVu Sans Mono"))))
 '(flymake-errline ((((class color)) (:underline "Red"))))
 '(flymake-warnline ((((class color)) (:underline "LightBlue2")))))

;; (set-default-font "-apple-Monaco-medium-normal-normal-*-18-*-*-*-m-0-iso10646-1")
(modify-frame-parameters nil '((wait-for-wm . nil)))

(server-start)

