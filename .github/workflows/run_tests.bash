#!/bin/bash -xe

[[ $(grep -E \"^tests_run:\" Makefile) == \"\" ]] && exit 0 || make tests_run
