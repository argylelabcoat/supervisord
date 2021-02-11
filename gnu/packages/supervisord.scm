(define-module (gnu packages supervisord)
    #:use-module (ice-9 match)
    #:use-module ((guix licenses) #:select (expat))
    #:use-module ((guix build utils) )
    #:use-module (guix packages)
    #:use-module (guix derivations)
    #:use-module (guix download)
    #:use-module (guix git-download)
    #:use-module (guix utils)
    #:use-module (guix build-system gnu)
    #:use-module (gnu packages)
    #:use-module (gnu packages golang) )

 
(define-syntax go-args
  (syntax-rules ()
    ((go-args targetname flags)
     `(
            #:modules ((guix build gnu-build-system)
                  (guix build utils)
                  (ice-9 match))
            #:make-flags (list 
              (string-append "GOARCH=",
                (match 
                  (or 
                    (%current-target-system)
                    (%current-system))
                  ("x86_64-linux-gnueabi"  "amd64")
                  ("i686-linux-gnueabi"    "386")
                  ("arm-linux-gnueabihf" "arm")
                  ("arm64-linux-gnueabi" "arm64")
                  (_               "amd64")))
              (string-append "GOOS=",
                (let ((target (or 
                    (%current-target-system)
                    (%current-system)))) 
                    (if (not (eq? #f target)) (cadr (string-split target #\-)) "")))
              (string-append "ADDLFLAGS=" flags)
               targetname)
            #:phases (modify-phases %standard-phases 
            (add-after 'set-paths 'add-prefix (lambda _
              (setenv "PREFIX" (assoc-ref %outputs "out"))
              (setenv "CC" ,(cc-for-target))
              (setenv "GOCACHE" "/tmp/go-cache") ))
            (delete 'configure)
            (delete 'check)
            (delete 'install) )) )))


(define-public ochinchina-supervisor
    (package
        (name "ochinchina-supervisor")
        (version "master")
        (source (dirname (dirname (dirname (current-filename) ))))
        (build-system gnu-build-system)
        (arguments (go-args "supervisord" "-tags release -a -ldflags \"-linkmode external -extldflags -static\""))
        (native-inputs `(("go", go)))
        (home-page "https://github.com/ochinchina/supervisord")
        (synopsis " a go-lang supervisor implementation ")
        (description "The python script supervisord is a powerful tool used by a lot of guys to manage the processes. I like supervisord too.
But this tool requires that the big python environment be installed in target system. In some situation, for example in the docker environment, the python is too big for us.
This project re-implements supervisord in go-lang. Compiled supervisord is very suitable for environments where python is not installed.")
        (license expat)))
ochinchina-supervisor