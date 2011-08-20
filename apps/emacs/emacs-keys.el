
(require 'define-key-wise)
;;(windmove-default-keybindings)
(global-set-key "\C-z"            'undo)

(global-set-key "\M-n"          'forward-paragraph-nomark)
(global-set-key "\M-p"          'backward-paragraph-nomark)

(global-set-key-wise '[(f1)];; 'switch-other-buffer		F1
                     "Makes the same operation as C-x b RET."
                     '(switch-to-buffer (other-buffer)))

(global-set-key-wise '[(A-f1)]     'gse-bury-buffer)
(global-set-key-wise '[(C-f1)]   'gse-unbury-buffer)

(global-set-key [(f2)]          'save-buffer) ;F2
(global-set-key [(f3)]          'find-file) ;F3
(global-set-key [(f5)]          'speedbar-get-focus) ;F4


(global-set-key [(f7)]          'start-kbd-macro)
(global-set-key [(C-f7)]        'end-kbd-macro)
(global-set-key [(f8)]          'call-last-kbd-macro)
(global-set-key [(f9)]          'compile)  ;F9
(global-set-key [(f10)]         'grep)     ;F10
(global-set-key [(C-f9)]        'run)
(global-set-key [(f11)]		'nuke-trailing-whitespace) ;F11
(global-set-key [(f12)]		'kill-this-buffer) ;F12
(global-set-key [(C-f12)]	'server-edit) ;F12

(global-set-key [(f6)]		'hs-hide-block)
(global-set-key [(C-f6)]	'hs-show-block)
(global-set-key [C-M-down]	'vjo-forward-current-word-keep-offset)
(global-set-key [C-M-up]	'vjo-backward-current-word-keep-offset)


(global-set-key [M-right]        'forward-word)
(global-set-key [M-left]         'backward-word)
(global-set-key [C-right]       'forward-word)
(global-set-key [C-left]        'backward-word)

(global-set-key [C-delete]      'kill-word)
(global-set-key [ESC-backspace]  `backward-kill-word)
(global-set-key [C-backspace]   'backward-kill-word)

(global-set-key [(C-tab)]	'other-window )
(global-set-key [(C-S-tab)]	'previous-multiframe-window )

(global-set-key [s-left] 'windmove-left)          ; move to left windnow
(global-set-key [s-right] 'windmove-right)        ; move to right window
(global-set-key [s-up] 'windmove-up)              ; move to upper window
(global-set-key [s-down] 'windmove-down)          ; move to downer window


(global-set-key [M-backspace]    'undo)
(global-set-key [M-return]
                '(lambda () (interactive)
                   (setq last-command 'undo-toggle) ; a hack.
                   (advertised-undo)
                   (message "Undo Toggle")
                   ))

(global-set-key [?\C-\.]          'goto-line)
(global-set-key "\C-cz"           'comment-region)
(global-set-key "\C-ca"           'uncomment-region)
(global-set-key "\C-z"            'undo)

                                        ;MOUSE
(global-set-key [(mouse-5)]            'scroll-up-half)
(global-set-key [(mouse-4)]            'scroll-down-half)

(define-key global-map '[C-S-mouse-1]  'copy-to-register)
(define-key global-map '[C-S-mouse-2]  'insert-register)
(define-key global-map '[C-S-mouse-3]  'view-register)

(global-set-key "%" 'goto-match-paren)

(global-set-key [(shift delete)]	'clipboard-kill-region)
(global-set-key [(control insert)]	'clipboard-kill-ring-save)
(global-set-key [(shift insert)]	'clipboard-yank)
