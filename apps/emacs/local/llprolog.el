;; Major mode for editing Prolog, and for running Prolog under Emacs
;; Copyright (C) 1986, 1987 Free Software Foundation, Inc.
;; Author Masanobu UMEDA (umerin@flab.flab.fujitsu.junet)
;; Changes by Johan Andersson, Peter Olin, Mats Carlsson, 
;; and Johan Bevemyr, SICS, Sweden.
;; Changes by Naoyuki Tamura for Linear Logic Prolog, Kobe Univ., Japan.

;; This file is part of GNU Emacs.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY.  No author or distributor
;; accepts responsibility to anyone for the consequences of using it
;; or for whether it serves any particular purpose or works at all,
;; unless he says so in writing.  Refer to the GNU Emacs General Public
;; License for full details.

;; Everyone is granted permission to copy, modify and redistribute
;; GNU Emacs, but only under the conditions described in the
;; GNU Emacs General Public License.   A copy of this license is
;; supposed to have been given to you along with GNU Emacs so you
;; can know your rights and responsibilities.  It should be in a
;; file named COPYING.  Among other things, the copyright notice
;; and this notice must be preserved on all copies.
;; 
;; Insert the following lines in your .emacs to use this mode.
;;
;; (autoload 'run-llprolog "llprolog"
;;        	  "Start a LLProlog sub-process." t)
;; (autoload 'llprolog-mode "llprolog"
;;        	  "Major mode for editing LLProlog programs" t)

(require 'comint)

(defconst llprolog-version "1.0")
(defvar llprolog-mode-syntax-table nil)
(defvar llprolog-mode-abbrev-table nil)
(defvar llprolog-mode-map (make-sparse-keymap))

;; PO 890606
(defvar llprolog-system "llp"
  "LLProlog system used by run-llprolog")

;; JA 890531
(defvar llprolog-temp-file-head (make-temp-name "/tmp/llp"))
(defvar llprolog-temp-llp-file
  (concat llprolog-temp-file-head ".llp"))

;; JA 890531
(defun build-llprolog-command (commstring)
  (concat commstring "('" llprolog-temp-file-head "').\n"))

(defvar llprolog-indent-width 4)

(if llprolog-mode-syntax-table
    ()
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?_ "w" table)
    (modify-syntax-entry ?\\ "." table)
    (modify-syntax-entry ?/ "." table)
    (modify-syntax-entry ?* "." table)
    (modify-syntax-entry ?+ "." table)
    (modify-syntax-entry ?- "." table)
    (modify-syntax-entry ?= "." table)
    (modify-syntax-entry ?% "<" table)
    (modify-syntax-entry ?< "." table)
    (modify-syntax-entry ?> "." table)
    (modify-syntax-entry ?\' "\"" table)
    (setq llprolog-mode-syntax-table table)))

