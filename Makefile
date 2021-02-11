GOARCH?=amd64
export GOARCH

GOOS?=linux
export GOOS

PREFIX?=.
export PREFIX

CGO_ENABLED?=1
export CGO_ENABLED

.PHONY: supervisord guix-package
supervisord:
	-mkdir -p ${PREFIX}/bin
	CGO_ENABLED=0 go build -trimpath -mod vendor -o ${PREFIX}/bin/supervisord 

guix-package:
	guix build -L . ochinchina-supervisor

