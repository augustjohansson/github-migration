#!/bin/bash

while read p; do
    echo "$p"
    migrate.sh $p
done <repos.txt
