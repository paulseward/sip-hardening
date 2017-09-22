#!/bin/bash
# rough and ready SIP User-Agent logging, needs tshark installed
tshark -l -f "port 5060 and src not 192.168.1.100" -Y '(sip.Method=="REGISTER") or (sip.Method=="INVITE") or (sip.Method=="OPTIONS")' -T fields -e ip.src -e ip.dst -e sip.Method -e sip.User-Agent -e sip.auth.uri -e sip.To -E header=y -E separator=, > /tmp/sip_ua.log 2>&1
