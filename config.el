(add-to-list 'default-frame-alist '(fullscreen . maximized))

;(setq display-line-numbers-type t)
(setq display-line-numbers-type 'nil)

(setq user-full-name ""
      user-mail-address "")

;; (defadvice text-scale-increase (around all-buffers (arg) activate)
;;   (dolist (buffer (buffer-list))
;;     (with-current-buffer buffer
;;       ad-do-it)))

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
       "C-c a" #'org-agenda))

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

;(default-text-scale-mode 't)
