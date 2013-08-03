
;; replace buffer-menu with ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)

(global-set-key "\M- " 'hippie-expand)

;; Align your code in a pretty way.
(global-set-key (kbd "C-x \\") 'align-regexp)

;; Perform general cleanup.
(global-set-key (kbd "C-c n") 'cleanup-buffer)

;; Font size
(define-key global-map (kbd "C-+") 'text-scale-increase)
(define-key global-map (kbd "C--") 'text-scale-decrease)


(require 'multiple-cursors)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; You can scroll the screen to center on each cursor with `C-v` and `M-v`.
(global-unset-key (kbd "M-<down-mouse-1>"))
(global-set-key (kbd "M-<mouse-1>") 'mc/add-cursor-on-click)

(require                        'define-key-wise)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Completion
(setq completion-ignore-case t
      pcomplete-ignore-case t
      read-file-name-completion-ignore-case t)


;; replace by bookmark system
(global-set-key-wise            '[(f1)];; 'switch-other-buffer		F1
                                "Makes the same operation as C-x b RET."
                                '(switch-to-buffer (other-buffer)))
(global-set-key-wise            '[(M-f1)]   'gse-bury-buffer)
(global-set-key-wise            '[(C-f1)]   'gse-unbury-buffer)
(global-set-key-wise            '[(C-tab)]   'other-window)

(global-set-key [(f2)]          'save-buffer)		    
(global-set-key [(f3)]          'find-file)		    


;;(global-set-key [(f4)]          'iswitchb-buffer)	    ;F4
(global-set-key [(f4)]          'ido-switch-buffer)	    ;F4
(global-set-key [(f5)]          'previous-error)	   
;;(global-set-key [(f5)]          'speedbar-get-focus)	    ;F5
							    ;F7
					                    ;F8
;; org hijack(global-set-key [(f9)]          'compile)		    ;F9
(global-set-key [(f10)]         'grep)			    ;F10
(global-set-key [(C-f10)]       'nuke-trailing-whitespace)  ;F10
(global-set-key [(f12)]         'kill-this-buffer)	    ;F12
(global-set-key [(C-f12)]       'server-edit)		    ;F12

;; bookmarks                                                
(global-set-key [(control f11)]       'af-bookmark-toggle )
(global-set-key [f11]                 'af-bookmark-cycle-forward )
(global-set-key [(shift f11)]         'af-bookmark-cycle-reverse )
(global-set-key [(control shift f11)] 'af-bookmark-clear-all )
(global-set-key [(M-f11)]             'bookmark-bmenu-list )

;; Compile mode
(global-set-key "\C-cb" 'compile)

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

(defun backward-delete-word (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (backward-word arg) (point))))
(define-key minibuffer-local-map [C-backspace] 'backward-delete-word)

;; Move between visible windows
(global-set-key [(C-tab)]	'other-window )
(global-set-key [(C-S-tab)]	'previous-multiframe-window )
(global-set-key [(s-tab)]	'complete-tag )

;; Windows Cycling
(defun windmove-up-cycle()
  (interactive)
  (condition-case nil (windmove-up)
    (error (condition-case nil (windmove-down)
	     (error (condition-case nil (windmove-right) (error (condition-case nil (windmove-left) (error (windmove-up))))))))))

(defun windmove-down-cycle()
  (interactive)
  (condition-case nil (windmove-down)
    (error (condition-case nil (windmove-up)
	     (error (condition-case nil (windmove-left) (error (condition-case nil (windmove-right) (error (windmove-down))))))))))

(defun windmove-right-cycle()
  (interactive)
  (condition-case nil (windmove-right)
    (error (condition-case nil (windmove-left)
	     (error (condition-case nil (windmove-up) (error (condition-case nil (windmove-down) (error (windmove-right))))))))))

(defun windmove-left-cycle()
  (interactive)
  (condition-case nil (windmove-left)
    (error (condition-case nil (windmove-right)
	     (error (condition-case nil (windmove-down) (error (condition-case nil (windmove-up) (error (windmove-left))))))))))


(global-set-key [s-left]  'windmove-left-cycle)         ; move to left windnow
(global-set-key [s-right] 'windmove-right-cycle)        ; move to right window
(global-set-key [s-up]    'windmove-up-cycle)           ; move to upper window
(global-set-key [s-down]  'windmove-down-cycle)         ; move to downer window

(global-set-key [s-S-up]   'delete-other-windows-vertically)
(global-set-key [s-S-down] 'delete-other-windows-vertically)

(require 'buffer-move)
(global-set-key [M-s-up]     'buf-move-up)
(global-set-key [M-s-down]   'buf-move-down)
(global-set-key [M-s-left]   'buf-move-left)
(global-set-key [M-s-right]  'buf-move-right)

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
(global-set-key [M-S-up]   'move-text-up)
(global-set-key [M-S-down] 'move-text-down)

;; Camel / Uncamel cases
(global-set-key "\M-_" 'mo-toggle-identifier-naming-style)

(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)

(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)

;; Backspace Key
(global-set-key (kbd "C-h") 'delete-backward-char)

;; ORG
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(global-set-key "\C-cf" 'cfw:open-org-calendar)


(global-set-key (kbd "<f9> <f9>") 'org-cycle-agenda-files)
(global-set-key (kbd "<f9> c") 'cfw:open-org-calendar)
(global-set-key (kbd "<f9> w") 'widen)
(global-set-key (kbd "<f9> v") 'visible-mode)
(global-set-key (kbd "<f9> r") 'org-refile)
(global-set-key (kbd "<f9> m") 'org-manage)
(global-set-key (kbd "<f9> j") 'vki:open-default-notes-file)

(global-set-key (kbd "<f9> s") 'org-todo)
(global-set-key (kbd "<f9> d") 'org-deadline)
(global-set-key (kbd "<f9> t") 'org-time-stamp-inactive)
(global-set-key (kbd "<f9> T") 'org-toggle-timestamp-type)
(global-set-key (kbd "<f9> SPC") 'org-clock-in)
(global-set-key (kbd "<f9> s-SPC") 'org-clock-goto)

(global-set-key (kbd "M-<f9>") 'org-toggle-inline-images)

(defun vki:open-default-notes-file ()
 "Open a file containing refil collection"
 (interactive)
 (find-file org-default-notes-file))

(require 'breadcrumb)
(global-set-key [(control f2)]          'bc-set)
(global-set-key [(f2)]                  'bc-previous)
(global-set-key [(shift f2)]            'bc-next)
(global-set-key [(meta f2)]             'bc-list)