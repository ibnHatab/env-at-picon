;;; Code:  for package configuration
;;; Commentary:
;;; package --- Summary

(setq auto-mode-alist
      (append '(
                ;; ("\\.css\\'"               . css-mode)
                ("\\.xml?\\'"              . xml-mode)
                ("\\-MIB?\\'"              . snmpv2-mode)
                ("\\-MIB?\\'"              . snmpv2-mode)
		("\\.[Aa][Ss][Nn]\\([1]\\|[pP][pP]?\\)?$" . asn1-mode)
		("\\.[Aa][Ss][Nn][dD]$"    . asn1-diff-mode2)
		("\\.ml\\w?"               . tuareg-mode)
		("\\.hs\\w?"               . haskell-mode)
		("\\.yang"                 . yang-mode)
		("\\.erl$"                 . erlang-mode)
		("\\.hrl$"                 . erlang-mode)
		("\\.ie$"                  . erlang-mode)
		("\\.es$"                  . erlang-mode)
		("\\.app$"                 . erlang-mode)
                ("\\.dot"                  . graphviz-dot-mode)
                ("\\.tjp"                  . taskjuggler-mode)
                ("\\.less"                 . less-css-mode)
                ("\\.css"                  . less-css-mode)
                ("\\.yml$"                 . yaml-mode)
                ("\\.rb$"                  . enh-ruby-mode)
                ("\\.htm?\\'"              . web-mode)
                ("\\.djhtml\\'"            . web-mode)
                ("\\.erb\\'"               . web-mode)
                ("\\.s?css\\'"             . web-mode)
                ("\\.eex\\'"             . web-mode)
                )auto-mode-alist))

(setq url-using-proxy t)
(setq url-proxy-services
      '(("no_proxy" . "^\\(localhost\\|10.*\\|0:4587\\|127.*\\|.*:24969\\)")
        ("http"     . "135.245.192.6:8000")
        ("https"    . "135.245.192.6:8000")))

;; ELPA
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ))

(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t) ; Org-mode's repository

(package-initialize)


(add-hook 'after-init-hook #'global-flycheck-mode)

