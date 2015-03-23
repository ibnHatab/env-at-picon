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
                )auto-mode-alist))

(setq url-using-proxy t)
(setq url-proxy-services
      '(("no_proxy" . "^\\(localhost\\|10.*\\|0:4587\\|127.*\\|.*:24969\\)")
        ("http"     . "cache.tm.alcatel.ro:8080")
        ("https"    . "cache.tm.alcatel.ro:8080")))

;; ELPA
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ))

(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t) ; Org-mode's repository

(package-initialize)

;; package-activated-list
(setq package-list '(ac-inf-ruby auto-complete popup inf-ruby bm color-theme-sanityinc-solarized color-theme-solarized color-theme django-mode edts popup f dash s erlang eproject helm async dash auto-highlight-symbol auto-complete popup elixir-mode elixir-yasnippets yasnippet elpy yasnippet pyvenv highlight-indentation find-file-in-project company enh-ruby-mode eproject helm async erlang find-file-in-project git-gutter helm async highlight-indentation hippie-exp-ext jedi auto-complete popup jedi-core python-environment deferred epc ctable concurrent deferred jedi-core python-environment deferred epc ctable concurrent deferred magit git-rebase-mode git-commit-mode multiple-cursors popup projectile-rails rake dash f dash s f dash s inf-ruby inflections projectile pkg-info epl dash projectile-speedbar projectile pkg-info epl dash python-environment deferred pyvenv rake dash f dash s robe inf-ruby rvm s smartparens dash sr-speedbar web-mode xcscope yard-mode yasnippe))

(defun package-install-missing ()
  (interactive
   ;; fetch the list of packages available
   (unless package-archive-contents
     (package-refresh-contents))
   ;; install the missing packages
   (dolist (package package-list)
     (unless (package-installed-p package)
       (package-install package)))
   ))


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
(require 'auto-complete-config)
(ac-config-default)
(setq ac-ignore-case nil)
(add-to-list 'ac-modes 'enh-ruby-mode)
(add-to-list 'ac-modes 'web-mode)
(add-hook 'enh-ruby-mode-hook
          (lambda () (flyspell-prog-mode)))
(add-hook 'web-mode-hook
          (lambda () (flyspell-prog-mode)))
(ac-flyspell-workaround)
(setq enh-ruby-program "~/.rvm/rubies/ruby-2.2.0/bin/ruby")
(add-to-list 'interpreter-mode-alist '("ruby" . enh-ruby-mode))
(add-hook 'enh-ruby-mode-hook 'robe-mode)
(add-hook 'enh-ruby-mode-hook 'yard-mode)
(add-hook 'enh-ruby-mode-hook 'inf-ruby-minor-mode)
;; (add-hook 'after-init-hook 'inf-ruby-switch-setup) ;debug compilation
(add-hook 'ruby-mode-hook 'minitest-mode)
(eval-after-load 'minitest
  '(minitest-install-snippets))


(defadvice inf-ruby-console-auto (before activate-rvm-for-robe activate)
  (rvm-activate-corresponding-ruby))

;; (add-hook 'ruby-mode-hook 'robe-mode)
(autoload 'inf-ruby "inf-ruby" "Run an inferior Ruby pathrocess" t)
(autoload 'inf-ruby-keys "inf-ruby" "" t)
(eval-after-load 'enh-ruby-mode
  '(add-hook 'ruby-mode-hook 'inf-ruby-keys))

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
;;?? (projectile-global-mode)
(add-hook 'enh-ruby-mode-hook 'projectile-mode)
(global-set-key (kbd "s-p") 'projectile-find-file)
(global-set-key (kbd "s-b") 'projectile-switch-to-buffer)

;; Python
(require 'python)
(require 'elpy)

;; (setq elpy-rpc-backend "jedi")
(elpy-enable)
(elpy-use-ipython)
(add-hook 'python-mode-hook 'projectile-mode)

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
               (define-key elixir-mode-map (kbd "C-c C-z") 'alchemist-iex-send-region-and-go)
               (define-key elixir-mode-map (kbd "C-c C-c") 'alchemist-iex-send-region)
               (define-key elixir-mode-map (kbd "C-c C-d") 'alchemist-help-search-at-point)
               (define-key elixir-mode-map (kbd "C-c C-l") 'alchemist-iex-compile-this-buffer)
               (define-key elixir-mode-map (kbd "C-c C-t") 'alchemist-mix-test)
               ))


(add-to-list 'alchemist-iex-mode-hook
             (defun my-alchemis-mode-hook ()
               (company-mode)
               (define-key elixir-mode-map (kbd "M-TAB")   'company-complete)
               (define-key elixir-mode-map (kbd "C-c C-d") 'alchemist-help-search-at-point)
               ))


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


(provide 'emacs-packages)
;;; emacs-packages.el Ends here
