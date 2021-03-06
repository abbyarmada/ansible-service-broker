#!/bin/bash
action=$1

export GLIDE_TARBALL="https://github.com/Masterminds/glide/releases/download/v0.12.3/glide-v0.12.3-linux-amd64.tar.gz"
export PROJECT_ROOT=$GOPATH/src/github.com/fusor/ansible-service-broker

if [[ "$action" == "install" ]]; then
  wget -O /tmp/glide.tar.gz $GLIDE_TARBALL
  tar xfv /tmp/glide.tar.gz -C /tmp
  sudo mv $(find /tmp -name "glide") /usr/bin
  cd $PROJECT_ROOT && glide install
elif [[ "$action" == "lint" ]]; then
  echo "================================="
  echo "             Lint                "
  echo "================================="
  CMD_PASS=$(gofmt -d $PROJECT_ROOT/cmd 2>&1 | read; echo $?)
  PKG_PASS=$(gofmt -d $PROJECT_ROOT/pkg 2>&1 | read; echo $?)
  echo "CMD_PASS=$CMD_PASS"
  echo "PKG_PASS=$PKG_PASS"
  FULL_PASS=$([[ $CMD_PASS == 1 ]] && [[ $PKG_PASS == 1 ]]; echo $?)
  echo "FULL_PASS=$FULL_PASS"
  echo "================================="
  exit $FULL_PASS
else
  echo "No arguments passed. Nothing done."
fi

