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
  (define-key evil-insert-state-map (kbd "C-y") 'nil)
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

(use-package spacemacs-theme
  :defer t
  :init (load-theme 'spacemacs-dark t))

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

(use-package company
  :ensure t
  :defer t
  :init (global-company-mode)
  :config
  (progn
    ;; Use Company for completion
    (bind-key [remap completion-at-point] #'company-complete company-mode-map)

    (setq company-tooltip-align-annotations t
          ;; Easy navigation to candidates with M-<n>
          company-show-numbers t)
    (setq company-dabbrev-downcase nil))
  :diminish company-mode)


(use-package lsp-mode
  :config
  (add-hook 'c++-mode-hook #'lsp)
  :custom
  (lsp-enable-snippet t))


(use-package company
  :config
  (setq company-idle-delay 0.3)

  (global-company-mode 1)

  (global-set-key (kbd "C-<tab>") 'company-complete))
  (global-unset-key (kbd "C-y"))
  (define-key company-active-map (kbd "<C-y>") 'company-complete-selection)


(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      company-idle-delay 0.0
      company-minimum-prefix-length 1
      lsp-idle-delay 0.1)  ;; clangd is fast



(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))  ; or lsp-deferred


(defun setup-tide-mode ()
  "Set up Tide mode."
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save-mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

(use-package tide
  :ensure t
  :config
  (setq company-tooltip-align-annotations t)
  (add-hook 'before-save-hook 'tide-format-before-save)
  ;;    (add-hook 'js2-mode-hook #'setup-tide-mode)
  (add-hook 'js-mode-hook #'setup-tide-mode)
  (add-hook 'typescript-mode-hook #'setup-tide-mode))


(use-package yasnippet                  ; Snippets
  :ensure t
  :custom
  (setq yas-inhibit-overlay-modification-protection t)
  :config
  ; (validate-setq
  ;  yas-verbosity 1                      ; No need to be so verbose
  ;  yas-wrap-around-region t)

  ; (with-eval-after-load 'yasnippet
  ;   (validate-setq yas-snippet-dirs '(yasnippet-snippets-dir)))

  (yas-reload-all)
  (yas-global-mode))

(use-package yasnippet-snippets         ; Collection of snippets
  :ensure t)
















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

; (bind-key "C-h" 'delete-backward-char)
(keyboard-translate ?\C-h ?\C-?)
