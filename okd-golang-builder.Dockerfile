# This is a community version of the openshift-golang-builder definition from
# https://github.com/openshift/ocp-build-data/blob/golang-1.18/images/openshift-golang-builder.Dockerfile
# They should be kept in sync.

FROM quay.io/centos/centos:stream9

ARG GOPATH

ENV container=oci \
    GOPATH=${GOPATH:-/go} \
    GOMAXPROCS=8

RUN mkdir -p /go/src/ \
    && yum upgrade --refresh -y \
    && yum install -y --enablerepo=* \
        --setopt=skip_if_unavailable=True \
        --setopt=skip_missing_names_on_install=False \
        --setopt=install_weak_deps=False \
        bc file findutils gpgme git hostname lsof make socat tar tree util-linux wget which zip \
        openssl openssl-devel systemd-devel gpgme-devel libassuan-devel \
        nodejs \
        https://kojihub.stream.centos.org/kojifiles/packages/golang/1.19.1/2.el9/$(uname -m)/golang-1.19.1-2.el9.$(uname -m).rpm \
        https://kojihub.stream.centos.org/kojifiles/packages/golang/1.19.1/2.el9/$(uname -m)/golang-bin-1.19.1-2.el9.$(uname -m).rpm \
        https://kojihub.stream.centos.org/kojifiles/packages/golang/1.19.1/2.el9/noarch/golang-src-1.19.1-2.el9.noarch.rpm \
    && yum clean all \
    # goversioninfo is not shipped as RPM in Stream9, so install it with go instead
    && go install github.com/josephspurrier/goversioninfo/cmd/goversioninfo@latest

ENV GOFLAGS='-mod=vendor'

LABEL \
        io.k8s.description="This is a golang builder image for building OKD components." \
        summary="This is a golang builder image for building OKD components." \
        io.k8s.display-name="okd-golang-builder" \
        maintainer="The OKD Maintainers <maintainers@okd.io>" \
        name="okd/golang-builder" \
        io.openshift.tags="openshift"
