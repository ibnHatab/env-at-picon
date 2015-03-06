
(setq auto-mode-alist
      (append '(
                ("\\.el$"                  . emacs-lisp-mode)
                ("\\.h$"                   . c-mode)
                ("\\.c$"                   . c-mode)
                ("\\.ec$"                  . c-mode)
                ("\\.C$"                   . c++-mode)
                ("\\.cc$"                  . c++-mode)
                ("\\.h?h$"                 . c++-mode)
                ("\\.idl$"                 . c++-mode)
                ("\\.ecpp$"                . c++-mode)
                ("\\.[ch]pp$"              . c++-mode)
                ("\\.[ch]xx$"              . c++-mode)
                ("\\.inl$"                 . c++-mode)
                ("\\.[Dd][Oo][Cc]$"        . text-mode)
                ("\\.java$"                . java-mode)
                ("ChangeLog$"              . change-log-mode)
                ("\\.emacs$"               . emacs-lisp-mode)
                ("\\.?[Ff][Aa][Qq]$"       . faq-mode)
                ("\\.js$"                  . js2-mode)
                ("\\.json$"                . espresso-mode)
                ("\\.mak$"                 . makefile-mode)
                ("\\<[mM]akefile$"         . makefile-mode)
                ("\\.out$"                 . compilation-mode)
                ("\\.[Tt][Xx][Tt]$"        . text-mode)
                ("\\.\\([pP][Llm]\\|al\\)$". perl-mode)
                ("\\.py$"                  . python-mode)
                ;; ("\\.css\\'"               . css-mode)
                ("\\.htm?\\'"              . web-mode)
                ("\\.xml?\\'"              . xml-mode)
                ("\\-MIB?\\'"              . snmpv2-mode)
                ("\\-MIB?\\'"              . snmpv2-mode)
		("\\.[Aa][Ss][Nn]\\([1]\\|[pP][pP]?\\)?$" . asn1-mode)
		("\\.[Aa][Ss][Nn][dD]$"    . asn1-diff-mode2)
                ("\\.lgo?\\'"              . logo-mode)
		("\\.ijs$"                 . j-mode)
		("\\.fs[iylx]?$"           . fsharp-mode)
		("\\.ml\\w?"               . tuareg-mode)
		("\\.hs\\w?"               . haskell-mode)
		("\\.yang"                 . yang-mode)
		("\\.erl$"                 . erlang-mode)
		("\\.hrl$"                 . erlang-mode)
		("\\.ie$"                  . erlang-mode)
		("\\.es$"                  . erlang-mode)
		("\\.app$"                 . erlang-mode)
;;		("\\.csp$"                 . csp-mode)
;;                ("\\.\\(d\\|s\\)ats\\'"    . ats-mode)
		("\\.org\\'"               . org-mode)
		("\\.m\\'"                 . octave-mode)
		("\\.mustache\\'"          . mustache-mode)
                ("\\.md\\'"                . markdown-mode)
                ("\\.groovy$"              . groovy-mode)
                ("\\.scala$"               . scala-mode)
                ("\\.sc"                   . scala-mode)
                ("\\.dot"                  . graphviz-dot-mode)
                ("\\.tjp"                  . taskjuggler-mode)
                ("\\.less"                 . less-css-mode)
                ("\\.css"                  . less-css-mode)
                ("\\.yml$"                 . yaml-mode)
                ("\\.rb$"                  . enh-ruby-mode)
                ("\\.djhtml\\'"            . web-mode)
                ("\\.erb\\'"               . web-mode)                
                )auto-mode-alist))


(setq url-proxy-services
      '(("no_proxy" . "^\\(localhost\\|10.*\\|0:4587\\)")
        ("http" . "cache.tm.alcatel.ro:8080")
        ("https" . "cache.tm.alcatel.ro:8080")))

;; ELPA
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
;;                         ("melpa" . "http://melpa.milkbox.net/packages/")
                         ))

(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t) ; Org-mode's repository
(package-initialize)

;; EL-GET
;; (add-to-list 'load-path "~/.emacs.d/el-get/el-get")
;; (unless (require 'el-get nil t)
;;   (url-retrieve
;;    "https://github.com/dimitri/el-get/raw/master/el-get-install.el"
;;    (lambda (s)
;;      (end-of-buffer)
;;      (eval-print-last-sexp))))

;; now set our own packages
(setq
 my:el-get-packages
 '(el-get				; el-get is self-hosting
   edts
   magit
   git-gutter  
   enh-ruby-mode
;;   robe
   yasnippet)) 				; powerful snippet mode

;; (el-get 'sync my:el-get-packages)

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
;; (setq enh-ruby-program "~/.rvm/rubies/ruby-2.2.0/bin/ruby")
(add-to-list 'interpreter-mode-alist '("ruby" . enh-ruby-mode))
(add-hook 'enh-ruby-mode-hook 'robe-mode)
(add-hook 'enh-ruby-mode-hook 'yard-mode)
(add-hook 'enh-ruby-mode-hook 'inf-ruby-minor-mode)
;; (add-hook 'after-init-hook 'inf-ruby-switch-setup) ;debug compilation

(defadvice inf-ruby-console-auto (before activate-rvm-for-robe activate)
  (rvm-activate-corresponding-ruby))

;; (add-hook 'ruby-mode-hook 'robe-mode)
(autoload 'inf-ruby "inf-ruby" "Run an inferior Ruby pathrocess" t)
(autoload 'inf-ruby-keys "inf-ruby" "" t)
(eval-after-load 'ruby-mode
  '(add-hook 'ruby-mode-hook 'inf-ruby-keys))

(require 'smartparens-config)
(require 'smartparens-ruby)
(smartparens-global-mode)
(show-smartparens-global-mode t)
(sp-with-modes '(rhtml-mode)
               (sp-local-pair "<" ">")
               (sp-local-pair "<%" "%>"))

;; Python
(require 'python)
(require 'elpy)

;; (setq elpy-rpc-backend "jedi")
(elpy-enable)
(elpy-use-ipython)

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
  (local-set-key "\M-?" 'cscope-find-this-symbol)
  (local-set-key "\M-," 'cscope-pop-mark)
  (local-set-key [(control f4)] 'cscope-find-functions-calling-this-function) ;; f4 References
  (local-set-key [(control f6)] 'cscope-display-buffer)                       ;; f6 display buffer
  (local-set-key [(control f7)] 'cscope-prev-symbol)                          ;; f7 prev sym
  (local-set-key [(control f8)] 'cscope-next-symbol)                          ;; f8 next sym
  (local-set-key [(control f9)] 'cscope-set-initial-directory)                ;; f9 set initial dir
  (local-set-key [(M-tab)]	'complete-tag )
  (local-set-key "\C-cm" #'expand-member-functions))

(add-hook 'c++-mode-hook 'cscope-keys)
(add-hook 'c-mode-hook 'cscope-keys)


