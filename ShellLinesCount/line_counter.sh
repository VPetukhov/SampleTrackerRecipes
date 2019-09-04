#!/bin/bash
echo $1: `cat $2 | wc -l` > sum.txt
