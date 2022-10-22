#!/bin/bash

read -p "input .env location: " env
result=$(cat $env | xargs -L1)
literals=""

for n in $result
do
literals="${literals} --from-literal=$n"
done

read -p "please Input secretname: " secretname
read -p "please Input namespace: " namespace
read -p "please Input kubeconfig path: " kubeconfig
export KUBE_CONFIG_PATH="$kubeconfig"
echo
kubeseal --fetch-cert > mycert.pem
kubectl create secret generic $secretname $literals --dry-run=client -oyaml | kubeseal -n $namespace --cert mycert.pem -oyaml

