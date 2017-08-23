#!/bin/bash

# Note we're not looking for "exact match" on the User-Agent - all the strings below
# will be partial match, so the entry for "x" matches any User-Agent that starts with an 'x'

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
  "eyeBeam release 3006o"
  "Ozeki VoIP SIP SDK"
  "x"
  "Cisco-SIPGateway"
  "Cisco-CUCM"
  "Custom SIP Phone"
  "dr.pes"
)

for UA in "${UAGENTS[@]}"
do
  iptables -A INPUT -p udp -m udp --dport 5060 -m string --string "User-Agent: ${UA}" --algo bm --icase --to 65535 -j REJECT
  ip6tables -A INPUT -p udp -m udp --dport 5060 -m string --string "User-Agent: ${UA}" --algo bm --icase --to 65535 -j REJECT
done
