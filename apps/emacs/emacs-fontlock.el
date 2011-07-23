
(global-font-lock-mode t)

(require 'font-lock)
(add-hook 'find-file-hooks 'turn-on-font-lock)
(defconst font-lock-auto-fontify t)

(defconst c-font-lock t)                ;enable syntax coloring
(defconst c++-font-lock t)
(defconst java-font-lock t)
(defconst sgml-font-lock t)
