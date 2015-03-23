

(when (fboundp 'winner-mode)
  (winner-mode 1))

;; use ido for minibuffer completion
(require 'ido)
(ido-mode t)
(ido-everywhere 1)

(setq ido-save-directory-list-file "~/.emacs.d/.ido.last")
(setq ido-enable-flex-matching t)
(setq ido-use-filename-at-point 'guess)
(setq ido-show-dot-for-dired t)
(setq ido-default-buffer-method 'selected-window)
(setq ido-decorations
      '("\n-> " "" "\n   " "\n   ..." "[" "]"
	" [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]"))


(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
(setq uniquify-separator "/")
(setq uniquify-after-kill-buffer-p t) ;rename after killing uniquify
(setq uniquify-ignore-buffers-re "^\\*")

(fset 'yes-or-no-p 'y-or-n-p)
(add-hook 'write-file-functions 'delete-trailing-whitespace)

(autoload 'nuke-trailing-whitespace "whitespace" nil t) ;remove trailing

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ace jump mode
(when (locate-library "ace-jump-mode")
  (require 'ace-jump-mode)
  (define-key global-map (kbd "C-0") 'ace-jump-mode)
  )

(setq scroll-step 1)                    ; scrolling page
(setq case-fold-search nil)             ; make searches case sensitive

;;Mouse well
(defun scroll-up-half ()
  "Scroll up half a page."
  (interactive)
  (scroll-up (/ (window-height) 3))
  )
(defun scroll-down-half ()
  "Scroll down half a page."
  (interactive)
  (scroll-down (/ (window-height) 3))
  )
;; Buffer cycling function
(defun my-unbury-buffer (&optional buf)
  "Select buffer BUF, or the last one in the buffer list.
   This function is the opposite of `bury-buffer'."
  (interactive)
  (or buf (setq buf (car (reverse (buffer-list)))))
  (switch-to-buffer buf)
  )

(require 'compile)
(setq mode-compile-always-save-buffer-p t)
(setq compilation-window-height 12)

(setq compilation-finish-function
      (lambda (buf str)
 	(unless (string-match "exited abnormally" str)
 	  ;;no errors, make the compilation window go away in a few seconds
 	  (run-at-time
 	   "4 sec" nil 'delete-windows-on
 	   (get-buffer-create "*compilation*"))
 	  (message "No Compilation Errors!"))))


(defun mo-toggle-identifier-naming-style ()
  "Toggles the symbol at point between C-style naming,
e.g. `hello_world_string', and camel case,
e.g. `HelloWorldString'."
  (interactive)
  (let* ((symbol-pos (bounds-of-thing-at-point 'symbol))
         case-fold-search symbol-at-point cstyle regexp func)
    (unless symbol-pos
      (error "No symbol at point"))
    (save-excursion
      (narrow-to-region (car symbol-pos) (cdr symbol-pos))
      (setq cstyle (string-match-p "_" (buffer-string))
            regexp (if cstyle "\\(?:\\_<\\|_\\)\\(\\w\\)" "\\([A-Z]\\)")
            func (if cstyle
                     'capitalize
                   (lambda (s)
                     (concat (if (= (match-beginning 1)
                                    (car symbol-pos))
                                 ""
                               "_")
                             (downcase s)))))
      (goto-char (point-min))
      (while (re-search-forward regexp nil t)
        (replace-match (funcall func (match-string 1))
                       t nil))
      (widen))))

(require 'cl) ; If you don't have it already

(defun* get-closest-pathname (&optional (file "Makefile"))
  "Determine the pathname of the first instance of FILE starting from the current directory towards root."
  (let ((root (expand-file-name "/")))
    (expand-file-name file
		      (loop
		       for d = default-directory then (expand-file-name ".." d)
		       if (file-exists-p (expand-file-name file d))
		       return d
		       if (equal d root)
		       return nil))))

;;;;; Theme ;;;;;
;; Cycle through this set of themes
(setq my-themes '(sanityinc-solarized-dark sanityinc-solarized-light wombat tango))

(setq my-cur-theme nil)
(defun cycle-my-theme ()
  "Cycle through a list of themes, my-themes"
  (interactive)
  (when my-cur-theme
    (disable-theme my-cur-theme)
    (setq my-themes (append my-themes (list my-cur-theme))))
  (setq my-cur-theme (pop my-themes))
  (load-theme my-cur-theme t))

;; --------------------------------------------------------------------------------


(defun move-text-internal (arg)
  (cond
   ((and mark-active transient-mark-mode)
    (if (> (point) (mark))
        (exchange-point-and-mark))
    (let ((column (current-column))
          (text (delete-and-extract-region (point) (mark))))
      (forward-line arg)
      (move-to-column column t)
      (set-mark (point))
      (insert text)
      (exchange-point-and-mark)
      (setq deactivate-mark nil)))
   (t
    (let ((column (current-column)))
      (beginning-of-line)
      (when (or (> arg 0) (not (bobp)))
        (forward-line)
        (when (or (< arg 0) (not (eobp)))
          (transpose-lines arg))
        (forward-line -1))
      (move-to-column column t)))))

(defun move-text-down (arg)
  "Move region (transient-mark-mode active) or current line
  arg lines down."
  (interactive "*p")
  (move-text-internal arg))

(defun move-text-up (arg)
  "Move region (transient-mark-mode active) or current line
  arg lines up."
  (interactive "*p")
  (move-text-internal (- arg)))

(setq ediff-window-setup-function 'ediff-setup-windows-plain)
(setq ediff-split-window-function 'split-window-vertically)
