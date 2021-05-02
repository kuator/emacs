;; Add Melpa packages to Repos
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(add-to-list 'load-path (expand-file-name "~/.config/emacs/lib/"))

;; By default all packages should be installed from package manager as that's the usual path
;; This is equivalent to setting :ensure t on each call to use-package
(setq use-package-always-ensure t)

;; This stops emacs adding customised settings to init.el.
(setq custom-file (make-temp-file "emacs-custom"))

;; Don't display the help screen on startup.
(setq inhibit-startup-screen t)

;; Let's turn off unwanted window decoration.
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Make the yes or no prompts shorter.
(defalias 'yes-or-no-p 'y-or-n-p)

;; Enable Backup
(setq backup-directory-alist '(("." . "~/config/emacs/backup"))
  backup-by-copying t    ; Don't delink hardlinks
  version-control t      ; Use version numbers on backups
  delete-old-versions t  ; Automatically delete excess backups
  kept-new-versions 20   ; how many of the newest versions to keep
  kept-old-versions 5    ; and how many of the old
  )

;; I usually don't want tabs, if I do I can set this buffer-local to t. If I just want one tab then use C-q (quoted-insert) to insert as a literal.
(setq-default indent-tabs-mode nil)

(use-package evil
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  :config
  (define-key evil-insert-state-map (kbd "C-a") 'beginning-of-line)
  (define-key evil-insert-state-map (kbd "C-e") 'end-of-line)
  (define-key evil-insert-state-map (kbd "C-n") 'next-line)
  (define-key evil-insert-state-map (kbd "C-p") 'previous-line)
  (evil-mode 1)

  (use-package evil-leader
    :config
    (global-evil-leader-mode)
  )

  (use-package evil-commentary
    :after evil
    :diminish
    :config (evil-commentary-mode +1))

  (use-package evil-surround
    :config
    (global-evil-surround-mode))

  (use-package evil-indent-textobject)

  (use-package evil-textobj-line
    :init
    (setq evil-textobj-line-i-key "r")
    (setq evil-textobj-line-a-key "r")
  )

  (use-package evil-collection
  :config
  (evil-collection-init))

  (use-package targets
  :load-path "~/.config/emacs/lib/targets.el"
  :init
  (setq targets-user-text-objects '((pipe "|" nil separator)
                                    (paren "(" ")" pair :more-keys "b")
                                    ))
  :config
  (targets-setup t
                 :inside-key nil
                 :around-key nil
                 :remote-key nil))

  (use-package evil-textobj-entire
    :load-path "~/.config/emacs/lib/evil-textobj-entire.el")

  (use-package evil-unimpaired
    :load-path "~/.config/emacs/lib/evil-unimpaired.el"
    :config 
    (evil-unimpaired-mode))

  (use-package evil-little-word
    :load-path "~/.config/emacs/lib/evil-little-word.el")
)

(use-package xclip
    :config
    (xclip-mode 1))


(use-package ivy
  :ensure t
  :bind (("C-s" . swiper))
  :config
  (setq ivy-re-builders-alist '((t . ivy--regex-fuzzy)))
  (ivy-mode 1)
)

(use-package swiper)

(use-package counsel)

(use-package key-chord)
;; (Split-string evil-this-register
;;               split-string-default-separators
;;               t
;;               split-string-default-separators)

(use-package evil-goggles
  :config
  (setq evil-goggles-blocking-duration 0.100) ;; "before" overlays
  (setq evil-goggles-async-duration 0.100) ;; "after" overlays
  (setq evil-goggles-enable-substitute nil)
  (setq evil-goggles-enable-change nil)
  (setq evil-goggles-enable-delete nil)
  (evil-goggles-mode))

(setq key-chord-two-keys-delay 0.5)
(key-chord-define evil-insert-state-map "kj" 'evil-normal-state)
(key-chord-mode 1)

;; ummap
(global-unset-key (kbd "C-l"))

(require 'xclip)
(xclip-mode 1)


(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "M-c") 'evil-ex))

(evil-ex-define-cmd "up" 'evil-write)

(define-key evil-ex-completion-map "\C-j" 'exit-minibuffer)

;; https://paul-grillenberger.de/2019/07/21/quickfix-muting-search-highlights-in-emacs-evil-mode/
(define-key evil-normal-state-map (kbd "C-l") (progn 'redraw-frame 'evil-ex-nohighlight))

(define-key evil-window-map "\C-h" 'evil-window-left)
(define-key evil-window-map "\C-j" 'evil-window-down)
(define-key evil-window-map "\C-k" 'evil-window-up)
(define-key evil-window-map "\C-l" 'evil-window-right)

(define-key evil-insert-state-map (kbd "TAB") 'tab-to-tab-stop)

(global-display-line-numbers-mode)
(setq display-line-numbers-type 'relative)

(bind-key "C-h" 'delete-backward-char)

