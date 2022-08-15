#!/bin/sh

#
# CertDeliver Client
# by Becod @ 2022.
#

random_number=$RANDOM

while getopts ":d:p:s:" opt_name
do
    case "$opt_name" in
        'd')
            domain="$OPTARG";;
        'p')
            password="$OPTARG";;
        's')
            server="$OPTARG";;
        ?)
            echo "Usage: $0 [-s server] [-d domain] [-p password]"
            exit 2
            ;;
    esac
done

key=`echo -n $password$domain$random_number|md5sum|awk '{print $1}'`
[ ! $domain ]&&echo "domain is null"&&exit
[ ! $password ]&&echo "password is null"&&exit
[ ! $server ]&&echo "server is null"&&exit

mkdir ./$domain

json=`curl -s $server"/?domain="$domain"&&m="$random_number"&&token="$key`

if [[ -n `echo "$json"|grep -v fullchain` ]];then
	echo "获取失败，请检查密码，域名是否正确"
	exit
fi

rsa_fullchain=`echo "$json"|jq -c '.rsa.fullchain'|sed 's/"//g'`
rsa_key=`echo "$json"|jq -c '.rsa.key'|sed 's/"//g'`
ecc_fullchain=`echo "$json"|jq -c '.ecc.fullchain'|sed 's/"//g'`
ecc_key=`echo "$json"|jq -c '.ecc.key'|sed 's/"//g'`
iv=`echo "$json"|jq -c '.iv'|sed 's/"//g'`
key=`echo -n $password$domain$random_number|xxd -p`

echo -n "$rsa_fullchain"|openssl aes-256-cbc -d -a -A -K $key -iv $iv -out /acme.sh/$domain/rsa.crt 2>/dev/null
echo -n "$rsa_key"|openssl aes-256-cbc -d -a -A -K $key -iv $iv -out /acme.sh/$domain/rsa.key 2>/dev/null
echo -n "$ecc_fullchain"|openssl aes-256-cbc -d -a -A -K $key -iv $iv -out /acme.sh/$domain/ecc.crt 2>/dev/null
echo -n "$ecc_key"|openssl aes-256-cbc -d -a -A -K $key -iv $iv -out /acme.sh/$domain/ecc.key 2>/dev/null

echo "证书已获取，位于/acme.sh/"$domain