;; Yaml
(add-hook 'yaml-mode-hook
          '(lambda ()
             (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

;; BEGIN Erlang
(add-hook 'after-init-hook 'edts-after-init-hook)
(defun edts-after-init-hook ()
  (require 'edts-start)
  (local-set-key "\C-c\C-z" 'edts-shell)
)

;; Git
(require 'git-gutter)
(global-git-gutter-mode t)
;; - (add-hook 'ruby-mode-hook 'git-gutter-mode)
(global-set-key (kbd "C-x C-g") 'git-gutter:toggle)
(global-set-key (kbd "C-x v =") 'git-gutter:popup-hunk)
(global-set-key (kbd "C-x p") 'git-gutter:previous-hunk)
(global-set-key (kbd "C-x n") 'git-gutter:next-hunk)
(global-set-key (kbd "C-x r") 'git-gutter:revert-hunk)

;; Magit
(require 'magit)
(defcustom git-grep-switches "-E -I -nH -i --no-color"
  "Switches to pass to `git grep'."
  :type 'string)
(defcustom git-grep-default-work-tree (expand-file-name "~/code/mything")
  "Top of your favorite git working tree. \\[git-grep] will search from here if it cannot figure out where else to look."
  :type 'directory)
(when (require 'vc-git nil t)
  (defun git-grep (regexp)
    (interactive
     (list (read-from-minibuffer
            "Search git repo: "
            (let ((thing (and buffer-file-name
                              (thing-at-point 'symbol))))
              (or (and thing
                       (progn
                         (set-text-properties 0 (length thing) nil thing)
                         (shell-quote-argument (regexp-quote thing))))
                  ""))
            nil nil 'git-grep-history)))
    (let ((grep-use-null-device nil)
          (root (or (vc-git-root default-directory)
                    (prog1 git-grep-default-work-tree
                      (message "git-grep: %s doesn't look like a git working tree; searching from %s instead" default-directory root)))))
      (grep (format "GIT_PAGER='' git grep %s -e %s -- %s" git-grep-switches regexp root)))))
(global-set-key (kbd "C-x ?") 'git-grep)
(global-set-key "\C-xg" 'magit-status)

;; Ruby
(require 'robe)
(add-hook 'enh-ruby-mode-hook
          (lambda () (flyspell-prog-mode)))
(add-hook 'web-mode-hook
          (lambda () (flyspell-prog-mode)))
;; (setq enh-ruby-program "~/.rvm/rubies/ruby-2.2.0/bin/ruby")
(add-to-list 'interpreter-mode-alist '("ruby" . enh-ruby-mode))
(add-hook 'enh-ruby-mode-hook 'robe-mode)
;;; (add-hook 'web-mode-hook 'robe-mode)
(add-hook 'enh-ruby-mode-hook 'yard-mode)
(add-hook 'enh-ruby-mode-hook 'inf-ruby-minor-mode)
;; (add-hook 'after-init-hook 'inf-ruby-switch-setup) ;debug compilation

(add-hook 'enh-ruby-mode-hook 'company-mode)
(eval-after-load 'company
  '(push 'company-robe company-backends))


(add-hook 'ruby-mode-hook 'minitest-mode)
(eval-after-load 'minitest
  '(minitest-install-snippets))

(defadvice inf-ruby-console-auto (before activate-rvm-for-robe activate)
  (rvm-activate-corresponding-ruby))
(autoload 'inf-ruby "inf-ruby" "Run an inferior Ruby pathrocess" t)
(autoload 'inf-ruby-keys "inf-ruby" "" t)
(eval-after-load 'enh-ruby-mode
  '(add-hook 'ruby-mode-hook 'inf-ruby-keys))
(eval-after-load 'enh-ruby-mode
  '(add-hook 'ruby-mode-hook 'robe-start))

(require 'smartparens-config)
(require 'smartparens-ruby)
(smartparens-global-mode)
(show-smartparens-global-mode t)
(sp-with-modes '(web-mode)
               (sp-local-pair "<" ">")
               (sp-local-pair "<%" "%>"))

(add-hook 'enh-ruby-mode-hook
          '(lambda ()
             ;; (local-set-key (kbd "C-c C-z")   'inf-ruby)
             (local-set-key (kbd "C-c C-c")   'ruby-send-region-and-go)
             (define-key enh-ruby-mode-map (kbd "M-TAB") 'robe-complete-at-point)
             (define-key enh-ruby-mode-map (kbd "C-c C-z") 'inf-ruby)))


;; Projectile
(projectile-global-mode)

(add-hook 'enh-ruby-mode-hook 'projectile-mode)
(add-hook 'projectile-mode-hook 'projectile-rails-on)
(setq projectile-rails-keymap-prefix (kbd "s-a"))

(add-hook 'python-mode-hook 'projectile-mode)
(global-set-key (kbd "s-f") 'projectile-find-file)
(global-set-key (kbd "s-b") 'projectile-switch-to-buffer)

;; Python
(require 'python)
(require 'elpy)

(elpy-enable)
(elpy-use-ipython)
(setq elpy-rpc-backend "jedi")

;; (enable cscope)
(require 'xcscope)
(cscope-setup)
(setq cscope-database-regexps
      '(
        ( "^/udir/vlad/repos/femto-henb"
          ( t )
          ( "/udir/vlad/repos/femto-cpe")
          t
          ( "/udir/vlad/repos/net/buildroot-2011.11/output/build/linux-3.1/"
            ("-d" "-I/usr/include"))
          )
        ( "^/users/jdoe/sources/gnome/"
          ( "/master/gnome/database" ("-d") ))
        )
      )


(custom-set-variables
 '(cscope-truncate-lines t)
 '(cscope-do-not-update-database t)
 )

(defun cscope-keys ()
  (local-set-key "\M-." 'cscope-find-global-definition-no-prompting)
  (local-set-key "\M-," 'cscope-pop-mark)
  (local-set-key "\M-?" 'cscope-find-this-symbol)
  (local-set-key "\M-\\" 'cscope-find-functions-calling-this-function) ;; f4 References
  (local-set-key [(control f6)] 'cscope-display-buffer)                       ;; f6 display buffer
  (local-set-key [(control f7)] 'cscope-prev-symbol)                          ;; f7 prev sym
  (local-set-key [(control f8)] 'cscope-next-symbol)                          ;; f8 next sym
  (local-set-key [(control f9)] 'cscope-set-initial-directory)                ;; f9 set initial dir
  (local-set-key [(M-tab)]	'complete-tag )
  (local-set-key "\C-cm" #'expand-member-functions))

(add-hook 'c++-mode-hook 'cscope-keys)
(add-hook 'c-mode-hook 'cscope-keys)

;; Elixir
(require 'company)
(require 'elixir-mode)
(require 'alchemist)
(add-to-list 'elixir-mode-hook
             (defun my-emlixir-mode-hook ()
               (company-mode)
               (define-key elixir-mode-map (kbd "M-TAB")   'company-complete)
               (define-key elixir-mode-map (kbd "C-c C-s") 'alchemist-iex-project-run)
               (define-key elixir-mode-map (kbd "C-c C-z") 'alchemist-iex-start-process)
               (define-key elixir-mode-map (kbd "C-c C-r") 'alchemist-iex-send-region-and-go)
               (define-key elixir-mode-map (kbd "C-c C-c") 'alchemist-iex-send-current-line-and-go)
               (define-key elixir-mode-map (kbd "C-c C-d") 'alchemist-help-search-at-point)
               (define-key elixir-mode-map (kbd "C-c C-l") 'alchemist-iex-compile-this-buffer)
               (define-key elixir-mode-map (kbd "C-c C-t") 'alchemist-mix-test)
               ))


(add-to-list 'alchemist-iex-mode-hook
             (defun my-alchemis-mode-hook ()
               (company-mode)
;;               (define-key elixir-mode-map (kbd "M-TAB")   'company-complete)
               (define-key elixir-mode-map (kbd "C-c C-d") 'alchemist-help-search-at-point)
               ))

(require 'flycheck)
(flycheck-define-checker elixir
  "An Elixir syntax checker using the Elixir interpreter.

See URL `http://elixir-lang.org/'."
  :command ("elixirc"
            "-o" temporary-directory    ; Move compiler output out of the way
            "--ignore-module-conflict"  ; Prevent tedious module redefinition
                                        ; warning.
            source)
  :error-patterns
  ;; Elixir compiler errors
  ((error line-start "** (" (zero-or-more not-newline) ") "
          (file-name) ":" line ": " (message) line-end)
   ;; Warnings from Elixir >= 0.12.4
   (warning line-start (file-name) ":" line ": warning:" (message) line-end)
   ;; Warnings from older Elixir versions
   (warning line-start (file-name) ":" line ": " (message) line-end))
  :modes elixir-mode)

(add-to-list 'flycheck-checkers 'elixir)

(sp-with-modes '(elixir-mode)
  (sp-local-pair "fn" "end"
         :when '(("SPC" "RET"))
         :actions '(insert navigate))
  (sp-local-pair "do" "end"
         :when '(("SPC" "RET"))
         :post-handlers '(sp-ruby-def-post-handler)
         :actions '(insert navigate)))

;; weaves
;; Using Emacs support

(load "kdbp-mode")

(autoload 'q-mode "q-mode")
(autoload 'q-help "q-mode")
(autoload 'run-q "q-mode")
(autoload 'kdbp-mode "kdbp-mode")

;; To enable Q mode for *.q files, add the following to your emacs startup
;; file:

(setq auto-mode-alist (cons '("\\.[kq]$" . kdbp-mode) auto-mode-alist))

;; Scala
(require `scala-mode2)
(add-hook 'scala-mode-hook
          '(lambda ()
                                        ;               (company-mode)
             ;;               (define-key scala-mode-map (kbd "M-TAB")   'company-complete)
             (define-key scala-mode-map (kbd "C-c o") 'scala-outline-popup)
             ))

;; Ensime
(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)


;; Haskell
(require 'haskell-mode)
(require 'haskell-interactive-mode)
(require 'haskell-process)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)
(add-hook 'haskell-mode-hook 'haskell-indentation-mode)
(add-hook 'haskell-mode-hook 'auto-complete-mode)

(eval-after-load 'haskell-mode
  '(define-key haskell-mode-map [f8] 'haskell-navigate-imports))
(eval-after-load 'haskell-mode
  '(define-key haskell-mode-map (kbd "C-c C-o") 'haskell-compile))


(let ((my-cabal-path (expand-file-name "~/.cabal/bin")))
  (setenv "PATH" (concat my-cabal-path ":" (getenv "PATH")))
  (add-to-list 'exec-path my-cabal-path))

(autoload 'ghc-init "ghc" nil t)
(autoload 'ghc-debug "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda () (ghc-init)))

(require 'ac-haskell-process) ; if not installed via package.el
(add-hook 'interactive-haskell-mode-hook 'ac-haskell-process-setup)
(add-hook 'haskell-interactive-mode-hook 'ac-haskell-process-setup)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'haskell-interactive-mode))

(eval-after-load 'haskell-mode
  '(define-key haskell-mode-map (kbd "C-c C-d") 'ac-haskell-process-popup-doc))

(custom-set-variables
 '(haskell-tags-on-save t))

(require 'speedbar)
(speedbar-add-supported-extension ".hs")


;; Proof General
(load-file "/local/tools/ProofGeneral/generic/proof-site.el")
(setq coq-prog-name "/usr/bin/coqtop")


;; Elm
;; (add-hook 'elm-mode-hook #'elm-oracle-setup-completion)
(add-hook 'elm-mode-hook
          '(lambda ()
             #'elm-oracle-setup-completion
             (company-mode)
             (define-key scala-mode-map (kbd "M-TAB") 'company-complete)
             ))


(provide 'emacs-packages)
;;; emacs-packages.el Ends here
