;; This is an operating system configuration
;; made for a docker container with emacs.

(use-modules (gnu)
 (gnu packages bash)
 (guix profiles)
 (guix packages))
(use-service-modules ssh)

(operating-system
  (locale "en_US.utf8")
  (locale-libcs (list (canonical-package glibc)))
  (timezone "America/Los_Angeles")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "emacscontainer")
  (users (cons* (user-account
                 (name "emacsuser")
                 (comment "Emacs User")
                 (group "users")
                 (home-directory "/home/emacsuser")
                 (supplementary-groups
                  '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))
  (packages
   (append
    (map specification->package
         '("tar"
           "libvterm"
           "sqlite"
           "gcc-toolchain"
           "coreutils"
           "rubber"
           "automake"
           "make"
           "autoconf"
           "libpng"
           "zlib"
           "shadow"
           "emacs-guix"
           "emacs-next"
           "emacs-geiser"
           "git"
           "grep"
           "ripgrep"
           "fd"
           "cmake"
           "direnv"
           "shellcheck"
           "poppler"
           "imagemagick"
           "guix"
           "gnupg"
           "curl"
           "w3m"
           "wget"
           "gnuplot"
           "ghc-pandoc"
           "ghc-pandoc-citeproc"
           "emacs-pdf-tools"
           "texlive"
           "emacs-graphviz-dot-mode"
           "python"
           "python-black"
           "python-pyflakes"
           "python-isort"
           "python-pytest"
           "python-wrapper"
           "nss-certs"))
    %base-packages))
  (services
   (append
    (list
	 ;; Enable #!/bin/bash shebang.
	 (service special-files-service-type
		      `(("/bin/bash" ,(file-append (canonical-package bash)))))
     (service openssh-service-type
              (openssh-configuration
               (allow-empty-passwords? #t))))
    %base-services))
  (bootloader
   (bootloader-configuration
    (bootloader grub-bootloader)
    (target "/dev/sda")
    (keyboard-layout keyboard-layout)))
  (file-systems
   (cons* (file-system
            (mount-point "/")
            (device
             (uuid "ca3c2ded-fc9c-4e20-a647-2c34bb5b0187"
                   'ext4))
            (type "ext4"))
          %base-file-systems))
  (sudoers-file (plain-file "sudoers" "\
root ALL=(ALL) ALL
%wheel ALL=(ALL) ALL
Defaults !env_reset,!env_delete\n")))
