#!/bin/bash

UAGENTS=(
  "sipcli"
  "sipvicious"
  "sip-scan"
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
  iptables -A INPUT -p udp -m udp --dport 5060 -m string --string "${UA}" --algo bm --to 65535 -j DROP
  ip6tables -A INPUT -p udp -m udp --dport 5060 -m string --string "${UA}" --algo bm --to 65535 -j DROP
done
