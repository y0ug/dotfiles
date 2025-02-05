#!/usr/bin/env bash
bwc.py --fields=password microsoft |
  run.sh xfreerdp /v:10.83.20.102 \
    /dynamic-resolution /d:MicrosoftAccount \
    /u:hca443@gmail.com /floatbar /clipboard \
    /from-stdin
