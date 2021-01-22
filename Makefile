GOARCH?=amd64
export GOARCH

GOOS?=linux
export GOOS

PREFIX?=.
export PREFIX

CGO_ENABLED?=1
export CGO_ENABLED

.PHONY: supervisord
supervisord:
	-mkdir -p ${PREFIX}/bin
	go build $(GOFLAGS) -mod vendor -o ${PREFIX}/bin/supervisord github.com/ochinchina/supervisord