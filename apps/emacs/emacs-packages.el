
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
		("\\.erl$"                 . erlang-mode)
		("\\.hrl$"                 . erlang-mode)
		("\\.ie$"                  . erlang-mode)
		("\\.es$"                  . erlang-mode)
		("\\.app$"                 . erlang-mode)
		("\\.csp$"                 . csp-mode)
                ("\\.\\(d\\|s\\)ats\\'"    . ats-two-mode-mode)
		("\\.org\\'"               . org-mode)
		("\\.m\\'"                 . octave-mode)
		("\\.mustache\\'"          . mustache-mode)
                ("\\.md\\'"                . markdown-mode)
                ("\\.groovy$"              . groovy-mode)
                ("\\.scala$"               . scala-mode)
                ("\\.dot"                  . graphviz-dot-mode)
                ("\\.tjp"                  . taskjuggler-mode)
                )auto-mode-alist))

<<<<<<< HEAD
;; Elixir
(require 'elixir-mode-setup)
(elixir-mode-setup)

=======


;; Trello
;;(require 'org-trello)
;; ELPA
;; (require 'package)
;; (add-to-list 'package-archives 
;;              '("marmalade" .
;;                "http://marmalade-repo.org/packages/"))
;; (package-initialize)

;; taskjuggler                             
;; C-c C-s	check syntax using taskjuggler backend
;; C-c C-c	compile using taskjuggler backend
;; C-c C-d	Insert dependency with completion and (hopefully) correct relative path
;; C-c C-r	Insert resource (with completion and context keywords)
;; C-c r	Rescan current buffer completely
;; C-c i t	Insert task template
;; C-c i r	Insert resource template
(require 'taskjuggler-mode)

;; DOT
(load-library "graphviz-dot-mode")

;; Scala-lang
(require 'scala-mode-auto)
(add-hook 'scala-mode-hook
          '(lambda ()
             (yas/minor-mode-on)
             (local-set-key "\C-c\C-c" 'run-current-file)
             ))

;; Groovy
(autoload 'groovy-mode "groovy-mode"
  "Mode for editing groovy source files" t)
(setq interpreter-mode-alist (append '(("groovy" . groovy-mode))
   				     interpreter-mode-alist))

(autoload 'groovy-mode "groovy-mode" "Groovy mode." t)
(autoload 'run-groovy "inf-groovy" "Run an inferior Groovy process")
(autoload 'inf-groovy-keys "inf-groovy" "Set local key defs for inf-groovy in groovy-mode")

(add-hook 'groovy-mode-hook
          '(lambda ()
             (inf-groovy-keys)
             (local-set-key "\C-c\C-c" 'run-current-file)
             ))

;; can set groovy-home here, if not in environment
(setq inferior-groovy-mode-hook
      '(lambda()
         (setq groovy-home "/local/tools/scala/groovy")
         ))

;; Markdown
(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)

;; Elixir
(add-to-list 'load-path "~/.emacs.d/emacs-elixir")
(require 'elixir-mode-setup)
(elixir-mode-setup)

;; preload
(require 'elixir-mode)

(add-hook 'elixir-mode-hook 'my-elixir-mode-hook)
(defun my-elixir-mode-hook ()
  (setq comint-scroll-to-bottom-on-output t)
  (setq elixir-iex-command "iex-emacs")
  (local-set-key "\C-c\C-r" 'elixir-mode-iex)
  (local-set-key "\C-c\C-z" 'iex-switch-to-process-buffer)
  (local-set-key "\C-c\C-e" 'iex-send-line-or-region-and-step)
  (local-set-key "\C-c\C-c" 'run-current-file)
  )

;;;
(defun run-current-file ()
  "Execute the current file.
   File suffix is used to determine what program to run.
   If the file is emacs lisp, run the byte compiled version if exist."
  (interactive)
  (let* (
         (suffixMap
          `(
            ("pl"     . "perl")
            ("py"     . "python")
            ("rb"     . "ruby")
            ("sh"     . "bash")
            ("ml"     . "ocaml")
            ("ex"     . "elixir")
            ("exs"    . "elixir --sname 'elixir' -pz ../ebin")
            ("groovy" . "groovy")
            )
          )
         (fName (buffer-file-name))
         (fSuffix (file-name-extension fName))
         (progName (cdr (assoc fSuffix suffixMap)))
         (cmdStr (concat progName " \""   fName "\""))
         )

    (when (buffer-modified-p)
      (when (y-or-n-p "Buffer modified. Do you want to save first?")
          (save-buffer) ) )

    (if (string-equal fSuffix "el") ; special case for emacs lisp
        (load (file-name-sans-extension fName))
      (if progName
          (progn
            (message "Running…")
            (shell-command cmdStr "*run-current-file output*" )
            )
        (message "No recognized program file suffix for this file.")
        ) ) ))

(defun iex-send-line-or-region (&optional step)
  (interactive ())
  (let ((proc (get-process "IEX"))
        pbuf min max command)
    (unless proc
      (let ((currbuff (current-buffer)))
        (shell)
        (switch-to-buffer currbuff)
        (setq proc (get-process "IEX"))
        ))
    (setq pbuff (process-buffer proc))
    (if (use-region-p)
        (setq min (region-beginning)
              max (region-end))
      (setq min (point-at-bol)
            max (point-at-eol)))
    (setq command (concat (buffer-substring min max) "\n"))
    (with-current-buffer pbuff
      (goto-char (process-mark proc))
      (insert command)
      (move-marker (process-mark proc) (point))
      ) ;;pop-to-buffer does not work with save-current-buffer -- bug?
    (process-send-string  proc command)
    (display-buffer (process-buffer proc) t)
    (when step 
      (goto-char max)
      (next-line))
    ))

(defun iex-send-line-or-region-and-step ()
  (interactive)
  (iex-send-line-or-region t))
(defun iex-switch-to-process-buffer ()
  (interactive)
  (pop-to-buffer (process-buffer (get-process "IEX"
)) t))

>>>>>>> b9541a34e50204a7326e0bd0f3c6370207f03287

;; IDO mode
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)
(setq ido-use-filename-at-point 'guess)
;(setq ido-create-new-buffer 'always)

(setq ido-file-extensions-order
      '(".erl" ".hrl" ".org" ".txt" ".py" ".emacs" ".xml" ".rebar" ))

;; octave-mode
(autoload 'octave-mode "octave-mod" nil t)
(add-hook 'octave-mode-hook
          (lambda ()
            (abbrev-mode 1)
            (auto-fill-mode 1)
            (local-set-key '[(M-tab)] 'octave-complete-symbol)))

(add-hook 'inferior-octave-mode-hook
               (lambda ()
                 (turn-on-font-lock)
                 ;; (define-key inferior-octave-mode-map [up]
                 ;;   'comint-previous-input)
                 ;; (define-key inferior-octave-mode-map [down]
                 ;;   'comint-next-input)
	       ))


;; Org-Mode
(require 'org)
(require 'calfw)
(require 'calfw-org)
(require 'org-manage)
(require 'org-protocol)
(require 'ox-taskjuggler)
(require 'ox-freemind)

<<<<<<< HEAD
;; Here is an example:
;; (setq org-publish-project-alist
;;       '(("org"
;; 	 :base-directory "~/org/org-files"
;; 	 :publishing-directory "~/public_html/org"
;; 	 :section-numbers nil
;; 	 :table-of-contents nil
;; 	 :style "<link rel=\"stylesheet\"
;;                    href=\"../other/mystyle.css\"
;;                    type=\"text/css\"/>")))

;; (setq org-default-notes-file (concat org-directory "/notes.org"))
;(define-key global-map "\C-cc" 'org-capture)
;(org-babel-do-load-languages
; 'org-babel-load-languages
; '(
;   (ditaa . t)
   ;(python . t)
   ;; (dot . t)
   ;; (haskell . t)
;   )) ; this line activates ditaa

;(defun my-org-confirm-babel-evaluate (lang body)
;  (not (string= lang "ditaa")))  ; don't ask for ditaa
;(setq org-confirm-babel-evaluate 'my-org-confirm-babel-evaluate)
=======
(setq org-log-done 'time)
(setq org-agenda-include-diary nil)
(setq org-agenda-dim-blocked-tasks nil)
(setq org-agenda-compact-blocks t)
(setq org-agenda-span 'week)
(setq org-export-with-toc t)
(setq org-export-headline-levels 4)
;; Manage .org files
(setq org-manage-directory-org "~/public_html/ib-home") ; M-x org-manage
(setq org-agenda-files (quote ("~/public_html/ib-home/calendar/")))

(setq org-default-notes-file "~/public_html/ib-home/calendar/journal.org")
(setq org-default-calendar-file "~/public_html/ib-home/calendar/calendar.org")
(setq org-capture-templates
      '(
        ;; Someday, references, jornal
        ("t" "Todo" entry (file+headline org-default-notes-file "Refill")
         "* TODO %?\n  %i\n  %a\n")
        ("i" "Idea" entry (file+headline org-default-notes-file "Idea")
         "* %? :PLANING:\n  %i\n  %a\n")
        ("j" "Journal" entry (file+datetree org-default-notes-file)
         "* %?\nEntered on %U\n  %i\n  %a\n")
        ("n" "Note" entry (file+headline org-default-notes-file "Notes")
         "* %? :DOCS:\n%U\n%x\n" :clock-in t :clock-resume t)

        ;; Calendar, Meeting, Phone, Habits
        ("m" "Meeting" entry (file+headline org-default-calendar-file "Meeting")
         "* MEETING with %? :MEETING:\n%U\n" :clock-in t :clock-resume t)
        ("p" "Phone call" entry (file+headline org-default-calendar-file "Phone-call")
         "* PHONE %? :PHONE:\n%U\n" :clock-in t :clock-resume t)
        ("h" "Habit" entry (file+headline org-default-calendar-file "Habit")
         "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"<%Y-%m-%d %a .+1d/3d>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n")
        ))
;; smart links
(setq org-link-abbrev-alist
       '(("lte"  . "http://www.quintillion.co.jp/3GPP/NAMAZU_R8/namazu.cgi?query=%s&submit=Search%21&max=20&result=normal&sort=score")
         ("google"    . "http://www.google.com/search?q=")
         ("gmap"      . "http://maps.google.com/maps?q=%s")
         ("omap"      . "http://nominatim.openstreetmap.org/search?q=%s&polygon=1")))
;; Agenda 
(setq org-stuck-projects (quote ("+LEVEL=2/-DONE" ("TODO" "NEXT" "NEXTACTION") ("DOC" "wiki") "")))

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))
(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold)
              ("MEETING" :foreground "forest green" :weight bold)
              ("PHONE" :foreground "forest green" :weight bold))))

(setq org-tag-alist '(("doc"    . ?h)
                      ("dev"    . ?d)
                      ("devops" . ?o)
                      ("test"   . ?t)
                      ("plan"   . ?p)
                      ("linux"  . ?l)))

;;;; Refile settings
(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))
(setq org-refile-use-outline-path t)
(setq org-outline-path-complete-in-steps nil)
(setq org-refile-allow-creating-parent-nodes (quote confirm))
(setq org-completion-use-ido t)
(setq ido-everywhere t)
(setq ido-max-directory-size 100000)
(ido-mode (quote both))
(setq ido-default-file-method 'selected-window)
(setq ido-default-buffer-method 'selected-window)
(setq org-indirect-buffer-display 'current-window)

(defun bh/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))
(setq org-refile-target-verify-function 'bh/verify-refile-target)

;; Babel
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (ditaa    . t)
   (python   . t)
   (dot      . t)
   (haskell  . t)
   (org      . t)
   (plantuml . t) 
   (sh       . t)  
   )) 

; don't ask for confirmation
(defun my-org-confirm-babel-evaluate (lang body)
  (or
   (not (string= lang "ditaa"))
   (not (string= lang "pantuml"))
   (not (string= lang "dot"))
   )
  ) 
(setq org-confirm-babel-evaluate 'my-org-confirm-babel-evaluate)
(setq org-plantuml-jar-path "/usr/share/plantuml/plantuml.jar")
>>>>>>> b9541a34e50204a7326e0bd0f3c6370207f03287

;; Git
;; (require 'egg)
;; git-gutter 
(require 'git-gutter)
(global-git-gutter-mode t)
;; - (add-hook 'ruby-mode-hook 'git-gutter-mode)
(global-set-key (kbd "C-x C-g") 'git-gutter:toggle)
(global-set-key (kbd "C-x v =") 'git-gutter:popup-hunk)
(global-set-key (kbd "C-x p") 'git-gutter:previous-hunk)
(global-set-key (kbd "C-x n") 'git-gutter:next-hunk)
(global-set-key (kbd "C-x r") 'git-gutter:revert-hunk)

;; magit
(when (locate-library "magit")
  (require 'magit)
)
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


;; Flymake
(require 'flymake)

; elixir
(defun flymake-elixir-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-with-folder-structure))
                     ;;'flymake-create-temp-inplace))
  	 (local-file (file-relative-name
  		      temp-file
  		      (file-name-directory buffer-file-name))))
    (list "elixirc.wrap" (list local-file))))
    ;; (list "/usr/local/bin/elixirc --ignore-module-conflict -o /tmp" (list local-file))))

(add-to-list 'flymake-allowed-file-name-masks
 	     '("\\.ex\\'" flymake-elixir-init))
(push
 '("** (.*) \\([^:]+\\):\\([0-9]+\\): \\(.*\\)"
   1 2 nil 3) flymake-err-line-patterns)
; file-idx line-idx col-idx (optional) text-idx(optional)

; erlang
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


; ats
(defun flymake-ats-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
		     'flymake-create-temp-inplace))
  	 (local-file (file-relative-name
  		      temp-file
  		      (file-name-directory buffer-file-name))))
    (list "atscc" (list "-tc " local-file))))

(add-to-list 'flymake-allowed-file-name-masks
 	     '("\\.\\(d\\|s\\)ats\\'" flymake-ats-init))
(push
 '("\\(syntax error: \\)?\\([^\n:]*\\): \\[?[0-9]*(line=\\([0-9]*\\), offs=\\([0-9]*\\))\\]?\\(.*\\)?"
   2 3 4 5) flymake-err-line-patterns)
; o'caml
(defun flymake-ocaml-init ()
  (flymake-simple-make-init-impl
   'flymake-create-temp-with-folder-structure nil nil
   (file-name-nondirectory buffer-file-name)
   'flymake-get-ocaml-cmdline))
(defun flymake-get-ocaml-cmdline (source base-dir)
  (list "ocaml_flycheck.pl"
	(list source base-dir)))

(push '(".+\\.ml[yilp]?$" flymake-ocaml-init flymake-simple-java-cleanup)
      flymake-allowed-file-name-masks)
(push
 '("^\\(\.+\.ml[yilp]?\\|\.lhs\\):\\([0-9]+\\):\\([0-9]+\\):\\(.+\\)"
   1 2 3 4) flymake-err-line-patterns)

; python
(defun flymake-create-temp-in-system-tempdir (filename prefix)
  (make-temp-file (or prefix "flymake")))

(when (load "flymake" t)
  (defun flymake-pyflakes-init ()
    ;; Make sure it's not a remote buffer or flymake would not work
     ;; (when (not (subsetp (list (current-buffer)) (tramp-list-remote-buffers)))
      (let* ((temp-file (flymake-init-create-temp-buffer-copy
			 'flymake-create-temp-in-system-tempdir))
             (local-file (file-relative-name
			  temp-file
			  (file-name-directory buffer-file-name))))
	(list "pyflakes" (list temp-file))))
  (add-to-list 'flymake-allowed-file-name-masks
	       '("\\.py\\'" flymake-pyflakes-init)))

;; optional setting
;; if you want to use flymake always, then add the following hook.
;; (add-hook
;;  'tuareg-mode-hook
;;  '(lambda ()
;;     (if (not (null buffer-file-name)) (flymake-mode))))
;;
(add-hook 'find-file-hook 'flymake-find-file-hook)

;; mini
(defvar my-flymake-minor-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map "\M-p" 'flymake-goto-prev-error)
    (define-key map "\M-n" 'flymake-goto-next-error)
    map)
  "Keymap for my flymake minor mode.")

(defun my-flymake-err-at (pos)
  (let ((overlays (overlays-at pos)))
    (remove nil
            (mapcar (lambda (overlay)
                      (and (overlay-get overlay 'flymake-overlay)
                           (overlay-get overlay 'help-echo)))
                    overlays))))

(defun my-flymake-err-echo ()
  (message "%s" (mapconcat 'identity (my-flymake-err-at (point)) "\n")))

(defadvice flymake-goto-next-error (after display-message activate compile)
  (my-flymake-err-echo))

(defadvice flymake-goto-prev-error (after display-message activate compile)
  (my-flymake-err-echo))

(define-minor-mode my-flymake-minor-mode
  "Simple minor mode which adds some key bindings for moving to the next and previous errors.
Key bindings:
\\{my-flymake-minor-mode-map}"
  nil
  nil
  :keymap my-flymake-minor-mode-map)

;; Enable this keybinding (my-flymake-minor-mode) by default
(add-hook 'elixir-mode-hook 'my-flymake-minor-mode)
(add-hook 'erlang-mode-hook 'my-flymake-minor-mode)
(add-hook 'haskell-mode-hook 'my-flymake-minor-mode)
(add-hook 'ats-mode-hook 'my-flymake-minor-mode)
(add-hook 'tuareg-mode-hook 'my-flymake-minor-mode)
(add-hook 'python-mode-hook 'my-flymake-minor-mode)

;; ATS
(require 'ats-mode)

; autocomplete
;(require 'auto-complete-config)
;(add-to-list 'ac-dictionary-directories
;	     (concat (getenv "HOME") "/apps/emacs/packages/ac-dict"))
;(ac-config-default)

;; (enable cscope)
(require 'xcscope)
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
 )

;; Doxymacs
(require 'doxymacs)
(defun my-doxymacs-font-lock-hook ()
  (if (or (eq major-mode 'c-mode) (eq major-mode 'c++-mode))
      (doxymacs-font-lock)))
(add-hook 'font-lock-mode-hook 'my-doxymacs-font-lock-hook)

;; CMake
(require 'cmake-mode)
(setq auto-mode-alist
      (append '(("CMakeLists\\.txt\\'" . cmake-mode)
		("\\.cmake\\'" . cmake-mode))
	      auto-mode-alist))

;; CSP
(require 'csp-mode)

;; Erlang

(setq erlang-root-dir   "/usr/lib/erlang")
(add-to-list 'exec-path "/usr/lib/erlang/bin")
(defvar inferior-erlang-prompt-timeout t)
(add-hook 'erlang-new-file-hook 'tempo-template-erlang-normal-header)
(add-hook 'erlang-mode-hook (lambda () (setq parens-require-spaces nil)))

(add-hook 'erlang-load-hook 'my-erlang-load-hook)
(defun my-erlang-load-hook ()
  (setq erlang-compile-extra-opts '(debug_info (i . \"../include\")))
  )

(add-hook 'erlang-mode-hook 'my-erlang-mode-hook)
(defun my-erlang-mode-hook ()
  (setq inferior-erlang-machine-options
        '("-sname" "emacs" "-pa" "../ebin" "-pa" "../test" "-pa" "../.eunit" "-pa" "../deps/*/ebin"))
  (imenu-add-to-menubar "imenu")
  (local-set-key [return]   'newline-and-indent)
  (local-set-key "\C-c\C-m" 'erlang-man-function)
  (local-set-key "\C-c\C-c" 'erlang-compile)
  (local-set-key "\M-tab"   'erl-complete)
  (local-set-key "\C-c\C-v" 'erl-reload-module)
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
    ("\M-tab" erl-complete)
    ("\M-." erl-find-source-under-point)
    ("\M-," erl-find-source-unwind)
    ("\M-*" erl-find-source-unwind)
    )
  "Additional keys to bind when in Erlang shell.")
(add-hook 'erlang-shell-mode-hook
 	  (lambda ()
 	    (dolist (spec distel-shell-keys)
 	      (define-key erlang-shell-mode-map (car spec) (cadr spec)))))

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

;; Yasnippet
(require 'yasnippet) ;; not yasnippet-bundle
(yas/initialize)
(yas/load-directory "~/apps/emacs/packages/yasnippet/snippets")

;; Python
(require 'python)  
(require 'pymacs)
(add-hook 'python-mode-hook
	  #'(lambda ()
	      (setq
	       python-shell-interpreter "ipython"
	       python-shell-interpreter-args ""
	       python-shell-prompt-regexp "In \[[0-9]+\]: "
	       python-shell-prompt-output-regexp "Out\[[0-9]+\]: "
	       python-shell-completion-string-code "';'.join(__IP.complete('''%s'''))\n"
	       python-shell-completion-module-string-code "")

	      (define-key python-mode-map "\C-m" 'newline-and-indent)
	      (define-key python-mode-map (kbd "C-c |") 'python-shell-send-region)
	      (define-key python-mode-map (kbd "C-c !") 'python-shell)

	      ;; rope
	      (pymacs-load "ropemacs" "rope-")
	      (setq ropemacs-enable-shortcuts nil)
	      (setq ropemacs-local-prefix "C-c C-p")
	      (setq ropemacs-enable-autoimport 't)
	      ))


;; mustache
;(require 'mustache-mode)

;; Yang
;(autoload 'yang-mode "yang-mode" "Major mode for editing YANG spec." t)

;; Coq/ProofGeneral
;;(load-file "~/apps/emacs/packages/ProofGeneral/generic/proof-site.el")


;;C/C++
(add-hook 'c-mode-hook       'elec-cr-mode)
(add-hook 'c++-mode-hook     'elec-cr-mode)
(add-hook 'elec-cr-mode-hook 'elec-par-install-electric)
(add-hook 'elec-c-mode-hook 'turn-on-auto-fill)
;; (autoload 'elec-par-install-electric "elec-par")
(autoload 'elec-cr-mode "elec-cr" "High powered C editing mode." t)


(autoload 'expand-member-functions "member-functions" "Expand C++ member function declarations" t)
(add-hook 'c++-mode-hook (lambda ()
                           (local-set-key "\C-cm" #'expand-member-functions)))

(add-hook 'c-mode-hook (lambda ()
			 (local-set-key "\M-." 'cscope-find-global-definition-no-prompting)
			 (local-set-key "\M-?" 'cscope-find-this-symbol)
			 (local-set-key "\M-," 'cscope-pop-mark)
			 (local-set-key [(control f4)] 'cscope-find-functions-calling-this-function) ;; f4 References
			 (local-set-key [(control f6)] 'cscope-display-buffer)                       ;; f6 display buffer
			 (local-set-key [(control f7)] 'cscope-prev-symbol)                          ;; f7 prev sym
			 (local-set-key [(control f8)] 'cscope-next-symbol)                          ;; f8 next sym
			 (local-set-key [(control f9)] 'cscope-set-initial-directory)                ;; f9 set initial dir
			 (local-set-key [(M-tab)]	'complete-tag )
			 ))


(add-hook  'c-mode-common-hook '(lambda () "" (interactive)
;;(add-hook  'c++-mode-hook '(lambda () "" (interactive)
				  (c-set-style "stroustrup") ;; C-c .
                                  ;; push armcc error regex
                                  (add-to-list 'compilation-error-regexp-alist
                                               '("^\\(.+?\\)(\\([0-9]+\\),\\([0-9]+\\)) :" 1 2 3))
                                  ;; push cmake - armcc error regex
                                  (add-to-list 'compilation-error-regexp-alist
                                               '("^.*]\s\\(.+?\\)(\\([0-9]+\\),\\([0-9]+\\)) :" 1 2 3))


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
                                   c-cleanup-list (list ;; 'empty-defun-braces
                                                        'defun-close-semi
                                                        'list-close-comma
                                                        'scope-operator
                                                        'brace-else-brace
                                                        'brace-elseif-brace
                                                        )
                                   compilation-ask-about-save nil
                                   compilation-scroll-output t
                                   compilation-auto-jump-to-first-error t
                                   c-echo-syntactic-information-p nil
                                   fill-column 80
                                   comment-column 40
                                   tab-width 8
                                   c-basic-offset 4
                                   hs-minor-mode t ;; F6
                                   )
                                  (setq-default indent-tabs-mode nil)
                                  (setq-default nuke-trailing-whitespace-p t)
                                  )
           )


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
;; (autoload 'daveb-mib-mode "daveb-mib-mode"  "Mode for editing ASN.1 SNMP MIBs")

(autoload 'asn1-diff-mode "asn1-diff"
  "Major mode for editing comparison of ASN.1 specifications." t)
(autoload 'asn1-diff "asn1-diff"
  "For comparing ASN.1 specifications." t)
(autoload 'asn1-mode "asn1-mode"
  "Major mode for editing ASN.1 specifications." t)


