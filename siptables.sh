#!/bin/bash

# Note we're not looking for "exact match" on the User-Agent - all the strings below
# will be partial match, so the entry for "x" matches any User-Agent that starts with an 'x'
CHAIN_NAME="SIP-Reject"

# If we're regex blocking, we'll need a whitelist of legitimate User-Agents
WHITELIST=(
)

BLACKLIST=(
  "Asterix PBX"
  "PBX"
  "voip"
  "sipcli"
  "pplsip"
  "sipvicious"
  "sip-scan"
  "sipscan"
  "SIPScan"
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
  "Z 3"
  "A_B_C"
  "aaaaaaaa"
  "sivus"
  "China"
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
