#!/bin/sh

os_name() {
    uname -s
}

os_is_qts() {
    [ -d /etc/config ] && [ -d /share ]
}
