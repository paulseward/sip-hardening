#!/bin/bash

# Note we're not looking for "exact match" on the User-Agent - all the strings below
# will be partial match, so the entry for "x" matches any User-Agent that starts with an 'x'
CHAIN_NAME="SIP-Reject"

UAGENTS=(
  "PBX"
  "voip"
  "sipcli"
  "pplsip"
  "sipvicious"
  "sip-scan"
  "sipscan"
  "xlite"
  "MizuPhone"
  "sipsak"
  "sundayaddr"
  "friendly-scanner"
  "iWar"
  "CSipSimple"
  "SIVuS"
  "Gulp"
  "sipv"
  "smap"
  "friendly-request"
  "VaxIPUserAgent"
  "VaxSIPUserAgent"
  "siparmyknife"
  "Test Agent"
  "eyeBeam"
  "IM-client/OMA1.0"
  "Ozeki VoIP SIP SDK"
  "x"
  "Cisco-SIPGateway"
  "Cisco-CUCM"
  "Custom SIP Phone"
  "dr.pes"
  "Conaito"
  "FPBX"
  "Z 3"
)

# Check to see if our chain exists:
if iptables -L ${CHAIN_NAME} > /dev/null 2>&1; then
  # Yes, flush it
  iptables -F ${CHAIN_NAME}
else
  # Otherwise create it
  iptables -N ${CHAIN_NAME}
fi
# populate it
for UA in "${UAGENTS[@]}"
do
  iptables -A ${CHAIN_NAME} -p udp -m udp --dport 5060 -m string --string "User-Agent: ${UA}" --algo bm --icase --to 65535 -j REJECT
done

# Check to see if our chain is in the input chain 
if sudo iptables -C INPUT -j SIP-Reject > /dev/null 2>&1; then
  # Yes, noop
  :
else
  # Otherwise create it
  iptables -I INPUT -j ${CHAIN_NAME}
fi
