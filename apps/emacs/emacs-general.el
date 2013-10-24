
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
(setq uniquify-separator "/")
(setq uniquify-after-kill-buffer-p t) ;rename after killing uniquify
(setq uniquify-ignore-buffers-re "^\\*")


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
 '(pc-selection-mode t nil (pc-select))
 '(font-lock-global-modes t))


;; Jump forward and backward through buffer list ; XEmacs mailing list

(defun gse-unbury-buffer ()
  "Switch to the buffer at the bottom of the buffer list, if it's not a
'hidden' buffer."
  (interactive)
  (let ((all-buffers (buffer-list))
        (done nil)
        (i 1))
    (setq i (- (length all-buffers) 1))
    (while (and (not done) (>= i 0))
      (let ((buf (nth i all-buffers))
            (first-char ""))
        (setq first-char (substring (buffer-name buf) 0 1))
        (if (not (or
                  (equal first-char "*")
                  (equal first-char " ")))
            (progn
              (switch-to-buffer buf)
              (setq done t))
          (setq i (- i 1))
          )))
    ))

(defun gse-bury-buffer ()
"Bury the current buffer until you find a non-'hidden' buffer."
(interactive)

(bury-buffer)
(let ((all-buffers (buffer-list))
      (done nil)
      (i 0))
  (while (and (not done) (<= i (length all-buffers)))
    (let ((buf (nth i all-buffers))
          (first-char ""))
      (setq first-char (substring (buffer-name buf) 0 1))
      (if (not (or
                (equal first-char "*")
                (equal first-char " ")))
          (progn
            (switch-to-buffer buf)
            (setq done t))
        (setq i (+ i 1))
        )))
  ))

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








