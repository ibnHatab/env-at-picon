
(setq-default indent-tabs-mode nil)


(global-set-key (kbd "C-x \\")      'align-regexp)

(global-set-key (kbd "C-x C-b")     'ido-switch-buffer)
(global-set-key (kbd "C-x B")       'ibuffer)
(global-set-key [C-escape]          'helm-buffers-list)

(define-key global-map (kbd "C-+")  'text-scale-increase)
(define-key global-map (kbd "C--")  'text-scale-decrease)

(global-set-key (kbd "s-s")         'neotree-toggle)
(global-set-key (kbd "s-a")         'neotree-find)

(require                            'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->")         'mc/mark-next-like-this)
(global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)

;; Completion
(global-set-key "\M-,"              'pop-tag-mark)
(global-set-key "\M- "              'hippie-expand)

(setq completion-ignore-case nil
      pcomplete-ignore-case nil
      read-file-name-completion-ignore-case t)

(global-set-key "\M-\t"   'company-complete)

(defun switch-to-buffer-other-buffer ()
  ""
  (interactive)
  (switch-to-buffer (other-buffer)))

(require                        'cycle-buffer)
(global-set-key [(C-f1)]        'cycle-buffer)
(global-set-key [(S-f1)]        'cycle-buffer-backward)
(global-set-key [(M-f1)]        'ido-switch-buffer)
(global-set-key [(f1)]          'switch-to-buffer-other-buffer)
(global-set-key [(f2)]          'save-buffer)
(global-set-key [(f3)]          'find-file)

(global-set-key [(f8)]          'projectile-command-map)

(global-set-key [(f10)]         'ack)
(global-set-key [(C-f10)]       'grep)
(global-set-key [(M-f10)]       'search-all-buffers)

(global-set-key [(f11)]         'nuke-trailing-whitespace)
(global-set-key [(C-f11)]       'cycle-my-theme)
(global-set-key [(f12)]         'kill-this-buffer)
(global-set-key [(C-f12)]       'server-edit)

;; Fast movements
(global-set-key [C-right]       'forward-word)
(global-set-key [C-left]        'backward-word)
(global-set-key [?\C-\.]        'goto-line)
(global-set-key [C-delete]      'kill-word)
(global-set-key [ESC-backspace] 'backward-kill-word)
(global-set-key [C-backspace]   'backward-kille-word)
(global-set-key "\C-\\"         'ace-jump-mode)

(defun backward-delete-word (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (backward-word arg) (point))))
(define-key minibuffer-local-map [C-backspace] 'backward-delete-word)

;; duplicate line
(global-set-key "\C-cd" "\C-a\C- \C-n\M-w\C-y\C-p\C-a")

;; Windows Cycling
(defun windmove-up-cycle()
  (interactive)
  (condition-case nil (windmove-up)
    (error (condition-case nil (windmove-down)
	     (error (condition-case nil (windmove-right)
                      (error (condition-case nil (windmove-left) (error (windmove-up))))))))))
(defun windmove-down-cycle()
  (interactive)
  (condition-case nil (windmove-down)
    (error (condition-case nil (windmove-up)
	     (error (condition-case nil (windmove-left)
                      (error (condition-case nil (windmove-right) (error (windmove-down))))))))))
(defun windmove-right-cycle()
  (interactive)
  (condition-case nil (windmove-right)
    (error (condition-case nil (windmove-left)
	     (error (condition-case nil (windmove-up)
                      (error (condition-case nil (windmove-down) (error (windmove-right))))))))))
(defun windmove-left-cycle()
  (interactive)
  (condition-case nil (windmove-left)
    (error (condition-case nil (windmove-right)
	     (error (condition-case nil (windmove-down)
                      (error (condition-case nil (windmove-up) (error (windmove-left))))))))))


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


;; ORG
;; (global-set-key "\C-cl" 'org-store-link)
;; (global-set-key "\C-cc" 'org-capture)
;; (global-set-key "\C-ca" 'org-agenda)
;; (global-set-key "\C-cf" 'cfw:open-org-calendar)

(global-set-key (kbd "<f9> <f9>")  'org-cycle-agenda-files)
(global-set-key (kbd "<f9> c")     'cfw:open-org-calendar)
(global-set-key (kbd "<f9> w")     'widen)
(global-set-key (kbd "<f9> v")     'visible-mode)
(global-set-key (kbd "<f9> r")     'org-refile)
(global-set-key (kbd "<f9> m")     'org-manage)
(global-set-key (kbd "<f9> j")     'vki:open-default-notes-file)
(global-set-key (kbd "<f9> S")     'org-todo)
(global-set-key (kbd "<f9> d")     'org-deadline)
(global-set-key (kbd "<f9> s")     'org-schedule)
(global-set-key (kbd "<f9> t")     'org-time-stamp-inactive)
(global-set-key (kbd "<f9> T")     'org-toggle-timestamp-type)
(global-set-key (kbd "<f9> SPC")   'org-clock-in)
(global-set-key (kbd "<f9> s-SPC") 'org-clock-goto)
(global-set-key (kbd "<f9> p")     'org-taskjuggler-export-and-process)

(global-set-key (kbd "M-<f9>") 'org-toggle-inline-images)

(defun vki:open-default-notes-file ()
 "Open a file containing refil collection"
 (interactive)
 (find-file org-default-notes-file))

(require 'bm)
(global-set-key (kbd "<C-f2>")   'bm-toggle)
(global-set-key (kbd "<M-f2>")   'bm-next)
(global-set-key (kbd "<S-f2>")   'bm-previous)
(global-set-key (kbd "<S-M-f2>") 'bm-show-all)

(global-set-key (kbd "<left-fringe> <mouse-5>") 'bm-next-mouse)
(global-set-key (kbd "<left-fringe> <mouse-4>") 'bm-previous-mouse)
(global-set-key (kbd "<left-fringe> <mouse-1>") 'bm-toggle-mouse)

;; Global flycheck
(global-set-key "\C-c\C-p" 'flycheck-previous-error)
(global-set-key "\C-c\C-n" 'flycheck-next-error)
