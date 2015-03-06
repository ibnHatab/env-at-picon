; comint
(require 'comint)
(define-key comint-mode-map [(meta p)]
  'comint-previous-matching-input-from-input)
(define-key comint-mode-map [(meta n)]
  'comint-next-matching-input-from-input)
(define-key comint-mode-map [(control meta n)]
  'comint-next-input)
(define-key comint-mode-map [(control meta p)]
  'comint-previous-input)


;; use ido for minibuffer completion
(require 'ido)
(ido-mode t)
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ace jump mode
(when (locate-library "ace-jump-mode")
  (require 'ace-jump-mode)
  (define-key global-map (kbd "C-0") 'ace-jump-mode)
  )


(autoload 'nuke-trailing-whitespace "whitespace" nil t) ;remove trailing
(setq scroll-step 1)                    ; scrolling page
(setq case-fold-search nil)             ; make searches case sensitive


(custom-set-variables
 '(global-auto-revert-mode 1)
 '(kill-whole-line t)
 '(show-paren-style (quote parenthesis))
 '(compilation-window-height 14)
 '(transient-mark-mode t)
 '(truncate-lines nil)
 '(vc-initial-comment t)
 '(vc-command-messages t)
 '(show-paren-mode t nil (paren))
 '(truncate-partial-width-windows nil)
 '(c-echo-syntactic-information-p nil)
 '(show-paren-ring-bell-on-mismatch t)
 '(blink-matching-paren-on-screen t)
 '(next-line-add-newlines nil)
 '(global-font-lock-mode t nil (font-lock))
 '(font-lock-global-modes t))

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








