#!/bin/bash

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
)

for UA in "${UAGENTS[@]}"
do
  iptables -A INPUT -p udp -m udp --dport 5060 -m string --string "User-Agent: ${UA}" --algo bm --icase --to 65535 -j REJECT
  ip6tables -A INPUT -p udp -m udp --dport 5060 -m string --string "User-Agent: ${UA}" --algo bm --icase --to 65535 -j REJECT
done
