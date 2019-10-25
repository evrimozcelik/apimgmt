oc new-app -f apicurio-standalone-template.yml \
  -p UI_ROUTE=apicurio-studio.192.168.99.100.nip.io \
  -p API_ROUTE=apicurio-studio-api.192.168.99.100.nip.io \
  -p WS_ROUTE=apicurio-studio-ws.192.168.99.100.nip.io \
  -p AUTH_ROUTE=apicurio-studio-auth.192.168.99.100.nip.io \
  -p GENERATED_KC_USER=admin \
  -p GENERATED_KC_PASS=admin
