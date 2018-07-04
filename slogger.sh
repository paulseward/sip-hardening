#!/bin/bash
# rough and ready SIP User-Agent logging, needs tshark installed

function usage {
  echo "Usage:"
  echo "$0 [options]"
  echo
  echo "  -l <logfile>   Log to a file instead of to the console"
  exit
}

LOGFILE=""

while getopts ":hl:" opt; do
  case ${opt} in
    h ) # Help
      usage
      ;;
    l ) # Logfile
      LOGFILE=$OPTARGS
      ;;
    \? )
      echo "Invalid Option: -$OPTARG" 1>&2
      usage
      ;;
  esac
done

# Run tshark, looking at the SIP port, logging only REGISTER, INVITE or 
# OPTIONS packets, and the log the timestamp, src, dst, SIP Method, User-Agent,
# auth.uri and sip.To headers (where present)
# dumping the output in $LOGFILE

if [ -n "$LOGFILE" ]; then
  tshark -l -f "port 5060" \
    -Y '(sip.Method=="REGISTER") or (sip.Method=="INVITE") or (sip.Method=="OPTIONS")' \
    -T fields \
    -e frame.time -e ip.src -e ip.dst -e sip.Method -e sip.User-Agent -e sip.auth.uri -e sip.To \
    -E header=y -E separator=, -E quote=d \
    > "${LOGFILE}" 2>&1
else
  tshark -l -f "port 5060" \
    -Y '(sip.Method=="REGISTER") or (sip.Method=="INVITE") or (sip.Method=="OPTIONS")' \
    -T fields \
    -e frame.time -e ip.src -e ip.dst -e sip.Method -e sip.User-Agent -e sip.auth.uri -e sip.To \
    -E header=y -E separator=, -E quote=d
fi
