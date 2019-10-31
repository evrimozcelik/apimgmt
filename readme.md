# API Lifecycle Management with Apicurio and Microcks 

Contract design, mock services, contract verification during CI pipeline, API catalog.

## Original OpenShift Template Files
https://raw.githubusercontent.com/Apicurio/apicurio-studio/master/distro/openshift/apicurio-standalone-template.yml
https://raw.githubusercontent.com/microcks/microcks/master/install/openshift/openshift-persistent-full-template-https.yml


## Resolution of the Apicurio & Microcks SSL Handshake problem

Apicurio calls Microcks API to create mock services, if self-signed certificates are used in Routes then Apicurio raises SSL Handshake exception as the certificate validation fails. To overcome the issue, the following workaround solution can be applied. Alternative to the workaround there can be 2 other approaches to add self signed certs to java cacerts; 1) apicurio-studio-api Dockerfile can be extended, 2) init container can be launched. 



https://medium.com/@ricardozanini/how-to-redeploy-the-default-router-certificate-on-minishift-510f039c4c8e
https://medium.com/@paraspatidar/add-ssl-tls-certificate-or-pem-file-to-kubernetes-pod-s-trusted-root-ca-store-7bed5cd683d
 
 
1) Get OpenShift master certificates
 
> From local machine run minishift ssh
> Copy ca.crt, ca.key and ca.serial.txt files from /var/lib/minishift/base/openshift-apiserver folder to local machine
 
2) Generate self signed certificates for each route,
 
> oc adm ca create-server-cert --signer=ca.crt --signer-key=ca.key --signer-serial=ca.serial.txt --hostnames='microcks.192.168.99.100.nip.io' --cert=microcks.crt --key=microcks.key
> oc adm ca create-server-cert --signer=ca.crt --signer-key=ca.key --signer-serial=ca.serial.txt --hostnames='microcks-auth.192.168.99.100.nip.io' --cert=microcks-auth.crt --key=microcks-auth.key
 
3) Load certificate and key files to microcks and keycloak route definitions

> https://docs.openshift.com/container-platform/3.11/dev_guide/routes.html
 
4) Copy cacerts file from apicurio-studio-api pod from /etc/pki/ca-trust/extracted/java/cacerts

> oc cp apicurio-studio-api-5-jdst6:/etc/pki/ca-trust/extracted/java/cacerts .
 
5) Import microcks and microcks-auth crt files to cacerts using keytool
 
> keytool -importcert -file microcks.crt -alias microcks -keystore cacerts -storepass changeit
> keytool -importcert -file microcks-auth.crt -alias microcks-auth -keystore cacerts -storepass changeit
> keytool -v -list -keystore cacerts -storepass changeit | grep -i microcks
 
6) Create cacerts configmap

> oc create cm cacerts --from-file=cacerts
 
7) Mount configmap to apicurio-studio-api deployment config
 
>       volumeMounts:
>            - name: cacerts
>              mountPath: /etc/pki/ca-trust/extracted/java/cacerts
>              subPath: cacerts
>              readOnly: true
>        volumes:
>          - name: cacerts
>            configMap:
>              name: cacerts
 
 
8) Rollout apicurio-studio-api
 
> oc rollout latest apicurio-studio-api

