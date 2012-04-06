;; All my major and minor mode loading and configuration

;; IDO mode is awesome
(ido-mode t)
(setq
 ido-enable-prefix nil
 ido-enable-flex-matching t
 ido-create-new-buffer 'always
 ido-use-filename-at-point nil
 ido-max-prospects 10)

;; force wrap magit commit messages
(add-hook 'magit-log-edit-mode-hook 'bw-turn-on-auto-fill)
(add-hook 'magit-log-edit-mode-hook 'magit-fill-column)

;; TODO: make all these modes a list and operate on those
(add-hook 'magit-mode-hook 'local-hl-line-mode-off)
(add-hook 'magit-log-edit-mode-hook 'local-hl-line-mode-off)

;; turn off hl-line-mode for compilation mode
(add-hook 'compilation-mode-hook 'local-hl-line-mode-off)
;; turn off hl-line-mode for shells
(add-hook 'term-mode-hook 'local-hl-line-mode-off)

;; Textmate mode is on for everything
(textmate-mode)

;; haskell mode, loaded via Elpa
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-hook 'inferior-haskell-mode-hook 'local-hl-line-mode-off)

;; JS2 mode, not espresso
(setq
 js2-highlight-level 3
 js2-basic-offset 4
 js2-consistent-level-indent-inner-bracket-p t
 js2-pretty-multiline-decl-indentation-p t)
;;(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; Jinja mode is a bit crap, really
(require 'jinja)
(add-to-list 'auto-mode-alist '("\\.jinja$" . jinja-mode))

;; JSON files
(add-to-list 'auto-mode-alist '("\\.json$" . json-mode))

(defun my-html-mode-hook ()
  (setq tab-width 4)
  (auto-fill-mode 0)
  (define-key html-mode-map (kbd "<tab>") 'my-insert-tab)
  (define-key html-mode-map (kbd "C->") 'sgml-close-tag))

;; just insert tabs
(defun my-insert-tab (&optional arg)
  (interactive "P")
  (insert-tab arg))

(add-hook 'html-mode-hook 'my-html-mode-hook)

;; load yaml files correctly
;; yaml-mode doesn't auto-load for some reason
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.ya?ml$" . yaml-mode))

;; Restructured text
(require 'rst)
(add-to-list 'auto-mode-alist '("\\.rst$" . rst-mode))
(add-hook 'rst-mode-hook 'bw-turn-on-auto-fill)
(add-hook 'rst-mode-hook 'magit-fill-column)

;; kill stupid heading faces
(set-face-background 'rst-level-1-face nil)
(set-face-background 'rst-level-2-face nil)

;; Random missing file types
(add-to-list 'auto-mode-alist '("[vV]agrantfile$" . ruby-mode))

;; Puppet manifests
(add-to-list 'auto-mode-alist '("\\.pp$" . puppet-mode))

;; ansi-term stuff
;; force ansi-term to be utf-8 after it launches
(defadvice ansi-term
  (after advise-ansi-term-coding-system)
  (set-buffer-process-coding-system 'utf-8-unix 'utf-8-unix))
(ad-activate 'ansi-term)

(when (require 'ansi-color nil t)
  (autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
  (add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on))

;; since I use Magit, disable vc-mode for Git
(delete 'Git vc-handled-backends)

;; Saveplace
;;   - places cursor in the last place you edited file
(require 'saveplace)
(setq-default save-place t)
;; Keep places in the load path
(setq save-place-file (concat tmp-local-dir "/emacs-places"))

;; yasnippet
(require 'yasnippet)
(setq yas/root-directory "~/Dropbox/.emacs/yasnippets")
(yas/load-directory yas/root-directory)
(yas/initialize)

;; setup tramp mode
;; Tramp mode: allow me to SSH to hosts and edit as sudo like:
;;   C-x C-f /sudo:example.com:/etc/something-owned-by-root
;; from: http://www.gnu.org/software/tramp/#Multi_002dhops
(require 'tramp)
(setq tramp-default-method "ssh")
(add-to-list 'tramp-default-proxies-alist
             '(nil "\\`root\\'" "/ssh:%h:"))
(add-to-list 'tramp-default-proxies-alist
             '((regexp-quote (system-name)) nil nil))

;; Clojure mode, installed via Elpa
(add-hook 'clojure-mode-hook 'turn-on-paredit)
(add-hook 'clojure-mode-hook 'bw-clojure-repl-program)
(add-hook 'slime-repl-mode-hook 'bw-clojure-slime-repl-font-lock)
(add-hook 'slime-repl-mode-hook 'local-hl-line-mode-off)
(add-hook 'slime-repl-mode-hook 'turn-on-paredit)

;; load Flymake cursor
(when (load "flymake" t)
  (require 'flymake-cursor))

;; new python-mode IDE
(setq python-mode-path (concat vendor-dotfiles-dir "/python-mode"))
(add-to-list 'load-path python-mode-path)
(setq py-install-directory python-mode-path)
(require 'python-mode)

;; Helm instead of anything
(add-to-list 'load-path (concat vendor-dotfiles-dir "/helm"))
(require 'helm-config)

;; js2-mode in case I need it
(add-to-list 'load-path (concat vendor-dotfiles-dir "/js2-mode"))
(require 'js2-mode)

;; load erlang
(defun bw-load-post-load-files ()
  "Loads some files that depend on custom.el being loaded"
  (load "modes/erlang-mode.el")
  (load "modes/js-mode.el")
  (load "modes/erc-mode.el"))

(add-hook 'bw-after-custom-load-hook 'bw-load-post-load-files)

;; markdown
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown$" . markdown-mode))

;; PHP
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))

;; iced coffee script
(add-to-list 'auto-mode-alist '("\\.iced$" . coffee-mode))

(defun coffee-custom ()
  "coffee-mode-hook"

  ;; CoffeeScript uses two spaces.
  (make-local-variable 'tab-width)
  (set 'tab-width 2)

  ;; Compile '.coffee' files on every save
  (and (file-exists-p (buffer-file-name))
       (file-exists-p (coffee-compiled-file-name))
       (coffee-cos-mode t)))

(add-hook 'coffee-mode-hook 'coffee-custom)

;; emacs lisp
(add-hook 'emacs-lisp-mode-hook 'turn-on-paredit)

;; org-mode
(org-babel-do-load-languages
 'org-babel-load-languages
 ;; load emacs-lisp natively
 '((emacs-lisp . t)))

;; edit inline code blocks natively
(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)
