;;; elec-c.el --- Gosmacs-like electric C code editing mode

;; (C) Copyright 1998 Ilya Zakharevich

;; Author: Ilya Zakharevich <ilya@math.ohio-state.edu>
;; Created: Oct 1998
;; Maintainer: Ilya Zakharevich <ilya@math.ohio-state.edu>

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;;; Commentary:

;;;  This code is borrowed from CPerl:

;;;  To use it, 
;;    (autoload 'elec-par-install-electric "elec-par")
;;;  Then to add to Emacs-Lisp mode:
;;    (add-hook 'emacs-lisp-mode-hook 'elec-par-install-electric)

(defconst elec-par-xemacs-p (string-match "XEmacs\\|Lucid" emacs-version))
(defun elec-par-mark-active () (mark))	; Avoid undefined warning
(if elec-par-xemacs-p
    (progn
      ;; "Active regions" are on: use region only if active
      ;; "Active regions" are off: use region unconditionally
      (defun elec-par-use-region-p ()
	(if zmacs-regions (mark) t)))
  (defun elec-par-use-region-p ()
    (if transient-mark-mode mark-active t))
  (defun elec-par-mark-active () mark-active))

(defvar elec-par-electric-parens-mark 
  (and window-system
       (or (and (boundp 'transient-mark-mode) ; For Emacs
		transient-mark-mode)
	   (and (boundp 'zmacs-regions) ; For XEmacs
		zmacs-regions)))
  "*Not-nil means that electric parens look for active mark.
Default is yes if there is visual feedback on mark.")

(defvar elec-par-electric-parens-string "({[]})<"
  "*String of parentheses that should be electric.
Closing ones are electric only if the region is highlighted.")

(defvar elec-par-electric-parens t
  "*Non-nil means parentheses should be electric.")


(defun elec-par-electric-paren (arg)
  "Insert a matching pair of parentheses."
  (interactive "P")
  (let ((beg (save-excursion (beginning-of-line) (point)))
	(other-end (if (and elec-par-electric-parens-mark
			    (elec-par-mark-active) 
			    (> (mark) (point)))
			   (save-excursion
			     (goto-char (mark))
			     (point-marker)) 
		     nil)))
    (if (and elec-par-electric-parens
	     (memq last-command-char
		   (append elec-par-electric-parens-string nil)))
	(progn
	  (self-insert-command (prefix-numeric-value arg))
	  (if other-end (goto-char (marker-position other-end)))
	  (insert (make-string 
		   (prefix-numeric-value arg)
		   (cdr (assoc last-command-char '((?{ .?})
						   (?[ . ?])
						   (?( . ?))
						   (?< . ?>))))))
	  (forward-char (- (prefix-numeric-value arg))))
      (self-insert-command (prefix-numeric-value arg)))))

(defun elec-par-electric-rparen (arg)
  "Insert a matching pair of parentheses if marking is active.
If not, or if we are not at the end of marking range, would self-insert."
  (interactive "P")
  (let ((beg (save-excursion (beginning-of-line) (point)))
	(other-end (if (and elec-par-electric-parens-mark
			    elec-par-electric-parens
			    (memq last-command-char
				  (append elec-par-electric-parens-string nil))
			    (elec-par-mark-active) 
			    (< (mark) (point)))
		       (mark) 
		     nil))
	p)
    (if (and other-end
	     elec-par-electric-parens
	     (memq last-command-char '( ?\) ?\] ?\} ?\> ))
	     ;;(>= (save-excursion (elec-par-to-comment-or-eol) (point)) (point))
	     ;;(not (save-excursion (search-backward "#" beg t)))
	     )
	(progn
	  (self-insert-command (prefix-numeric-value arg))
	  (setq p (point))
	  (if other-end (goto-char other-end))
	  (insert (make-string
		   (prefix-numeric-value arg)
		   (cdr (assoc last-command-char '((?\} . ?\{)
						  (?\] . ?\[)
						  (?\) . ?\()
						  (?\> . ?\<))))))
	  (goto-char (1+ p)))
      (self-insert-command (prefix-numeric-value arg)))))

(defun elec-par-install-electric (&optional str keymap)
  "Define the chars from STR and matching chars to be electric in KEYMAP.
Default STR is \"([])\", default KEYMAP is the current local map."
  (interactive)
  (or keymap
      (setq keymap (current-local-map)))
  (or str 
      (setq str "([])"))		; Regular expressions!
  (if (stringp str)
      (setq str (append str nil)))
  (while str
    (define-key keymap (make-string 1 (car str)) 
      (if (memq (car str) (append "([{<" nil))
	  'elec-par-electric-paren
	'elec-par-electric-rparen))
    (setq str (cdr str))))



