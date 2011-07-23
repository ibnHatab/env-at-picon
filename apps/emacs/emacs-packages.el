
(setq auto-mode-alist
      (append '(
                ("\\.el$"                  . emacs-lisp-mode)
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
                ("\\.css\\'"               . css-mode)
                ("\\.htm?\\'"              . html-mode)
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
		("\\.scala"                . scala-mode)
		("\\.erl$"                 . erlang-mode)
		("\\.hrl$"                 . erlang-mode)
		("\\.ie$"                  . erlang-mode)
		("\\.es$"                  . erlang-mode)
		("\\.csp$"                 . csp-mode)
                )auto-mode-alist))

;; CSP
(require 'csp-mode)

;; Erlang

(setq erlang-root-dir   "/udir/tools/otp/lib/erlang")
(add-to-list 'exec-path "/udir/tools/otp/lib/erlang/bin")
(defvar inferior-erlang-prompt-timeout t)

(add-hook 'erlang-load-hook 'my-erlang-load-hook)
(defun my-erlang-load-hook ()
  (setq erlang-compile-extra-opts '(debug_info (i . \"../include\")))
)

(add-hook 'erlang-mode-hook 'my-erlang-mode-hook)
(defun my-erlang-mode-hook ()
        (setq inferior-erlang-machine-options 
	      '("-sname" "emacs" "-pa" "../ebin" "-pa" "../test" "-pa" "../.eunit"))
        (imenu-add-to-menubar "imenu")
        (local-set-key [return] 'newline-and-indent)
        (local-set-key "\C-c\C-m" 'erlang-man-function)
        )

;; EQC Emacs Mode -- Configuration Start
(autoload 'eqc-erlang-mode-hook "eqc-ext" "EQC Mode" t)
(add-hook 'erlang-mode-hook 'eqc-erlang-mode-hook)
(setq eqc-max-menu-length 30)
(setq eqc-root-dir "/udir/tools/otp/lib/erlang/lib/eqc-1.20.3")

;; Distel (erlang)
(require 'distel)
(distel-setup)

(defconst distel-shell-keys
  '(("\C-\M-i" erl-complete)
    ("\M-?" erl-complete)
    ("\M-." erl-find-source-under-point)
    ("\M-," erl-find-source-unwind)
    ("\M-*" erl-find-source-unwind)
    )
  "Additional keys to bind when in Erlang shell.")
(add-hook 'erlang-shell-mode-hook
 	  (lambda ()
 	    (dolist (spec distel-shell-keys)
 	      (define-key erlang-shell-mode-map (car spec) (cadr spec)))))


;; Flymake
(require 'flymake)
(defun flymake-erlang-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
		     'flymake-create-temp-with-folder-structure))
;;  		     'flymake-create-temp-inplace))
  	 (local-file (file-relative-name
  		      temp-file
  		      (file-name-directory buffer-file-name))))
    (list "~/bin/eflymake" (list local-file))))

(add-to-list 'flymake-allowed-file-name-masks
 	     '("\\.erl\\'" flymake-erlang-init))

(add-hook 'find-file-hook 'flymake-find-file-hook)


;; Esense
(require 'esense-start)
(setq esense-indexer-program
      (concat (getenv "HOME") "/apps/emacs/packages/esense/esense.sh"))

(require 'erlang-start)

(require 'wrangler)
;; erlang

;; comint
(require 'comint)
(define-key comint-mode-map [(meta p)]
  'comint-previous-matching-input-from-input)
(define-key comint-mode-map [(meta n)]
  'comint-next-matching-input-from-input)
(define-key comint-mode-map [(control meta n)]
  'comint-next-input)
(define-key comint-mode-map [(control meta p)]
  'comint-previous-input)


;; java script
;; javascript-mode
;; (autoload 'javascript-mode "javascript" nil t)
;; (autoload 'inferior-moz-mode "moz" "MozRepl Inferior Mode" t)
;; (autoload 'moz-minor-mode "moz" "MozRepl Minor Mode" t)
;; (add-hook 'javascript-mode-hook 'javascript-moz-setup)
;; (defun javascript-moz-setup () (moz-minor-mode 1))

;; espresso-mode + js2
(autoload #'espresso-mode "espresso" "Start espresso-mode" t)
(autoload 'js2-mode "js2-mode" nil t)

(defun my-js2-indent-function ()
  (interactive)
  (save-restriction
    (widen)
    (let* ((inhibit-point-motion-hooks t)
           (parse-status (save-excursion (syntax-ppss (point-at-bol))))
           (offset (- (current-column) (current-indentation)))
           (indentation (espresso--proper-indentation parse-status))
           node)

      (save-excursion
	
        ;; I like to indent case and labels to half of the tab width
        (back-to-indentation)
        (if (looking-at "case\\s-")
            (setq indentation (+ indentation (/ espresso-indent-level 2))))

        ;; consecutive declarations in a var statement are nice if
        ;; properly aligned, i.e:
        ;;
        ;; var foo = "bar",
        ;;     bar = "foo";
        (setq node (js2-node-at-point))
        (when (and node
                   (= js2-NAME (js2-node-type node))
                   (= js2-VAR (js2-node-type (js2-node-parent node))))
	  (setq indentation (+ 4 indentation))))

      (indent-line-to indentation)
      (when (> offset 0) (forward-char offset)))))

(defun my-js2-mode-hook ()
  (require 'espresso)
  (setq espresso-indent-level 4
        indent-tabs-mode nil
        c-basic-offset 4)
  (c-toggle-auto-state 0)
  (c-toggle-hungry-state 1)
  (set (make-local-variable 'indent-line-function) 'my-js2-indent-function)
  (define-key js2-mode-map [(meta control |)] 'cperl-lineup)
  (define-key js2-mode-map [(meta control \;)] 
    '(lambda()
       (interactive)
       (insert "/* -----[ ")
       (save-excursion
         (insert " ]----- */"))
       ))
  (define-key js2-mode-map [(return)] 'newline-and-indent)
  (define-key js2-mode-map [(backspace)] 'c-electric-backspace)
  (define-key js2-mode-map [(control d)] 'c-electric-delete-forward)
  (define-key js2-mode-map [(control meta q)] 'my-indent-sexp)
  (if (featurep 'js2-highlight-vars)
      (js2-highlight-vars-mode))
  (message "My JS2 hook"))

(add-hook 'js2-mode-hook 'my-js2-mode-hook)

;; MOZ
(autoload 'moz-minor-mode "moz" "Mozilla Minor and Inferior Mozilla Modes" t)
(add-hook 'js2-mode-hook 'js2-custom-setup)
(defun js2-custom-setup ()
  (moz-minor-mode 1))

;; M-x moz-reload-mode 
(define-minor-mode moz-reload-mode
  "Moz Reload Minor Mode"
  nil " Reload" nil
  (if moz-reload-mode
      ;; Edit hook buffer-locally.
      (add-hook 'after-save-hook 'moz-reload nil t)
    (remove-hook 'after-save-hook 'moz-reload t)))

(defun moz-reload ()
    (moz-firefox-reload))

(defun moz-firefox-reload ()
  (comint-send-string (inferior-moz-process) "BrowserReload();"))

;; Node.JS REPL
;; M-x run-js
(require 'js-comint) 
(setq inferior-js-program-command "node-no-readline") 
(add-hook 'js2-mode-hook '(lambda () 
			    (local-set-key "\C-x\C-e" 'js-send-last-sexp)
			    (local-set-key "\C-cb"    'js-send-buffer)
;;			    (local-set-key "\C-\M-x" 'js-send-last-sexp-and-go)
;;			    (local-set-key "\C-c\C-b" 'js-send-buffer-and-go)
;;			    (local-set-key "\C-cl" 'js-load-file-and-go)
			    ))


;; (require 'flymake)

;; (defun flymake-jslint-init ()
;;   (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                      'flymake-create-temp-inplace))
;;          (local-file (file-relative-name
;;                       temp-file
;;                       (file-name-directory buffer-file-name))))
;;     (list "/usr/local/bin/jsflakes" (list local-file))))

;; (setq flymake-allowed-file-name-masks
;;       (cons '(".+\\.js$"
;;               flymake-jslint-init
;;               flymake-simple-cleanup
;;               flymake-get-real-file-name)
;;             flymake-allowed-file-name-masks))

;; (setq flymake-err-line-patterns
;;       (cons '("^Lint at line \\([[:digit:]]+\\) character \\([[:digit:]]+\\): \\(.+\\)$"
;;               nil 1 2 3)
;;             flymake-err-line-patterns))

;; (provide 'flymake-jslint)
;; (require 'flymake-jslint)
;; (add-hook 'javascript-mode-hook
;;           (lambda () (flymake-mode 1)))


;; Haskell
(require 'haskell-mode)
(require 'inf-haskell)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-hugs)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
(add-hook 'haskell-mode-hook 'font-lock-mode)
(add-hook 'haskell-mode-hook '(lambda () (capitalized-words-mode t)))
(custom-set-variables 
 '(haskell-program-name "ghci"))
;; (setq haskell-font-lock-symbols t)

;; Scala
(require 'scala-mode-auto)
(add-hook 'scala-mode-hook
 	  '(lambda ()
 	     (yas/minor-mode-on)
 	     )) 
(defun me-turn-off-indent-tabs-mode ()
  (setq indent-tabs-mode nil))
(add-hook 'scala-mode-hook   'me-turn-off-indent-tabs-mode)

;; Yasnippet
(require 'yasnippet) ;; not yasnippet-bundle
(yas/initialize)
(yas/load-directory "~/apps/emacs/packages/yasnippet/snippets")

(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

;;(load "mvn.el")
;; (load-library "mvn")

;; (add-hook 'scala-mode-hook
;; 	  '(lambda ()
;; 	     (define-key scala-mode-map '[f6] 'mvn)))

;; Python
(autoload 'python-mode "python-mode" "Python Mode." t)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))

(require 'anything)
(require 'anything-ipython)
(add-hook 'python-mode-hook #'(lambda ()
  				(define-key py-mode-map (kbd "M-\'") 'anything-ipython-complete)))
(add-hook 'ipython-shell-hook #'(lambda ()
  				  (define-key py-mode-map (kbd "M-\'") 'anything-ipython-complete)))

;; (when (load "flymake" t)
;;  (defun flymake-pyflakes-init ()
;;    (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                              'flymake-create-temp-inplace))
;;              (local-file (file-relative-name
;;                           temp-file
;;                           (file-name-directory buffer-file-name))))
;;      (list "pyflakes" (list local-file))))
;;  (defun flymake-jslint-init ()
;;    (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                              'flymake-create-temp-inplace))
;;              (local-file (file-relative-name
;;                           temp-file
;;                           (file-name-directory buffer-file-name))))
;;      (list "/usr/local/bin/jsflakes" (list local-file))))

;;  (add-to-list 'flymake-allowed-file-name-masks
;;               '("\\.py\\'" flymake-pyflakes-init))
;;  (add-to-list 'flymake-allowed-file-name-masks
;;               '("\\.js\\'" flymake-jslint-init)))
;; (add-hook 'find-file-hook 'flymake-find-file-hook)
;; (load-library "flymake-cursor")

;; Yang
(autoload 'yang-mode "yang-mode" "Major mode for editing YANG spec." t)


;; Coq / ProofGeneral
;;(load-file "~/apps/emacs/packages/ProofGeneral/generic/proof-site.el")


;; HTML
(add-hook 'html-helper-load-hook
          (function (lambda () (load "css.el"))))
(add-hook 'html-helper-load-hook
          '(lambda () (require 'html-font)))
(add-hook 'html-helper-load-hook
          '(lambda () (require 'tempo)))

(add-hook 'html-helper-mode-hook
          '(lambda () (font-lock-mode 1)))

(setq html-helper-do-write-file-hooks t)
(setq html-helper-build-new-buffer t)
(setq html-helper-address-string
      "<a href=\"/\">Vlad Kinzerskiy&lt;kinzersk at mrc.alcatel.ro &gt;</a>")

(add-hook  'html-helper-mode-hook '(lambda () "" (interactive)
                                     (global-set-key '[(f5)]
                                                     'browse-url-of-file) ;F5
                                     ))



;;C++
(add-hook 'c-mode-hook       'elec-cr-mode)
(add-hook 'elec-cr-mode-hook 'elec-par-install-electric)
(add-hook 'c++-mode-hook     'elec-cr-mode)

(autoload 'expand-member-functions "member-functions" "Expand C++ member function declarations" t)
(add-hook 'c++-mode-hook (lambda () (local-set-key "\C-cm" #'expand-member-functions)))

;;(add-hook  'c-mode-common-hook '(lambda () "" (interactive)
(add-hook  'c++-mode-hook '(lambda () "" (interactive)
                             (c-set-style "java") ;; C-c .
                             (global-set-key '[(f4)]          'next-error) ;F4
                             (global-set-key '[(C-f4)]        'previous-error)

                             (define-key c-mode-base-map [(return)] 'newline-and-indent)

                             (setq
                              c-auto-newline nil
                              c-hungry-delete-key t
                              c-block-comments-indent-p nil
                              c-tab-always-indent t
                              c-comment-multi-line t
                              c-comment-only-line-offset '(0 . 2)
                              c-comment-continuation-stars "// "
                              c-hanging-comment-ender-p t
                              c-hanging-comment-starter-p t
                              c-cleanup-list (list 'empty-defun-braces
                                                   'defun-close-semi
                                                   'list-close-comma
                                                   'scope-operator
                                                   )
                              compilation-ask-about-save nil
                              ;;                                   compilation-read-command nil
                              compilation-scroll-output t
                              fill-column 80
                              comment-column 40
                              tab-width 8
                              c-basic-offset 2
                              hs-minor-mode t
                              )

                             ;; configure default compile command and macro preprocessor
                             (make-local-variable 'compile-command)
                             ;;                                  (setq compile-command "make -k")
                             (setq compile-command "make")
                             (setq compilation-read-command nil)
                             ;; code stail
                             (setq-default indent-tabs-mode nil)
                             (setq-default nuke-trailing-whitespace-p t)
                             )          ; end lambda
           )                            ; end add-hook


;; LISP
(add-hook 'emacs-lisp-mode-hook 'elec-par-install-electric)

;; PERL
(add-hook 'cperl-mode-hook   'elec-cr-mode)
(add-hook 'cperl-mode-hook   'elec-par-install-electric)
(add-hook 'cperl-mode-hook '(lambda () "" (interactive)
                              (setq
                               cperl-hairy t
                               cperl-indent-level 4
			       comment-column 40
                                        ;                                hs-minor-mode t
                                        ;                                cperl-continued-statement-offset 0
                                        ;                                cperl-extra-newline-before-brace t
                               )

			      ))


;; IMENU

                                        ; (autoload 'imenu-go-find-at-position "imenu-go"
                                        ;   "Go to the definition of the current word." t)
                                        ; (autoload 'imenu-go--back "imenu-go"
                                        ;   "Return back to a position saved during `imenu-go-find-at-position'." t)

(global-set-key [M-S-mouse-2] 'imenu-go-find-at-position)
(global-set-key "\e\"" 'imenu-go-find-at-position)
(global-set-key [M-S-C-mouse-2] 'imenu-go--back)
(global-set-key "\e'" 'imenu-go--back)  ; Conflicts with defined key.
(global-set-key [?\C-\"] 'imenu-go--back)

;;; to your .emacs file. The usability if this package decreases a lot
;;; unless you have a simple access to `imenu', like in

(global-set-key [M-S-down-mouse-3] 'imenu)

;;; To cache information about interesting places you should either
;;; run `imenu' in the interesting buffers, or run `etags *.c *.h' (or
;;; whatever) on interesting files. After this calling
;;; `imenu-go-find-at-position' when the cursor or pointer is over the
;;; interesting word will warp you to the definition of this word. You
;;; can unwind this warping by doing `imenu-go--back'.

;;; Alternately, for Emacs-Lisp hacking you may install package
;;; `find-function', which will be automatically used in Emacs Lisp mode:
;;;      (autoload 'find-function "find-func" nil t)

;;; ASN.1 Mode
(autoload 'asn1-diff-mode "asn1-diff"
  "Major mode for editing comparison of ASN.1 specifications." t)
(autoload 'asn1-diff "asn1-diff"
  "For comparing ASN.1 specifications." t)
(autoload 'asn1-mode "asn1-mode"
  "Major mode for editing ASN.1 specifications." t)


;;; F#
(autoload 'fsharp-mode "fsharp" "Major mode for editing F# code." t)
(autoload 'run-fsharp "inf-fsharp" "Run an inferior F# process." t)
  
(setq inferior-fsharp-program "mono /udir/kinzersk/work/fsharp/FSharp-1.9.4.19/bin/fsi.exe")
(setq fsharp-compiler "mono /udir/kinzersk/work/fsharp/FSharp-1.9.4.19/bin/fsc.exe")

(autoload 'csharp-mode "csharp-mode" "Major mode for editing C# code." t)
(setq auto-mode-alist
      (append '(("\\.cs$" . csharp-mode)) auto-mode-alist))

;; OCAML
(autoload 'tuareg-mode "tuareg" "Major mode for editing Caml code" t)
(autoload 'camldebug "camldebug" "Run the Caml debugger" t)

;; Erlang
;; (setq erlang-root-dir "C:/Program Files/erl5.7.5")
;; (setq exec-path (cons "C:/Program Files/erl5.7.5/bin" exec-path))
;; (require 'erlang-start) 

;; J
;; (autoload 'j-mode "j-mode"  "Major mode for J." t)
;; (autoload 'j-shell "j-mode" "Run J from emacs." t)
;; (setq auto-mode-alist
;;       (append '("\\.ij[rstp]" . j-mode) auto-mode-alist))

;; LOGO
;;(autoload 'logo-mode "logo")

