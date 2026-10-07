#!/usr/bin/env bash
for i in pe{1..5} p{1..5}
do
    ssh admin@${i} "restart routing"
done
