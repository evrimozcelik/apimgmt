oc new-app -f microcks-openshift-template.yml \
    -p OPENSHIFT_MASTER=https://192.168.42.25:8443 \
    -p OPENSHIFT_OAUTH_CLIENT_NAME=microcks \
    -p APP_ROUTE_HOSTNAME=microcks.192.168.42.25.nip.io \
    -p KEYCLOAK_ROUTE_HOSTNAME=apicurio-studio-auth.192.168.42.25.nip.io 

