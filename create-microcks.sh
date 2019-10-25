oc new-app -f microcks-openshift-persistent-full-template.yml \
    -p OPENSHIFT_MASTER=https://192.168.99.100:8443 \
    -p OPENSHIFT_OAUTH_CLIENT_NAME=microcks \
    -p APP_ROUTE_HOSTNAME=microcks.192.168.99.100.nip.io \
    -p KEYCLOAK_ROUTE_HOSTNAME=microcks-auth.192.168.99.100.nip.io \
    -p KEYCLOAK_ADMIN_USERNAME=admin \
    -p KEYCLOAK_ADMIN_PASSWORD=admin 
    