(define-abbrev-table 'llprolog-mode-abbrev-table ())

(defun llprolog-mode-variables ()
  (set-syntax-table llprolog-mode-syntax-table)
  (setq local-abbrev-table llprolog-mode-abbrev-table)
  (make-local-variable 'paragraph-start)
  (setq paragraph-start (concat "^%%\\|^$\\|" page-delimiter)) ;'%%..'
  (make-local-variable 'paragraph-separate)
  (setq paragraph-separate paragraph-start)
  (make-local-variable 'paragraph-ignore-fill-prefix)
  (setq paragraph-ignore-fill-prefix t)
  (make-local-variable 'indent-line-function)
  (setq indent-line-function 'llprolog-indent-line)
  (make-local-variable 'comment-start)
  (setq comment-start "%")
  (make-local-variable 'comment-start-skip)
  (setq comment-start-skip "%+ *")
  (make-local-variable 'comment-column)
  (setq comment-column 48)
  (make-local-variable 'comment-indent-hook)
  (setq comment-indent-hook 'llprolog-comment-indent))

(defun llprolog-mode-commands (map)
  (define-key map "\t" 'llprolog-indent-line)
;  (define-key map "\C-c\C-c" 'llprolog-consult-predicate)
;  (define-key map "\C-cc" 'llprolog-consult-region)
;  (define-key map "\C-cC" 'llprolog-consult-buffer)
  (define-key map "\C-c\C-k" 'llprolog-compile-predicate)
  (define-key map "\C-ck" 'llprolog-compile-region)
  (define-key map "\C-cK" 'llprolog-compile-buffer))

(llprolog-mode-commands llprolog-mode-map)


;;; LLPROLOG MODE

(defun llprolog-mode ()
  "Major mode for editing LLProlog code for LLPrologs.
Blank lines and `%%...' separate paragraphs.  `%'s start comments.
Commands:
\\{llprolog-mode-map}
Entry to this mode calls the value of llprolog-mode-hook
if that value is non-nil."
  (interactive)
  (kill-all-local-variables)
  (use-local-map llprolog-mode-map)
  (setq major-mode 'llprolog-mode)
  (setq mode-name "LLProlog")
  (llprolog-mode-variables)
  (run-hooks 'llprolog-mode-hook))

(defun llprolog-indent-line (&optional whole-exp)
  "Indent current line as LLProlog code.
With argument, indent any additional lines of the same clause
rigidly along with this one (not yet)."
  (interactive "p")
  (let ((indent (llprolog-indent-level))
	(pos (- (point-max) (point))) beg)
    (beginning-of-line)
    (setq beg (point))
    (skip-chars-forward " \t")

    (if (zerop (- indent (current-column)))
	nil
      (delete-region beg (point))
      (indent-to indent))

    (if (> (- (point-max) pos) (point))
	(goto-char (- (point-max) pos)))))

;; JA 890605
(defun llprolog-indent-level ()
  "Compute llprolog indentation level."
  (save-excursion
    (beginning-of-line)
    (skip-chars-forward " \t")
    (cond
     ((looking-at "%%%") 0)		;Large comment starts
     ((looking-at "%[^%]") comment-column) ;Small comment starts
     ((bobp) 0)				;Beginning of buffer
     ((looking-at "\n")                 ; a new fresh line
      (indent-for-new-clause))
     (t                                 ; indent existing clause
      (forward-line -1)
      (indent-for-new-clause)))))


;; JA 890601
(defun search-for-prev-goal ()
  "Search for the most recent llprolog symbol (in head or in body)"
  (while (and (not (bobp)) (or (looking-at "%[^%]") (looking-at "\n")))
    (forward-line -1)
    (skip-chars-forward " \t")))

;; JA 890601
(defun indent-for-new-clause ()
  "Find column for a new goal"
  (search-for-prev-goal)
  (skip-chars-forward " \t")
  (let ((prevcol (current-column)))
    (end-of-llprolog-clause)
    (forward-char -1)
    (cond ((bobp) 0)
	  ((looking-at "[.]") 0)
	  ((zerop prevcol) tab-width)
	  ((looking-at "[\[{(;]")
	   (max tab-width (+ llprolog-indent-width (column-of-um-lparen))))
	  ((looking-at "[,>]") (column-of-prev-term))
	  (t (column-of-um-lparen)))))
 
;; JA 890601
(defun column-of-prev-term ()
  (beginning-of-line)
  (skip-chars-forward " \t\[{(;")
  (current-column))

;; JA 890601
(defun column-of-um-lparen ()
  (let ((pbal 0))
    (while (and (>= pbal 0)
		(or (> (current-column) 0)
		    (looking-at "[ \t]")))
      (cond ((looking-at "[\]})]")
	     (setq pbal (1+ pbal))
	     (forward-char -1))
	    ((looking-at "[\[{(]")
	     (setq pbal (1- pbal))
	     (forward-char -1))
	    ((looking-at "'")
	     (search-backward "'" nil t)
	     (forward-char -1))
	    ((looking-at "\"")
	     (search-backward "\"" nil t)
	     (forward-char -1))
	    (t (forward-char -1)))))
  (forward-char 1)  ;; Reset buffer pointer to prev column
  (current-column))

(defun end-of-llprolog-clause ()
  "Go to end of clause in this line."
  (beginning-of-line)
  (let* ((eolpos (save-excursion (end-of-line) (point))))
    (if (re-search-forward comment-start-skip eolpos 'move)
	(goto-char (match-beginning 0)))
    (skip-chars-backward " \t")))

(defun llprolog-comment-indent ()
  "Compute llprolog comment indentation."
  (cond ((looking-at "%%%") 0)
	((looking-at "%%") (llprolog-indent-level))
	(t
	 (save-excursion
	       (skip-chars-backward " \t")
	       (max (1+ (current-column)) ;Insert one space at least
		    comment-column)))))


(defvar inferior-llprolog-mode-map nil)

(defun inferior-llprolog-mode ()
  "Major mode for interacting with an inferior LLProlog process.

The following commands are available:
\\{inferior-llprolog-mode-map}

Entry to this mode calls the value of llprolog-mode-hook with no arguments,
if that value is non-nil.  Likewise with the value of comint-mode-hook.
llprolog-mode-hook is called after comint-mode-hook.

You can send text to the inferior LLProlog from other buffers
using the commands send-region, send-string and \\[llprolog-consult-region].

Commands:
Tab indents for LLProlog; with argument, shifts rest
 of expression rigidly with the current line.
Paragraphs are separated only by blank lines and '%%'. '%'s start comments.

Return at end of buffer sends line as input.
Return not at end copies rest of line to end and sends it.
\\[comint-delchar-or-maybe-eof] sends end-of-file as input.
\\[comint-kill-input] and \\[backward-kill-word] are kill commands, imitating normal Unix input editing.
\\[comint-interrupt-subjob] interrupts the shell or its current subjob if any.
\\[comint-stop-subjob] stops, likewise. \\[comint-quit-subjob] sends quit signal, likewise."
  (interactive)
  (cond ((not (eq major-mode 'inferior-llprolog-mode))
	 (kill-all-local-variables)
	 (comint-mode)
	 (setq comint-input-filter 'llprolog-input-filter)
	 (setq major-mode 'inferior-llprolog-mode)
	 (setq mode-name "Inferior LLProlog")
	 (setq mode-line-process '(": %s"))
	 (llprolog-mode-variables)
	 (if inferior-llprolog-mode-map
	     nil
	   ; HB: 930205: Use the "correct" function 'copy-keymap'
	   ; to copy a keymap.
	   (setq inferior-llprolog-mode-map (copy-keymap comint-mode-map))
	   (define-key inferior-llprolog-mode-map "\t" 'llprolog-indent-line))
	 (use-local-map inferior-llprolog-mode-map)
	 (setq comint-prompt-regexp "^| [ ?][- ] *") ;Set llprolog prompt pattern
	 (run-hooks 'llprolog-mode-hook))))

(defun llprolog-input-filter (str)
  (cond ((string-match "\\`\\s *\\'" str) nil) ;whitespace
	((not (eq major-mode 'inferior-llprolog-mode)) t)
	((= (length str) 1) nil)	;one character
	((string-match "\\`[rf] *[0-9]*\\'" str) nil) ;r(edo) or f(ail)
	(t t)))

(defun run-llprolog ()
  "Run an inferior LLProlog process, input and output via buffer *llprolog*."
  (interactive)
  (let ((buff (buffer-name)))
    (switch-to-buffer (make-comint "llprolog" llprolog-system))
    (inferior-llprolog-mode)))

(defun ensure-llprolog-process ()
  (make-comint "llprolog" llprolog-system))

;;------------------------------------------------------------
;; Consulting
;;------------------------------------------------------------


;; PO 890606
(defun llprolog-consult-region (start end)
  "Consults the region"
   (interactive "r")
   (ensure-llprolog-process)
   (save-excursion
     (sicstus-write-region start end llprolog-temp-llp-file))
   (process-send-string "llprolog" (build-llprolog-command "consult"))
   (switch-to-buffer-other-window "*llprolog*"))


;; PO 890606
(defun llprolog-consult-buffer ()
  "Consults the entire buffer."
  (interactive)
  (llprolog-consult-region (point-min) (point-max)))


;; PO 890606
(defun llprolog-consult-predicate ()
  "Consults the predicate around point."
  (interactive)
  (let ((boundaries (predicate-boundaries)))
    (llprolog-consult-region (car boundaries) (cdr boundaries))))

;;------------------------------------------------------------
;;Compiling
;;------------------------------------------------------------

;; PO 890606
(defun llprolog-compile-region (start end)
  "Compiles the region."
   (interactive "r")
   (ensure-llprolog-process)
   (save-excursion
     (sicstus-write-region start end llprolog-temp-llp-file))
   (process-send-string "llprolog" (build-llprolog-command "compile"))
   (switch-to-buffer-other-window "*llprolog*"))


;; PO 890606
(defun llprolog-compile-buffer ()
  "Compiles the entire buffer."
  (interactive)
  (llprolog-compile-region (point-min) (point-max)))


;; PO 890606
(defun llprolog-compile-predicate ()
  "Compiles the predicate around point."
  (interactive)
  (let ((boundaries (predicate-boundaries)))
    (llprolog-compile-region (car boundaries) (cdr boundaries))))


;; PO 890606
;; Must be improved. Cannot handle predicates with clauses
;; separated by newlines.

(defun predicate-boundaries ()
  ;; Find "beginning" of predicate
  (beginning-of-line)
  (while (and (not (looking-at "\n")) (not (bobp)))
    (forward-line -1)
    (skip-chars-forward " \t"))
  (let ((start (point)))

    ;; Find "end" of predicate
    (forward-line 1)
    (skip-chars-forward " \t")
    (while (and (not (looking-at "\n")) (not (eobp)))
      (forward-line 1)
      (skip-chars-forward " \t"))
    (cons start (point))))

;; JB 890609
(defun sicstus-write-region (minpoint maxpoint filename)
  (let ((tmpbuffer (generate-new-buffer "tmpbuffer"))
	(buffercont (buffer-substring minpoint maxpoint)))
    (set-buffer tmpbuffer)
    (insert buffercont "\n")
    (write-region (point-min) (point-max) filename nil nil)
    (kill-buffer tmpbuffer)))

;; JB 890613
;; not in use -matsc
(defun sicstus-switch-to-buffer-other-window (buffer)
  (let ((currently-selected-window (selected-window)))
    (switch-to-buffer-other-window buffer)
    (select-window currently-selected-window)))


;; With this handy function this file can be compiled as
;; emacs -batch -l llprolog.el -f compile-llprolog
(defun compile-llprolog ()
  (byte-recompile-directory "." t))

;; for hilit19
(if (fboundp 'hilit-set-mode-patterns)
    (hilit-set-mode-patterns 'llprolog-mode
      '(("/\\*" "\\*/" comment)
	("%.*$" nil comment)
	(":-" nil defun)
	("\\(&\\|-<>\\)" nil decl)      ;; for LLP
	("\\({\\|}\\)" nil include)     ;; for LLP
	("!" nil label)
	("\"[^\\\"]*\\(\\\\\\(.\\|\n\\)[^\\\"]*\\)*\"" nil string)
	("\\b\\(is\\|mod\\)\\b" nil keyword)
	("\\(->\\|-->\\|;\\|==\\|\\\\==\\|=<\\|>=\\|<\\|>\\|=\\|\\\\=\\|=:=\\|=\\\.\\\.\\|\\\\\\\+\\)" nil decl)
	("\\(\\\[\\||\\|\\\]\\)" nil include)))
)

;;; Change log: prolog.el
;;; 92-03-20 1.2
;;; - Johan Bevemyr's adaption to the comint package
;;; - change from sicstus0.7 to sicstus2.1
;;; - treat "where" specially in indent-for-new-clause
;;; 92-04-24 1.5
;;; - added EPROLOG env variable
;;; - flush sicstus-switch-to-buffer-other-window
;;; - update compile-prolog to recompile entire directory
;;; 92-08-28 1.6
;;; - fix broken input history filter for Prolog mode
;;; 92-10-07 1.7
;;; - add prolog-version
;;; - don't treat "where" specially in indent-for-new-clause
;;; 93-01-27 1.8
;;; - change log updated
;;; 93-02-05 1.10
;;; - use copy-keymap where appropriate
;;; 
;;; Change log: llprolog.el
;;; 96-12-06 1.0
