#!/bin/bash
DEBUG=* mocha --compilers coffee:coffee-script/register -R spec -t 10s $1
#mocha --compilers coffee:coffee-script/register -R spec -t 10s $1
