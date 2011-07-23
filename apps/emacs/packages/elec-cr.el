;;; elec-cr.el --- Gosmacs-like reduced electric C code editing mode

;; (C) Copyright 1987, 1993 Mark Davies, 1993-1998 Ilya Zakharevich

;; Author: Mark Davies <mark@comp.vuw.ac.nz> Ilya Zakharevich <ilya@math.ohio-state.edu>
;; Created: Dec 1985
;; Maintainer: Ilya Zakharevich <ilya@math.ohio-state.edu> 
;; Keywords: c

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; *Original* LCD Archive Entry:
;; elec-c|Mark Davies|mark@comp.vuw.ac.nz
;; |Gosmacs-like electric C code editing mode
;; |93-07-10|version 2.0|~/modes/elec-c.el.Z

;;; Commentary:

;; Originally written in Dec 1985 inspired by the Gosling emacs electric C
;; mode, then revised in Jun 1987.
;; Updated for emacs 19 and enhanced in Jun 1993.
;; Thanks to Andrew Vignaux <ajv@datamark.co.nz> for the code to
;; incorporate the current line into the condition for a new if/while/do
;; construct.

;; I invoke this from my .emacs file with the following incantation
;;   (add-hook 'c-mode-hook 'elec-c-mode)
;;   (add-hook 'elec-c-mode-hook 'turn-on-auto-fill)
;;   (autoload 'elec-c-mode "elec-c" "High powered C editing mode." t)

;; Corrected/updated by Ilya Zakharevich

;;; Code:


(defvar elec-cr-mode-abbrev-table nil
  "Abbrev table in use in elec-cr-mode buffers.")

(defvar elec-cr-mode-map nil
  "Keymap used in elec C mode.")
(defvar elec-c++-mode-map nil
  "Keymap used in elec C++ mode.")

(defun elec-cr-load-map ()
  (if elec-cr-mode-map
      ()
    ;;(setq elec-cr-mode-map (make-sparse-keymap))
    ;; (require 'c-mode)			;get c-mode-map
    (setq elec-cr-mode-map (copy-keymap c-mode-map))
    ;;(setq elec-cr-mode-map (make-sparse-keymap))
    (if (fboundp 'c-electric-brace)
	(progn
	  (define-key elec-cr-mode-map "{" 'elec-cr-left-brace1)
	  (define-key elec-cr-mode-map "}" 'elec-cr-right-brace1))
      (define-key elec-cr-mode-map "{" 'elec-cr-left-brace))
    ;;(define-key elec-cr-mode-map "}" 'electric-c-brace)
    (define-key elec-cr-mode-map "(" 'elec-cr-opening-brac)
    (define-key elec-cr-mode-map "[" 'elec-cr-opening-brac)
    ;;(define-key elec-cr-mode-map "#" 'electric-c-sharp-sign)
    ;;(define-key elec-cr-mode-map ";" 'elec-cr-semi)
    ;;(define-key elec-cr-mode-map ":" 'electric-c-terminator)
    ;;(define-key elec-cr-mode-map "\e\C-h" 'mark-c-function)
    ;;(define-key elec-cr-mode-map "\e\C-q" 'indent-c-exp)
    ;;(define-key elec-cr-mode-map "\ea" 'c-beginning-of-statement)
    ;;(define-key elec-cr-mode-map "\ee" 'c-end-of-statement)
    ;;(define-key elec-cr-mode-map "\eq" 'c-fill-paragraph)
    ;;(define-key elec-cr-mode-map "\C-c\C-n" 'c-forward-conditional)
    ;;(define-key elec-cr-mode-map "\C-c\C-p" 'c-backward-conditional)
    ;;(define-key elec-cr-mode-map "\C-c\C-u" 'c-up-conditional)
    (define-key elec-cr-mode-map "\177" 'elec-cr-electric-backspace)
    (define-key elec-cr-mode-map "\C-c\C-c" 'elec-cr-close-block)
    (define-key elec-cr-mode-map "\C-cv" 'elec-cr-toggle-verbatim)
    (define-key elec-cr-mode-map "\e{" 'elec-cr-remove-braces)
    (define-key elec-cr-mode-map "\C-j" 'elec-cr-linefeed)
    ;;(define-key elec-cr-mode-map "\t" 'c-indent-command)
    ))

(modify-syntax-entry ?# "w" c-mode-syntax-table) ;so abbrevs work

;; this should really be a user preference option
;(modify-syntax-entry ?_ "w" c-mode-syntax-table)

(defvar elec-cr-electric-parens t
  "Should parens be electric?")
(defvar elec-cr-electric-parens-mark (and window-system transient-mark-mode)
  "Should electric parens look for mark?
Default is yes if there is visual feedback on mark.")
(defvar elec-cr-brace-on-same-line t
  "Should braces follow after if's for's etc or be on separate line.")

(defvar elec-cr-indent-preprocessor 2
  "Additional indentation for nested preprocessor statements.")

(defconst comment-edged nil
  "*Use comments with an edge.
   eg.      /*
             * ...
             */")

(defconst elec-cr-style-alist
  '(("GNU"
     (elec-cr-brace-on-same-line . nil))
    ("K&R"
     (elec-cr-brace-on-same-line . t))
    ("BSD"
     (elec-cr-brace-on-same-line . t))))

;;
;; Add elec-c settings to c-style-alist
(setq c-style-alist
      (mapcar '(lambda (taglist)
		 (let ((tag (car taglist)))
		   (cons tag
			 (append
			  (cdr taglist)
			  (cdr (assoc tag elec-cr-style-alist))))))
	      c-style-alist))


(setq c-auto-newline t)  ;; "Internal state of auto newline feature.")

(defun elec-cr-mode ()
  "High powered C editing mode.
Elec C mode provides expansion of the C control constructs:
   if, else, while, for, do, and switch.
The user types the keyword immediately followed by a space, which causes
the construct to be expanded, and the user is positioned where she is most
likely to want to be.
eg. when the user types a space following \"if\" the following appears in
the buffer:
            if () {
            }

and the cursor is between the parentheses.  The user can then type some
boolean expression within the parens.  Having done that, typing \\[elec-cr-linefeed]
places you, appropriately indented on a new line between the braces.

Various characters in C almost always come in pairs: {}, (), [].
When the user types the first, she gets the second as well, with optional
special formatting done on {}.  You can always quote (with \\[quoted-insert]) the left
\"paren\" to avoid the expansion.

#de, and #in are defined as abbreviations for #define and #include 
respectively.

With auto-fill-mode on, three types of automatic formatting of comments are
possible. The default is of the form
                            /* ...   ... */
                            /* ...     ... */
If comment-multi-line is set non-nil you get comments of the form
                            /* ...   ...
                               ...     ... */
If additionally comment-edged is set non-nil you get comments of the form
                            /*
                             * ...    ...
                             */

Expression and list commands understand all C brackets.
Tab indents for C code.
Paragraphs are separated by blank lines only.
Delete converts tabs to spaces as it moves back.
\\{elec-cr-mode-map}
Variables controlling indentation style:
 c-auto-newline
    Non-nil means automatically newline before and after braces,
       and after colons and semicolons, inserted in C code.
    with this on colons and semicolons want to go to the end of the line.
 c-indent-level
    Indentation of C statements within surrounding block.
    The surrounding block's indentation is the indentation of the line
    on which the open-brace appears.
 c-continued-statement-offset
    Extra indentation given to a substatement, such as the then-clause
    of an if or body of a while
 c-continued-brace-offset
    Extra indentation given to a brace that starts a substatement.
    This is in addition to c-continued-statement-offset.
 c-brace-offset
    Extra indentation for a line if it starts with an open brace.
 c-brace-imaginary-offset
    An open brace following other text is treated as if it were this far
    to the right of the start of its line.
 c-argdecl-indent
    Indentation level of declarations of C function arguments.
 c-label-offset
    Extra indentation for line that is a label, or case or default.

Turning on elec C mode calls the value of the variable elec-cr-mode-hook
with no args, if that value is non-nil."
  (interactive)
  (elec-cr-load-map)
  ;;(kill-all-local-variables)
  (if (string-match "\\+\\+" mode-name) 
      (progn
	(elec-cr-c++-setup)
	(use-local-map elec-c++-mode-map))
    (use-local-map elec-cr-mode-map))
  ;;(setq major-mode 'elec-cr-mode)
  (setq mode-name (if (string-match "\\+\\+" mode-name) "C++/e" "C/e"))
  (if (not elec-cr-mode-abbrev-table)
      (let ((prev-a-c abbrevs-changed))
	(define-abbrev-table 'elec-cr-mode-abbrev-table '(
        	("main" "main" elec-cr-keyword-main 0)
		("argc" "argc" elec-cr-keyword-argc 0)
		("if" "if" elec-cr-keyword-if-while 0)
		("elsif" "else if" elec-cr-keyword-if-while 0)
		("switch" "switch" elec-cr-keyword-if-while 0)
		("while" "while" elec-cr-keyword-if-while 0)
		("else" "else" elec-cr-keyword-else 0)
		("for" "for" elec-cr-keyword-for 0)
		("do" "do" elec-cr-keyword-do 0)
		("#d" "#define" elec-cr-insert-indent-preprocessor 0)
		("#de" "#define" elec-cr-insert-indent-preprocessor 0)
		("#e" "#endif" elec-cr-insert-indent-preprocessor 0)
		("#el" "#else" elec-cr-insert-indent-preprocessor 0)
		("#i" "#ifdef" elec-cr-insert-indent-preprocessor 0)
		("#if" "#if" elec-cr-insert-indent-preprocessor 0)
		("#endif" "#endif" elec-cr-insert-indent-preprocessor 0)
		("#else" "#else" elec-cr-insert-indent-preprocessor 0)
		("#elif" "#elif" elec-cr-insert-indent-preprocessor 0)
		("#ifdef" "#ifdef" elec-cr-insert-indent-preprocessor 0)
		("#include" "#include" elec-cr-insert-indent-preprocessor 0)
		("#in" "#include" elec-cr-insert-indent-preprocessor 0)))
	(setq abbrevs-changed prev-a-c)))
  (setq local-abbrev-table elec-cr-mode-abbrev-table)
  (abbrev-mode 1)
  ;;(set-syntax-table c-mode-syntax-table)
  (make-local-variable 'elec-cr-electric-parens)
  ;;(make-local-variable 'paragraph-start)
  ;;(setq paragraph-start (concat "^$\\|" page-delimiter))
  ;;(make-local-variable 'paragraph-separate)
  ;;(setq paragraph-separate paragraph-start)
  ;;(make-local-variable 'indent-line-function)
  ;;(setq indent-line-function 'c-indent-line)
  ;;(make-local-variable 'indent-region-function)
  ;;(setq indent-region-function 'c-indent-region)
  (make-local-variable 'require-final-newline)
  (make-local-variable 'elec-cr-indent-preprocessor)
  (setq require-final-newline t)
  ;;(make-local-variable 'comment-start)
  ;;(setq comment-start "/* ")
  ;;(make-local-variable 'comment-end)
  ;;(setq comment-end " */")
  ;;(make-local-variable 'comment-column)
  ;;(setq comment-column 32)
  ;;(make-local-variable 'comment-start-skip)
  ;;(setq comment-start-skip "/\\*+ *")
  ;;(make-local-variable 'comment-indent-function)
  ;;(setq comment-indent-function 'c-comment-indent)
  (make-local-variable 'c-electric-pound-behavior)
  (setq c-electric-pound-behavior '(alignleft))
  ;;(make-local-variable 'parse-sexp-ignore-comments)
  ;;(setq parse-sexp-ignore-comments t)
  (run-hooks 'elec-cr-mode-hook))

(defun elec-cr-c++-setup ()
  (if elec-c++-mode-map
      nil
  (setq elec-c++-mode-map (copy-keymap c++-mode-map))
  (if (fboundp 'c-electric-brace)
      (progn
	(define-key elec-cr-mode-map "{" 'elec-cr-left-brace1)
	(define-key elec-cr-mode-map "}" 'elec-cr-right-brace1))
    (define-key elec-c++-mode-map "{" 'elec-cr-left-brace))
  ;;(define-key elec-c++-mode-map "}" 'electric-c-brace)
  (define-key elec-c++-mode-map "(" 'elec-cr-opening-brac)
  (define-key elec-c++-mode-map "[" 'elec-cr-opening-brac)
  ;;(define-key elec-c++-mode-map "#" 'electric-c-sharp-sign)
  ;;(define-key elec-c++-mode-map ";" 'elec-cr-semi)
  ;;(define-key elec-c++-mode-map ":" 'electric-c-terminator)
  ;;(define-key elec-c++-mode-map "\e\C-h" 'mark-c-function)
  ;;(define-key elec-c++-mode-map "\e\C-q" 'indent-c-exp)
  ;;(define-key elec-c++-mode-map "\ea" 'c-beginning-of-statement)
  ;;(define-key elec-c++-mode-map "\ee" 'c-end-of-statement)
  ;;(define-key elec-c++-mode-map "\eq" 'c-fill-paragraph)
  ;;(define-key elec-c++-mode-map "\C-c\C-n" 'c-forward-conditional)
  ;;(define-key elec-c++-mode-map "\C-c\C-p" 'c-backward-conditional)
  ;;(define-key elec-c++-mode-map "\C-c\C-u" 'c-up-conditional)
  (define-key elec-c++-mode-map "\177" 'elec-cr-electric-backspace)
  (define-key elec-c++-mode-map "\C-c\C-c" 'elec-cr-close-block)
  (define-key elec-c++-mode-map "\C-cv" 'elec-cr-toggle-verbatim)
  (define-key elec-c++-mode-map "\e{" 'elec-cr-remove-braces)
  (define-key elec-c++-mode-map "\C-j" 'elec-cr-linefeed)
  (define-key elec-c++-mode-map [menu-bar c cctags] '("iTags" . imenu-cctags-jump-tag))
  ;;(define-key elec-c++-mode-map "\t" 'c-indent-command)
  ))

; so lets hope noone writes *LARGE* C files.
(defun elec-cr-inside-comment-p ()
  (nth 4 (parse-partial-sexp (point-min) (point))))

(defun elec-cr-inside-string-p ()
  (nth 3 (parse-partial-sexp (point-min) (point))))

(defun elec-cr-inside-comment-or-string-p ()
  (let ((parse-state (parse-partial-sexp (point-min) (point))))
    (or (nth 4 parse-state) (nth 3 parse-state))))

(defun elec-cr-open-block ()
  (interactive)
  (search-forward "{")
  (backward-char 1)
  (forward-sexp 1)
  (backward-char 1)
  (split-line)
  (c-indent-line))

(defun elec-cr-close-block ()
  (interactive)
  (while (not (looking-at "{"))
    (backward-up-list 1))
  (forward-sexp 1)
  (save-excursion
    (forward-line -1)
    (delete-blank-lines)
    (beginning-of-line)
    (if (looking-at "[ \t]*$")
	(kill-line 1)))
  (end-of-line)
  (newline)
  (c-indent-line))

(defun elec-cr-remove-braces ()
  "remove the surrounding pair of {}'s from the function."
  (interactive)
  (save-excursion
    (while (not (looking-at "{"))
      (backward-up-list 1))
    (let (end)
      (save-excursion			; kill tail
	(forward-sexp 1)
	(delete-char -1)
	(delete-horizontal-space)
	(and (bolp) (eolp)
	     (delete-char 1))
	(setq end (point-marker)))
      (delete-char 1)			; kill head
      (delete-horizontal-space)
      (and (bolp) (eolp)
	   (delete-char 1))
      (while (<= (point) (marker-position end))
	(c-indent-line)
	(forward-line 1)))))

(defun elec-cr-linefeed ()
  "Go to end of line, open a new line and indent appropriately."
  (interactive)
  (end-of-line)
  (and (not (elec-cr-inside-comment-p))
       (= (preceding-char) ?\))
       (looking-at "\n[ \t]*{")
       (forward-line 1)
       (end-of-line))
  (newline-and-indent))

(defun elec-cr-left-brace ()
  "if c-auto-newline is on insert matching close brace and format appropriately."
  (interactive)
  (if (not c-auto-newline)
      (elec-cr-opening-brac)
    (let ((other-end (if (and elec-cr-electric-parens-mark
			      mark-active (> (mark) (point)))
			 (save-excursion
			   (goto-char (mark))
			   (point-marker)) 
		       nil)))
      (if elec-cr-electric-parens-mark (setq mark-active nil))
      (if other-end nil
	(end-of-line)
	(delete-horizontal-space))
      (if (/= (char-syntax (preceding-char)) ? )
	  (insert ? ))
      (insert ?{)
      (c-indent-line)
      (insert "\n")
      (if other-end (goto-char (marker-position other-end)))
      (insert "\n}")
      (c-indent-line)
      (forward-line -1)
      (c-indent-line)
      (end-of-line))))
      
(defun elec-cr-left-brace1 (arg)
  "For one of (, [, { insert it and its pair, and position point in the centre"
  ;;  Use syntax assist from cc-mode
  (interactive "P")
  (let ((other-end (if (and elec-par-electric-parens-mark
			    elec-par-electric-parens
			    (memq last-command-char
				  (append elec-par-electric-parens-string nil))
			    (elec-par-mark-active) 
			    (> (mark) (point)))
		       (mark) 
		     nil))
	m)
    (if other-end (set-marker (setq m (make-marker)) other-end))
    (or (memq (preceding-char) '(?\  ?\t ?\n))
	(not m)
	(insert " "))
    (c-electric-brace arg)
    (if (eq (preceding-char) ?{)
	;; Was not electric
	nil
      (let ((p (point)))
	(if other-end (goto-char m))
	(insert "\n")
	(setq last-command-char ?\})
	(c-electric-brace arg)
	(goto-char p)))))

(defun elec-cr-right-brace1 (arg)
  "For one of (, [, { insert it and its pair, and position point in the centre"
  ;;  Use syntax assist from cc-mode
  (interactive "P")
  (let ((other-end (if (and elec-par-electric-parens-mark
			    elec-par-electric-parens
			    (memq last-command-char
				  (append elec-par-electric-parens-string nil))
			    (elec-par-mark-active) 
			    (< (mark) (point)))
		       (mark) 
		     nil))
	m p
	(c last-command-char))
    (if other-end 
	(progn
	  (setq m (make-marker))
	  (set-marker m (point))
	  (goto-char other-end)
	  (or (memq (preceding-char) '(?\  ?\t ?\n))
	      (insert " "))
	  (setq last-command-char ?\{)
	  (c-electric-brace arg)
	  ;;(insert "\n")
	  (goto-char m)))
    (setq p (point))
    (setq last-command-char c)
    (c-electric-brace arg)
    (goto-char p)))

(defun elec-cr-opening-brac ()
  "For one of (, [, { insert it and its pair, and postion point in the centre"
  (interactive)
  (let ((other-end (if (and elec-cr-electric-parens-mark
			    mark-active (> (mark) (point)))
		       (save-excursion
			 (goto-char (mark))
			 (point-marker)) 
		     nil)))
    (if elec-cr-electric-parens-mark (setq mark-active nil))
    (insert last-command-char)
    (if (and elec-cr-electric-parens (not (elec-cr-inside-comment-or-string-p)))
	(progn
	  (if other-end (goto-char (marker-position other-end)))
	  (cond
	   ((= last-command-char ?\() (insert ?\)))
	   ((= last-command-char ?\{) (insert ?\}))
	   ((= last-command-char ?[) (insert ?])))
	  (forward-char -1)))))

(defun elec-cr-electric-backspace (arg)
  "Backspace-untabify, or remove the whitespace inserted by an electric key."
  (interactive "p")
  (if (and c-auto-newline 
	   (memq last-command '(elec-cr-semi 
				;;elec-cr-electric-terminator
				elec-cr-left-brace))
	   (memq (preceding-char) '(?  ?\t ?\n)))
      (let (p)
	(if (eq last-command 'elec-cr-left-brace) 
	    (skip-chars-forward " \t\n"))
	(setq p (point))
	(skip-chars-backward " \t\n")
	(delete-region (point) p))
    (backward-delete-char-untabify arg)))

(defun elec-cr-keyword-main ()
  (if (elec-cr-inside-comment-or-string-p)
      nil
    (insert-string " ()\n{\n}\n")
    (search-backward ")")
    (setq unread-command-events '(?\C-?))))

(defun elec-cr-keyword-argc ()
  (if (save-excursion
	(beginning-of-line)
	(looking-at 
	 "\\(int[ \t]+\\)?main[ \t]*([ \t]*\\(int[ \t]+\\)?argc[ \t]*)"))
      (progn
	(if (match-beginning 2) nil
	  (forward-word -1)
	  (insert-string "int ")
	  (forward-word 1))
	(if (or (match-beginning 1)
		(save-excursion
		  (beginning-of-line)
		  (forward-sexp -1)
		  (looking-at "int\\>"))) 
	    nil
	  (beginning-of-line)
	  (insert-string "int\n")
	  (search-forward "argc"))
	(insert-string ", char* argv[], char* envp[]")
	(end-of-line)
	;;(newline) (c-indent-line)
	;;(insert-string "int argc;")
	;;(newline) (c-indent-line)
	;;(insert-string "char *argv [];")
	(elec-cr-open-block)
	(setq unread-command-events '(?\C-?)))))

(defun elec-cr-keyword-if-while ()
  (if (elec-cr-inside-comment-or-string-p)
      nil
    (let ((empty-condition (eolp)))
      (insert-string " (")
      (or empty-condition
	  (elec-cr-incorporate-line))
      (insert-string ")")
      (if elec-cr-brace-on-same-line
	  (insert-string " {")
	(insert-string "\n{")
	(c-indent-line))
      (insert-string "\n}")
      (c-indent-line)
      (if empty-condition
	  (search-backward ")")
	(beginning-of-line)
 	(newline)
 	(backward-char 1)
 	(c-indent-line))
      (setq unread-command-events '(?\C-?)))))

(defun elec-cr-keyword-else ()
  (if (elec-cr-inside-comment-or-string-p)
      nil
    (if elec-cr-brace-on-same-line
	(insert-string " {")
      (insert-string "\n{")
      (c-indent-line))
    (insert-string "\n\n}")
    (c-indent-line)
    (forward-line -1)
    (c-indent-line)
    (setq unread-command-events '(?\C-?))))
    
(defun elec-cr-keyword-for ()
  (if (elec-cr-inside-comment-or-string-p)
      nil
    (insert-string " (;;)")
    (if elec-cr-brace-on-same-line
	(insert-string " {")
      (insert-string "\n{")
      (c-indent-line))
    (insert-string "\n}")
    (c-indent-line)
    (search-backward ";;)")
    (setq unread-command-events '(?\C-?))))

(defun elec-cr-keyword-do ()
  (if (elec-cr-inside-comment-or-string-p)
      nil
    (insert-string " {\n")
    (save-excursion
      (insert-string "\n} while (")
      (if (not (eolp))
	  (elec-cr-incorporate-line))
      (insert-string ");")
      (c-indent-line))
    (c-indent-line)
    (setq unread-command-events '(?\C-?))))

(defun elec-cr-incorporate-line ()
  ;; Incorporate the remainder of line which starts after (point) into the
  ;; if/while () test condition.
  ;; Strip any trailing ";"
  (delete-horizontal-space)
  (end-of-line)
  (if (= (preceding-char) ?\;)
      (delete-char -1)))

; this is a HACK but I can't think of a better place to do it.

(defun calculate-c-indent-within-comment (&optional after-star)
  "Return the indentation amount for line inside a block comment.
Optional arg AFTER-STAR means, if lines in the comment have a leading star,
return the indentation of the text that would follow this star."
  (let (end star-start)
    (and (eq major-mode 'c-mode)
	 comment-edged
	 (/= last-command-char ?\t)
	 (save-excursion
	   (insert "* ")))
    (save-excursion
      (beginning-of-line)
      (skip-chars-forward " \t")
      (setq star-start (= (following-char) ?\*))
      (skip-chars-backward " \t\n")
      (setq end (point))
      (beginning-of-line)
      (skip-chars-forward " \t")
      (if after-star
	  (and (looking-at "\\*")
	       (re-search-forward "\\*[ \t]*")))
      (and (re-search-forward "/\\*[ \t]*" end t)
	   star-start
	   (not after-star)
	   (goto-char (1+ (match-beginning 0))))
      (if (and (looking-at "[ \t]*$") (= (preceding-char) ?\*))
	  (1+ (current-column))
	(current-column)))))

(defun elec-cr-insert-indent-preprocessor ()
  "Indent the current preprocessor directive with an appropriate comment.
May insert a matching directive too."
  (let (p d (a 0) (e t) s def no hard-neg)
    (setq d (condition-case nil
		(save-excursion
		  (beginning-of-line)
		  (or (looking-at 
		       "[ \t]*#[ \t]*e\\(lse\\|lif\\|ndif\\)\\>")
		      (setq a elec-cr-indent-preprocessor))
		  (if (looking-at 
		       "[ \t]*#[ \t]*e\\(lse\\|ndif\\)\\>")
		      (setq e nil))
		  (if (looking-at 
		       "[ \t]*#[ \t]*else\\>")
		      (setq no t))
		  (if (looking-at 
		       "[ \t]*#[ \t]*if\\(def\\)?\\>")
		      (setq s t))
		  (setq hard-neg (and (not e) (not no)))
		  (if (and
		       (condition-case nil
			   (progn
			     (c-up-conditional 1)
			     t)
			 (error 
			  (setq a 0)
			  nil))
		       (looking-at "[ \t]*#[ \t]*[ide]"))
		      (progn
			(goto-char (match-end 0))
			(prog1
			    (- (current-column) 2)
			  (if e
			      nil
			    ;; Processing else/endif
			    (setq def (looking-at "fdef\\>")) ; ifdef
			    (forward-word 1)
			    (skip-chars-forward " \t")
			    (or (looking-at "$\\|/\\*\\|//")
				(setq e (buffer-substring (point)
							  (save-excursion
							    (end-of-line)
							    (point))))))
			  (if hard-neg
			      (progn
				(condition-case nil
				    (c-forward-conditional 4000000)
				  (error nil))
				;; Next conditional is else, elsif, or endif
				(re-search-forward "^[ \t]*#")
				(setq no (looking-at "els\\(e\\|if\\)"))))))
		    0))
	      (err 0)))
    (save-excursion
      (beginning-of-line)
      (setq p (point))
      (if (looking-at "\\=[ \t]*#[ \t]*[a-z]")
	  (progn
	    (goto-char (1- (match-end 0)))
	    (delete-char (- p (point)))
	    (insert "#")
	    (insert (make-string (+ d a) ?\ ))
	    (if s
		(progn
		  (beginning-of-line 2)
		  ;; Will not create a new line at end-of-buffer
		  (or (eq (preceding-char) ?\n)
		      (insert "\n"))
		  (insert "#endif\n")
		  (forward-char -1)
		  (elec-cr-insert-indent-preprocessor))))))
    (if (stringp e)
	(progn
	  (insert "\t/* " 
		  (if no "!( " "")
		  (if def "defined " "") e 
		  (if no " )" "")
		  " */")))))

;;; elec-c.el ends here


