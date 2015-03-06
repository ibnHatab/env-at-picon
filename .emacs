;; unix.emacs

;; Load default.el first.
(load "default" t t)
(setq inhibit-default-init t)

(setq user-mail-address "lib.aca55a@gmail.com")

(setq load-path
      (nconc
       '(expand-file-name "~/apps/emacs" )
       '(expand-file-name "~/apps/emacs/local")
       ;; '(expand-file-name "~/apps/emacs/packages/yasnippet" )
       ;; '(expand-file-name "~/apps/emacs/packages/ensime/elisp" )
       ;; '(expand-file-name "~/apps/emacs/packages/esense" )
       ;; '(expand-file-name "~/apps/emacs/packages/erlang" )
       ;; '(expand-file-name "~/apps/emacs/packages/distel" )
       ;; '(expand-file-name "~/apps/emacs/packages/wrangler" )
       ;; '(expand-file-name "~/apps/emacs/packages/haskell-mode" )
       ;; '(expand-file-name "~/apps/emacs/packages/org-mode/lisp" )
       ;; '(expand-file-name "~/apps/emacs/packages/org-mode/contrib/lisp" )
  ;; '(expand-file-name "~/apps/emacs/packages/python" )
       ;; '(expand-file-name "~/apps/emacs/packages/groovy" )
       ;; '(expand-file-name "~/apps/emacs/packages/scala-mode2" )
       ;; '(expand-file-name "/local/tools/scala/ensime/elisp/" )
       load-path))


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
 '(auto-revert-interval 2)
 '(blink-cursor-mode nil)
 '(blink-matching-paren-on-screen t)
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
    ("4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "1297a022df4228b81bc0436230f211bad168a117282c20ddcba2db8c6a200743" default)))
 '(display-time-mode t)
 '(electric-pair-mode 1)
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
 '(tags-case-fold-search nil)
 '(transient-mark-mode t)
 '(truncate-lines nil)
 '(truncate-partial-width-windows nil)
 '(use-file-dialog nil)
 '(vc-command-messages t)
 '(vc-initial-comment t)
 '(x-select-enable-clipboard t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 113 :width normal :foundry "unknown" :family "DejaVu Sans Mono"))))
 '(enh-ruby-op-face ((t nil)))
 '(flymake-errline ((t (:background "#002b36" :foreground "red" :inverse-video nil :underline (:color "brown" :style wave) :slant normal :weight bold))))
 '(flymake-warnline ((t (:background "#002b36" :foreground "deep sky blue" :inverse-video nil :underline "LightBlue2" :slant normal :weight bold)))))

(server-start)
