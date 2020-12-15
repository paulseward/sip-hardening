#!/bin/bash

# Note we're not looking for "exact match" on the User-Agent - all the strings below
# will be partial match, so the entry for "x" matches any User-Agent that starts with an 'x'
CHAIN_NAME="SIP-Reject"

# List of networks to whitelist - ie, your internal network
IP_WHITELIST=(
  "10.0.0.0/24"  # internal network
  "217.10.79.23" # sipgate
)

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
  "FourCats"
  "friendly-request"
  "friendly-scanner"
  "fgfdhgfxjfhyjhkj"
  "Gulp"
  "IM-client/OMA1.0"
  "iWar"
  "MizuPhone"
  "Ozeki VoIP SIP SDK"
  "PBX"
  "PortSIP VoIP SDK"
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
#
# Asterisk default UA is "Asterisk PBX" and some scanners are using that
# They're also using "Asterisk" on its own, so we attempt to block that by terminating
# the match with a \n
AGGRESSIVE=(
  "FPBX"
  "FreePBX "
  "Linksys"
)

# sipvicious indicator signatures, to block regardless of the User-Agent
SIPVICIOUS=(
  "sipvicious"
  "@1.1.1.1>"
  "Via: SIP/2.0/UDP 172.16"
  "UDP 172.16"
  "UDP 172.17"
  "UDP 172.18"
  "UDP 172.19"
  "UDP 172.20"
  "UDP 172.21"
  "UDP 172.22"
  "UDP 172.23"
  "UDP 172.24"
  "UDP 172.25"
  "UDP 172.26"
  "UDP 172.27"
  "UDP 172.28"
  "UDP 172.29"
  "UDP 172.30"
  "UDP 172.31"
)

# For some reason, people seem to be spraying INVITEs that look like the
# packets described in RFC 3261.  This is likely a poorly configured default
# so we'll just block any fqdn mentioned in the RFC.
RFC3261=(
  "pc33.atlanta.com"
  "server10.biloxi.com"
  "bigbox3.site3.atlanta.com"
  "bobspc.biloxi.com"
  "erlang.bell-telephone.com"
  "first.example.com"
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

# Add the IP Whitelist to the chain first
for INET in "${IP_WHITELIST[@]}"
do
  iptables -A ${CHAIN_NAME} -p udp -m udp --dport 5060 -s ${INET} -j ACCEPT
done

# populate the chain, with SIPVICIOUS->WHITELIST->BLACKLIST->AGGRESSIVE
# So that sipvicious gets blocked, even if it's using a User-Agent that's on the whitelist
#
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
for FQDN in "${RFC3261[@]}"
do
  iptables -A ${CHAIN_NAME} -p udp -m udp --dport 5060 -m string --string "${FQDN}" --algo bm --icase --to 65535 -j REJECT
done
iptables -A ${CHAIN_NAME} -j RETURN

# Check to see if our chain is in the input chain 
if iptables -C INPUT -j SIP-Reject > /dev/null 2>&1; then
  # Yes, noop
  :
else
  # Otherwise create it
  iptables -I INPUT -j ${CHAIN_NAME}
fi
