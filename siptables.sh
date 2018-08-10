#!/bin/bash

# Note we're not looking for "exact match" on the User-Agent - all the strings below
# will be partial match, so the entry for "x" matches any User-Agent that starts with an 'x'
CHAIN_NAME="SIP-Reject"

# If we're regex blocking, we'll need a whitelist of legitimate User-Agents
WHITELIST=(
)

BLACKLIST=(
  "aaaaaaaa"
  "A_B_C"
  "Asterix PBX"
  "China"
  "Cisco-CUCM"
  "Cisco-SIPGateway"
  "Conaito"
  "CSipSimple"
  "Custom SIP Phone"
  "dr.pes"
  "eyeBeam"
  "friendly-request"
  "friendly-scanner"
  "Gulp"
  "IM-client/OMA1.0"
  "iWar"
  "MizuPhone"
  "Ozeki VoIP SIP SDK"
  "PBX"
  "pplsip"
  "siparmyknife"
  "sipcli"
  "sipsak"
  "sip-scan"
  "sipscan"
  "SIPScan"
  "sipv"
  "sipvicious"
  "sivus"
  "SIVuS"
  "smap"
  "sundayaddr"
  "Test Agent"
  "VaxIPUserAgent"
  "VaxSIPUserAgent"
  "voip"
  "VoIP SIP"
  "x"
  "xlite"
  "Z 3"
)

# User-Agents removed from the above list as they're in use by legitimate clients
# of my service, but which you may want to block
AGGRESSIVE=(
  "FPBX"
  "FreePBX "
)

# sipvicious indicator signatures, to block regardless of the User-Agent
SIPVICIOUS=(
  "sipvicious"
  "@1.1.1.1>"
)

# Quit unless we're root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Check to see if our chain exists:
if iptables -L ${CHAIN_NAME} > /dev/null 2>&1; then
  # Yes, flush it
  iptables -F ${CHAIN_NAME}
else
  # Otherwise create it
  iptables -N ${CHAIN_NAME}
fi

# populate the chain, with SIPVICIOUS->WHITELIST->BLACKLIST->AGGRESSIVE->EXPERIMENTAL
# So that sipvicious gets blocked, even if it's using a User-Agent that's on the whitelist
for SIG in "${SIPVICIOUS[@]}"
do
  iptables -A ${CHAIN_NAME} -p udp -m udp --dport 5060 -m string --string "${SIG}" --algo bm --icase --to 65535 -j REJECT
done
for UA in "${WHITELIST[@]}"
do
  iptables -A ${CHAIN_NAME} -p udp -m udp --dport 5060 -m string --string "User-Agent: ${UA}" --algo bm --icase --to 65535 -j ACCEPT
done
for UA in "${BLACKLIST[@]}"
do
  iptables -A ${CHAIN_NAME} -p udp -m udp --dport 5060 -m string --string "User-Agent: ${UA}" --algo bm --icase --to 65535 -j REJECT
done
for UA in "${AGGRESSIVE[@]}"
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
