;; unix.emacs

;; Load default.el first.
(load "default" t t)
(setq inhibit-default-init t)

(setq user-mail-address "lib.aca55a@gmail.com")

(setq load-path
      (nconc
       '(expand-file-name "~/apps/emacs" )
       '(expand-file-name "~/apps/emacs/local")
       load-path))

(set-default-font "Courier 10")

(load-library "emacs-general")
(load-library "emacs-packages")
(load-library "emacs-keys")

(setq inhibit-startup-message t)
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-revert-interval 60)
 '(blink-cursor-mode nil)
 '(blink-cursor-mode t)
 '(cursor-type 'bar)
 '(blink-matching-paren-on-screen t)
 '(bm-cycle-all-buffers t)
 '(bm-highlight-style (quote bm-highlight-only-fringe))
 '(c-echo-syntactic-information-p nil)
 '(column-number-mode t)
 '(compilation-window-height 14)
 '(cscope-do-not-update-database t)
 '(cscope-program-args (quote "-q"))
 '(cscope-truncate-lines t)
 '(cscope-use-relative-paths t)
 '(custom-enabled-themes (quote (sanityinc-solarized-dark)))
 '(custom-safe-themes
   (quote
    ("4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4" "4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "1297a022df4228b81bc0436230f211bad168a117282c20ddcba2db8c6a200743" default)))
 '(delete-selection-mode t)
 '(display-time-mode t)
 '(enable-local-variables :all)
 '(flymake-no-changes-timeout 12)
 '(follow-auto t)
 '(font-lock-global-modes t)
 '(global-auto-revert-mode 1)
 '(global-font-lock-mode t nil (font-lock))
 '(kill-whole-line t)
 '(line-number-mode t)
 '(menu-bar-mode nil)
 '(next-line-add-newlines nil)
 '(nxml-attribute-indent 1)
 '(nxml-child-indent 1)
 '(org-support-shift-select (quote always))
 '(safe-local-variable-values (quote ((c-set-style "linux"))))
 '(show-paren-mode t nil (paren))
 '(show-paren-ring-bell-on-mismatch t)
 '(show-paren-style (quote parenthesis))
 '(speedbar-show-unknown-files t)
 '(speedbar-use-images nil)
 '(speedbar-verbosity-level 0)
 '(sr-speedbar-auto-refresh t)
 '(sr-speedbar-default-width 42)
 '(sr-speedbar-skip-other-window-p t)
 '(tags-case-fold-search nil)
 '(transient-mark-mode t)
 '(truncate-lines nil)
 '(truncate-partial-width-windows nil)
 '(use-file-dialog nil)
 '(vc-command-messages t)
 '(vc-initial-comment t)
 '(x-select-enable-clipboard t)
;; '(x-select-enable-primary t)
 ;; '(x-select-enable-clipboard-manager t)
 )

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
;; '(default ((t (:background "#002b36" :foreground "#839496" :family "courier"))))
 '(enh-ruby-op-face ((t nil)))
 '(erm-syn-errline ((t (:underline (:color "orange red" :style wave) :weight bold))))
 '(erm-syn-warnline ((t (:underline (:color "dark orange" :style wave) :weight bold))))
 '(flymake-errline ((t (:background "#002b36" :foreground "red" :inverse-video nil :underline (:color "brown" :style wave) :slant normal :weight bold))))
 '(flymake-warnline ((t (:background "#002b36" :foreground "deep sky blue" :inverse-video nil :underline "LightBlue2" :slant normal :weight bold)))))


;; Switch to the first theme in the list above
(cycle-my-theme)

(server-start)
