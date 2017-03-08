#!/bin/bash

display_usage() {
        echo -e "\nUsage:\npcf_samlfix [path to cf.pivotal file] [destination file]\n"
        }

# if less than two arguments supplied, display usage
        if [  $# -le 1 ]
        then
                display_usage
                exit 1
        fi


mkdir tmp
CF=$1
DEST=$2
unzip $CF -d tmp
sed -i 's/default: SHA1/default: SHA256/' tmp/metadata/cf.yml
sed -i 's/service_provider_key_credentials\.private_key_pem/\.properties\.networking_point_of_entry\.haproxy\.ssl_rsa_certificate\.private_key_pem/' 

tmp/metadata/cf.yml
sed -i 's/entityid: "http:/entityid: "https:/' tmp/metadata/cf.yml
sed -i 's/service_provider_key_credentials\.cert_pem/\.properties\.networking_point_of_entry\.haproxy\.ssl_rsa_certificate\.cert_pem/' tmp/metadata/cf.yml
pushd tmp
  zip -r ../$DEST *
popd
rm -rf tmp
exit 0

