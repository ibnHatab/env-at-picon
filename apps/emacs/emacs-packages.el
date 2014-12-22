
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
                ;; ("\\.htm?\\'"              . html-mode)
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
                )auto-mode-alist))


;; ELPA
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))
(package-initialize)

(dolist (mode '(menu-bar-mode tool-bar-mode scroll-bar-mode))
  (when (fboundp mode) (funcall mode -1)))
(setq inhibit-startup-screen t)
;; NO JUNK
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t))
      backup-directory-alist `((".*" . ,temporary-file-directory)))
;; EL-GET
(add-to-list 'load-path (locate-user-emacs-file "el-get/el-get"))
(unless (require 'el-get nil 'noerror)
(with-current-buffer
    (url-retrieve-synchronously
     "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
  (goto-char (point-max))
  (eval-print-last-sexp)))
(defun el-get-sync-recipes (overlay)
(let* ((recipe-glob (locate-user-emacs-file (concat overlay "/recipes/*.rcp")))
       (recipe-files (file-expand-wildcards recipe-glob))
       (recipes (mapcar 'el-get-read-recipe-file recipe-files)))
  (mapcar (lambda (r) (add-to-list 'el-get-sources r)) recipes)
  (el-get 'sync (mapcar 'el-get-source-name recipes))))
(setq el-get-user-package-directory user-emacs-directory)
;; EL-GET SYNC OVERLAYS
(el-get-sync-recipes "el-get-haskell")
(el-get-sync-recipes "el-get-user")
;; CUSTOM FILE
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror)

;; Yaml
(add-hook 'yaml-mode-hook
          '(lambda ()
             (define-key yaml-mode-map "\C-m" 'newline-and-indent)))


;; Elixir
(require 'elixir-mode)
(require 'elixir-mix)
(global-elixir-mix-mode)

(add-to-list 'elixir-mode-hook 
             (defun my-elixir-mode-hook ()
               (yas/minor-mode-on)

               (setq comint-scroll-to-bottom-on-output t)
               (setq elixir-iex-command "iex-emacs")

               (local-set-key "\C-c\C-r" 'elixir-mode-iex)
               (local-set-key "\C-c\C-z" 'iex-switch-to-process-buffer)
               (local-set-key "\C-c\C-e" 'iex-send-line-or-region-and-step)
               (local-set-key "\C-c\C-c" 'run-current-file)

               (local-set-key "\C-cr" 'elixir-mode-eval-on-region)
               (local-set-key "\C-cc" 'elixir-mode-eval-on-current-line)
               (local-set-key "\C-cb" 'elixir-mode-eval-on-current-buffer)
               (local-set-key "\C-ca" 'elixir-mode-string-to-quoted-on-region)
               (local-set-key "\C-cl" 'elixir-mode-string-to-quoted-on-current-line)

               ;;auto-activate-ruby-end-mode-for-elixir-mode
               (set (make-variable-buffer-local 'ruby-end-expand-keywords-before-re)
                    "\\(?:^\\|\\s-+\\)\\(?:do\\)")
               (set (make-variable-buffer-local 'ruby-end-check-statement-modifiers) nil)
;;               (ruby-end-mode +1)

               ))

;; Elixir-CMD
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


;; Trello
;;(require 'org-trello)

;; DOT
(load-library "graphviz-dot-mode")

;; Scala-lang
(require 'scala-mode2)

(add-hook 'scala-mode-hook
          '(lambda ()
             (yas/minor-mode-on)
             (local-set-key "\C-c\C-c" 'run-current-file)
             (local-set-key (kbd "RET") 'newline-and-indent)
             (local-set-key (kbd "C-M-j") 'join-line)
             (local-set-key (kbd "<backtab>") 'scala-indent:indent-with-reluctant-strategy)
             ))

(add-hook 'scala-mode-hook 'turn-on-auto-revert-mode)

(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

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


;;; Shell interpreters
(defun run-current-file ()
  "Execute the current file.
   File suffix is used to determine what program to run.
   If the file is emacs lisp, run the byte compiled version if exist."
  (interactive)
  (let* (
         (suffixMap
          `(
            ("pl"     . "perl")
            ("sc"     . "scala")
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


;; IDO mode
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)
(setq ido-use-filename-at-point 'guess)
;(setq ido-create-new-buffer 'always)

(setq ido-file-extensions-order
      '(".org" ".erl" ".hrl" ".txt" ".py" ".emacs" ".xml" ".rebar" ))

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
;;(require 'calfw)
;;(require 'calfw-org)
(require 'org-manage)
(require 'org-protocol)
(require 'ox-taskjuggler)
(require 'ox-freemind)

(setq org-log-done 'time)
(setq org-agenda-include-diary nil)
(setq org-agenda-dim-blocked-tasks nil)
(setq org-agenda-compact-blocks t)
(setq org-agenda-span 'week)
(setq org-export-with-toc t)
(setq org-export-headline-levels 4)
(setq browse-url-browser-function 'browse-url-generic browse-url-generic-program "gnome-open")

;; Manage .org files
(setq org-manage-directory-org "~/public_html/ib-home") ; M-x org-manage
;; (setq org-agenda-files (quote ("~/public_html/ib-home/calendar/")))
;;         "/local/home/vlad/public_html/ib-home/calendar/android_cal.org"
(setq org-agenda-files (quote 
                        (
                         "~/public_html/ib-home/calendar/fabric_cal.org"
                         "~/public_html/ib-home/calendar/tdd_platform_cal.org"
                         "~/public_html/ib-home/projects/eICIC.org"
                         ;; "~/public_html/ib-home/calendar/femto_cal.org"
                         ;;  "~/public_html/ib-home/calendar/panda_cal.org"
                         ;; "/home/vkinzers/public_html/ib-home/projects/fabric/enb_unload/TODO.org"
                         ;; "/local/vlad/repos/socialsyntax/socialsyntax-web/TODO.org"
                         "~/public_html/ib-home/calendar/journal.org"
                         "~/public_html/ib-home/calendar/calendar.org"
                         )))

(setq org-agenda-text-search-extra-files (quote
                                          (
                                           "~/public_html/ib-home/calendar/fabric_cal.org_archive"
                                           "~/public_html/ib-home/calendar/tdd_platform_cal.org_archive"
                                           "~/public_html/ib-home/calendar/calendar.org_archive"
                                           ;;                         "~/public_html/ib-home/calendar/femto_cal.org_archive"
                                           "~/public_html/ib-home/calendar/journal.org_archive"
                                           ;;                         "/local/home/vlad/public_html/ib-home/calendar/panda_cal.org_archive"
                                           )))


(setq org-default-notes-file "~/public_html/ib-home/calendar/journal.org")
(setq org-default-calendar-file "~/public_html/ib-home/calendar/calendar.org")
(setq org-capture-templates
      '(
        ;; Someday, references, jornal
        ("t" "Todo" entry (file+headline org-default-notes-file "Refill")
         "* TODO %x%?\n %i\n %a\n")
        ("n" "Note" entry (file+headline org-default-notes-file "Notes")
         "* %? :DOCS:\n %U\n %x\n")

        ("i" "Idea" entry (file+headline org-default-notes-file "Idea")
         "* %? :PLANING:\n  %i\n  %a\n")
        ("j" "Journal" entry (file+datetree org-default-notes-file)
         "* %?\nEntered on %U\n  %i\n  %a\n")


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
   (not (string= lang "plantuml"))
   (not (string= lang "dot"))
   )
  ) 
(setq org-confirm-babel-evaluate 'my-org-confirm-babel-evaluate)
(setq org-plantuml-jar-path "/usr/share/plantuml/plantuml.jar")

;; Taskjuggler                             
(require 'taskjuggler-mode)

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


;; Flymake
(require 'flymake)

; Flymake-Elixir
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

; Flymake-Erlang
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


; Flymake-ATS
(require 'ats2-flymake)

;; (defun flymake-ats-init ()
;;   (let* ((temp-file (flymake-init-create-temp-buffer-copy
;; 		     'flymake-create-temp-inplace))
;;   	 (local-file (file-relative-name
;;   		      temp-file
;;   		      (file-name-directory buffer-file-name))))
;;     (list "atscc" (list "-tc " local-file))))

;; (add-to-list 'flymake-allowed-file-name-masks
;;  	     '("\\.\\(d\\|s\\)ats\\'" flymake-ats-init))

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

; flymake python
;; (defun flymake-create-temp-in-system-tempdir (filename prefix)
;;   (make-temp-file (or prefix "flymake")))

;; (when (load "flymake" t)
;;   (defun flymake-pyflakes-init ()
;;     ;; Make sure it's not a remote buffer or flymake would not work
;;      ;; (when (not (subsetp (list (current-buffer)) (tramp-list-remote-buffers)))
;;       (let* ((temp-file (flymake-init-create-temp-buffer-copy
;; 			 'flymake-create-temp-in-system-tempdir))
;;              (local-file (file-relative-name
;; 			  temp-file
;; 			  (file-name-directory buffer-file-name))))
;; 	(list "pyflakes" (list temp-file))))
;;   (add-to-list 'flymake-allowed-file-name-masks
;; 	       '("\\.py\\'" flymake-pyflakes-init)))

(require 'flymake-python-pyflakes)
(add-hook 'python-mode-hook 'flymake-python-pyflakes-load)

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
;; (add-hook 'ats-mode-hook 'my-flymake-minor-mode)
(add-hook 'tuareg-mode-hook 'my-flymake-minor-mode)
(add-hook 'python-mode-hook 'my-flymake-minor-mode)

(defun flymake-xml-init ())
(setq flymake-no-changes-timeout 12)

;; ATS
(require 'ats-mode)

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
 '(cscope-do-not-update-database t)
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
;;(require 'csp-mode)

;; BEGIN Erlang
(setq erlang-root-dir   "/usr/lib/erlang")
(add-to-list 'exec-path "/usr/lib/erlang/bin")
(defvar inferior-erlang-prompt-timeout t)
(add-hook 'erlang-new-file-hook 'tempo-template-erlang-normal-header)
(add-hook 'erlang-mode-hook (lambda () (setq parens-require-spaces nil)))

(add-hook 'erlang-load-hook 'my-erlang-load-hook)
(defun my-erlang-load-hook ()
  (setq erlang-compile-extra-opts '(debug_info (i . \"../include\") (i . \"../deps\")))
  )

(add-hook 'erlang-mode-hook 'my-erlang-mode-hook)
(defun my-erlang-mode-hook ()
  (setq inferior-erlang-machine-options
        '("-sname" "emacs-erl" "-pa" "../ebin" "-pa" "../test" "-pa" "../.eunit" "-pa" "../deps/*/ebin"))
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
;; END erlang

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


;; ;; Haskell
(require 'haskell-mode)
(require 'inf-haskell)
(require 'ghci-completion)

(add-hook 'haskell-mode-hook 'interactive-haskell-mode)
(add-hook 'inferior-haskell-mode-hook 'turn-on-ghci-completion)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;; (add-hook 'haskell-mode-hook 'haskell-indent-mode)
; (add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
; (add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)

(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'font-lock-mode)
(add-hook 'haskell-mode-hook '(lambda () (capitalized-words-mode t)))
(custom-set-variables
 '(haskell-program-name "ghci"))
;; (setq haskell-font-lock-symbols t)
(add-hook 'haskell-mode-hook '(lambda ()
                                (local-set-key "\C-c\C-d" 'haskell-hoogle)

                                ))

;; (require 'flymake-haskell-multi)
;; (add-hook 'haskell-mode-hook 'flymake-haskell-multi-load)

(require 'flycheck)
(define-key flycheck-mode-map (kbd "M-n") #'flycheck-next-error)
(define-key flycheck-mode-map (kbd "M-p") #'flycheck-previous-error)

(add-hook 'flycheck-mode-hook #'flycheck-haskell-setup)
(add-hook 'haskell-mode-hook 'flycheck-mode)

;

;; Yasnippet
(require 'yasnippet) ;; not yasnippet-bundle
(yas/load-directory "~/apps/emacs/packages/yasnippet/snippets")
(yas/initialize)                        

;; Python
(require 'python)  

(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:setup-keys t)                      ; optional
(setq jedi:complete-on-dot t)                 ; optional

(add-hook 'python-mode-hook
	  #'(lambda ()
	      (setq
	       python-shell-interpreter "python"
               python-shell-prompt-regexp  "In \\[[0-9]+\\]: "
               python-shell-prompt-output-regexp  "Out\\[[0-9]+\\]: "
               python-shell-completion-setup-code  "from IPython.core.completerlib import module_completion"
               python-shell-completion-module-string-code  "';'.join(module_completion('''%s'''))\n"
               python-shell-completion-string-code  "';'.join(get_ipython().Completer.all_completions('''%s'''))\n"
			)

	      (define-key python-mode-map "\C-m" 'newline-and-indent)
	      (define-key python-mode-map (kbd "C-c |") 'python-shell-send-region)
	      (define-key python-mode-map (kbd "C-c !") 'python-shell)

              (local-set-key "\M-." 'jedi:goto-definition)
              (local-set-key "\M-?" 'jedi:show-doc)
              (local-set-key "\M-," 'jedi:goto-definition-pop-marker)

	      ))

(require 'python-django)
(autoload 'django-html-mumamo-mode "~/.emacs.d/nxhtml/autostart.el")
(setq auto-mode-alist
      (append '(("\\.html?$" . django-html-mumamo-mode)) auto-mode-alist))
(setq mumamo-background-colors nil) 
(add-to-list 'auto-mode-alist '("\\.html$" . django-html-mumamo-mode))

;; Workaround the annoying warnings:
;;    Warning (mumamo-per-buffer-local-vars):
;;    Already 'permanent-local t: buffer-file-name
(when (and (equal emacs-major-version 24)
           (equal emacs-minor-version 3))
  (eval-after-load "mumamo"
    '(setq mumamo-per-buffer-local-vars
           (delq 'buffer-file-name mumamo-per-buffer-local-vars))))


(global-set-key (kbd "C-x j") 'python-django-open-project)


;; mustache
;(require 'mustache-mode)

;; Yang
;(autoload 'yang-mode "yang-mode" "Major mode for editing YANG spec." t)

;; Coq/ProofGeneral
;;(load-file "~/apps/emacs/packages/ProofGeneral/generic/proof-site.el")


;;C/C++
;; (add-hook 'c-mode-hook       'elec-cr-mode)
;; (add-hook 'c++-mode-hook     'elec-cr-mode)
;; (add-hook 'elec-cr-mode-hook 'elec-par-install-electric)
;; (add-hook 'elec-c-mode-hook 'turn-on-auto-fill)
;; (autoload 'elec-par-install-electric "elec-par")
;; (autoload 'elec-cr-mode "elec-cr" "High powered C editing mode." t)


(autoload 'expand-member-functions "member-functions" "Expand C++ member function declarations" t)
(add-hook 'c++-mode-hook (lambda ()
			 (local-set-key "\M-." 'cscope-find-global-definition-no-prompting)
			 (local-set-key "\M-?" 'cscope-find-this-symbol)
			 (local-set-key "\M-," 'cscope-pop-mark)
			 (local-set-key [(control f4)] 'cscope-find-functions-calling-this-function) ;; f4 References
			 (local-set-key [(control f6)] 'cscope-display-buffer)                       ;; f6 display buffer
			 (local-set-key [(control f7)] 'cscope-prev-symbol)                          ;; f7 prev sym
			 (local-set-key [(control f8)] 'cscope-next-symbol)                          ;; f8 next sym
			 (local-set-key [(control f9)] 'cscope-set-initial-directory)                ;; f9 set initial dir
			 (local-set-key [(M-tab)]	'complete-tag )
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
;; (add-hook 'emacs-lisp-mode-hook 'elec-par-install-electric)

;; PERL
;; (add-hook 'cperl-mode-hook   'elec-cr-mode)
;; (add-hook 'cperl-mode-hook   'elec-par-install-electric)
(add-hook 'cperl-mode-hook '(lambda () "" (interactive)
                              (setq
                               cperl-hairy t
                               cperl-indent-level 4
			       comment-column 40
                               )))

;;; ASN.1 Mode
;; (autoload 'daveb-mib-mode "daveb-mib-mode"  "Mode for editing ASN.1 SNMP MIBs")

(autoload 'asn1-diff-mode "asn1-diff"
  "Major mode for editing comparison of ASN.1 specifications." t)
(autoload 'asn1-diff "asn1-diff"
  "For comparing ASN.1 specifications." t)
(autoload 'asn1-mode "asn1-mode"
  "Major mode for editing ASN.1 specifications." t)


