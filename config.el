;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;(setq display-line-numbers-type t)
(setq display-line-numbers-type 'nil)

(setq user-full-name ""
      user-mail-address "")

(map! (:leader
       (:prefix "b"
        :desc  "tangle buffer"         :nv "t" #'org-babel-tangle)))

(map! (:leader
       (:prefix ("d" . "doom")
        :desc   "reload doom"           :nv "r" #'doom/reload)))

(setq server-socket-dir "~/.emacs.d/server/server")
(require 'server)
;; Start a server if (server-running-p) does not return t (e.g. if it
;; returns nil or :other)
(or (eq (server-running-p) t)
    (server-start))

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important one:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:

;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-vibrant)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!

(setq org-directory "~/org/")
;; For org linking
(setq org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id)

(after! org (org-add-link-type "onenote" 'org-onenote-open) (
  defun org-onenote-open (link) "Open the OneNote item identified by the unique OneNote URL."
    (w32-shell-execute "open" "C:\\Program Files (x86)\\Microsoft Office\\root\\Office16\\ONENOTE.exe" (concat "/hyperlink " "onenote:" (shell-quote-argument link))
)))

(map! (:map evil-normal-state-map
       "C-c a" #'org-agenda
       "C-c o" (lambda () (interactive)(find-file "~/org/org.org"))
       "C-c j" #'org-journal-open-current-journal-file))

(after! org
  (setq org-todo-keywords
        '((sequence
           "TODO(t)"  ; A task that needs doing & is ready to do
           "PROJ(p)"  ; A project, which usually contains other tasks
           "STRT(s!)"  ; A task that is in progress
           "WAIT(w@/!)"  ; Something external is holding up this task
           "HOLD(h@/!)"  ; This task is paused/on hold because of me
           "|"
           "DONE(d!)"  ; Task successfully completed
           "KILL(k@)") ; Task was cancelled, aborted or is no longer applicable
          (sequence
           "[ ](T)"   ; A task that needs doing
           "[-](S)"   ; Task is in progress
           "[?](W)"   ; Task is being held up or paused
           "|"
           "[X](D)"))); Task was completed
  (setq org-capture-templates
        '(("t" "Todo" entry (file+headline "~/org/org.org" "Todo")
           "* TODO %?\n %U")
          ("r" "SN Request" entry (file+headline "~/org/org.org" "ServiceNow")
           "* TODO %?\n %U\n [[][ServiceNow]]")
          ("a" "Scrum" entry (file+headline "~/org/org.org" "Scrum")
           "* TODO %?\n %U")
          ("s" "Story Task" entry (file+headline "~/org/org.org" "Stories")
           "* TODO %?\n %U\n [[][Jira]]")
          ("i" "Inbox" entry (file+headline "~/org/org.org" "Inbox")
           "* TODO %?\n %U")
          ))
  ;; https://blog.aaronbieber.com/2016/09/24/an-agenda-for-life-with-org-mode.html
  (setq org-agenda-custom-commands
        '(
          ("v" "scrum" tags-todo "scrum+TODO=\"TODO\"")
          ("c" "Simple agenda view"
           ((agenda "")
            (alltodo "")))
          ))
  )

(setq org-log-into-drawer 't)

(setq org-tag-alist '((:startgrouptag)
                      ("campus")
                      (:grouptags)
                      ("barcode_ui")
                      ("barcode_services")
                      (:endgrouptag)
                      ("scrum")
                      ("serviceNow")
                      ("stories")
                      ("GIDB")))

(setq org-journal-file-type 'weekly)

(add-hook 'typescript-mode 'display-fill-column-indicator-mode)

(map! (:leader
       (:prefix "g"
        :desc   "magit diff"            :nv "d" #'magit-diff)))

(projectile-add-known-project "C:/Users/vincli/AppData/Roaming/org")
(projectile-add-known-project "C:/Users/vincli/AppData/Roaming/.doom.d")
;; sometimes glitches out, run (projectile-discover-projects-in-search-path)
;; to reload projects
(setq projectile-project-search-path '("C:/Users/vincli/Documents/work"))

(after! persp-mode
  (setq persp-emacsclient-init-frame-behaviour-override "main"))

(map! (:leader
       (:prefix "o"
        :desc   "Treemacs"              :nv "t" #'treemacs
        :desc   "Project eshell"        :nv "e" #'switch-to-project-eshell-else-create)))

;; Simple function to create project eshell if it exists, else switch to it
(defun switch-to-project-eshell-else-create ()
  (interactive)
  (let ((eshellBuffer (concat "*eshell " (projectile-project-name) "*")))
     (if (get-buffer-window eshellBuffer 'visible)
        (if (string= (buffer-name) eshellBuffer)
            (print '"already in eshell buffer")
          (switch-to-buffer-other-frame eshellBuffer))
        (progn (split-window)
               (command-execute 'projectile-run-eshell)
               (evil-window-move-very-bottom)
               (evil-window-set-height 10)
               ))))

(map! (:leader
       (:prefix ("l" . "lsp")
        :desc   "Run lsp"               :nv "l" #'lsp
        :desc   "Format Buffer"         :nv "f" #'lsp-format-buffer)))

(map! ;; Maps C-w C-; to hydra window nav for easier window resizing
       (:map evil-window-map
       "C-;" #'+hydra/window-nav/body)
      ;; Map csg in evil normal state map to project search
      (:map evil-normal-state-map
       "C-S-f" #'+ivy/project-search))



;; Enabling Company defaults
(setq company-idle-delay 0.1
      company-minimum-prefix-length 2)
