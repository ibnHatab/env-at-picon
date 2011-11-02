
(require                        'define-key-wise)

(global-set-key-wise            '[(f1)];; 'switch-other-buffer		F1
                                "Makes the same operation as C-x b RET."
                                '(switch-to-buffer (other-buffer)))
(global-set-key-wise            '[(M-f1)]   'gse-bury-buffer)
(global-set-key-wise            '[(C-f1)]   'gse-unbury-buffer)

(global-set-key [(f2)]          'save-buffer) ;F2
(global-set-key [(f3)]          'find-file) ;F3
(global-set-key [(f4)]          'next-error) ;F4
(global-set-key [(C-f4)]        'previous-error) ;Ctrl+F4


(global-set-key [(f5)]          'speedbar-get-focus) ;F5
                                        ; f7
                                        ; f8
(global-set-key [(f9)]          'compile)     ;F9
(global-set-key [(f10)]         'grep)     ;F10
(global-set-key [(f11)]         'nuke-trailing-whitespace) ;F11
(global-set-key [(f12)]         'kill-this-buffer) ;F12
(global-set-key [(C-f12)]       'server-edit) ;F12

;; cscope
(define-key global-map [(control f2)] 'cscope-find-global-definition-no-prompting)  ;; f2 Definition
(define-key global-map [(control f3)] 'cscope-find-this-symbol)                     ;; f3 Symbols
(define-key global-map [(control f4)] 'cscope-find-functions-calling-this-function) ;; f4 References
(define-key global-map [(control f5)] 'cscope-pop-mark)                             ;; f5 Pop mark
(define-key global-map [(control f6)] 'cscope-display-buffer)                       ;; f6 display buffer
(define-key global-map [(control f7)] 'cscope-prev-symbol)                          ;; f7 prev sym
(define-key global-map [(control f8)] 'cscope-next-symbol)                          ;; f8 next sym
(define-key global-map [(control f9)] 'cscope-set-initial-directory)                ;; f9 set initial dir

;; Compile mode
(global-set-key [?\C-c ?b]      'compile)
(global-set-key [?\C-c ?n]      'next-error)
(global-set-key [?\C-c ?p]      'previous-error)

;; Fast movements
(global-set-key [M-right]       'forward-word)
(global-set-key [M-left]        'backward-word)
(global-set-key [C-right]       'forward-word)
(global-set-key [C-left]        'backward-word)
(global-set-key [C-M-down]      'vjo-forward-current-word-keep-offset)
(global-set-key [C-M-up]        'vjo-backward-current-word-keep-offset)
(global-set-key [?\C-\.]        'goto-line)

(global-set-key [C-delete]      'kill-word)
(global-set-key [ESC-backspace] 'backward-kill-word)
(global-set-key [C-backspace]   'backward-kill-word)

;; Move between visible windows
(global-set-key [(C-tab)]	'other-window )
(global-set-key [(C-S-tab)]	'previous-multiframe-window )
(global-set-key [(s-tab)]	'complete-tag )

(global-set-key [s-left]  'windmove-left)         ; move to left windnow
(global-set-key [s-right] 'windmove-right)        ; move to right window
(global-set-key [s-up]    'windmove-up)           ; move to upper window
(global-set-key [s-down]  'windmove-down)         ; move to downer window

;; Undo/Redo
(global-set-key [M-backspace]    'undo)
(global-set-key [M-return]
                '(lambda () (interactive)
                   (setq last-command 'undo-toggle) ; a hack.
                   (advertised-undo)
                   (message "Undo Toggle")
                   ))

(global-set-key "\C-cz"           'comment-region)
(global-set-key "\C-ca"           'uncomment-region)
(global-set-key "\C-z"            'undo)

;;MOUSE
(global-set-key [(mouse-5)]            'scroll-up-half)
(global-set-key [(mouse-4)]            'scroll-down-half)

(define-key global-map '[C-S-mouse-1]  'copy-to-register)
(define-key global-map '[C-S-mouse-2]  'insert-register)
(define-key global-map '[C-S-mouse-3]  'view-register)

;; (global-set-key "%" 'goto-match-paren) use C-M-f,b,n,p

;; Link to X clipboard
(global-set-key [(shift delete)]	'clipboard-kill-region)
(global-set-key [(control insert)]	'clipboard-kill-ring-save)
(global-set-key [(shift insert)]	'clipboard-yank)

;; Move line/code region with M-S-Up/Down

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

(global-set-key [M-S-up]   'move-text-up)
(global-set-key [M-S-down] 'move-text-down)
