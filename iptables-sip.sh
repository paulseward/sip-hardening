iptables -A INPUT -p udp -m udp --dport 5060 -m string --string "sipcli" --algo bm --to 65535 -j DROP
iptables -A INPUT -p udp -m udp --dport 5060 -m string --string "sipvicious" --algo bm --to 65535 -j DROP
iptables -A INPUT -p udp -m udp --dport 5060 -m string --string "sip-scan" --algo bm --to 65535 -j DROP
iptables -A INPUT -p udp -m udp --dport 5060 -m string --string "sipsak" --algo bm --to 65535 -j DROP
iptables -A INPUT -p udp -m udp --dport 5060 -m string --string "sundayaddr" --algo bm --to 65535 -j DROP
iptables -A INPUT -p udp -m udp --dport 5060 -m string --string "friendly-scanner" --algo bm --to 65535 -j DROP
iptables -A INPUT -p udp -m udp --dport 5060 -m string --string "iWar" --algo bm --to 65535 -j DROP
iptables -A INPUT -p udp -m udp --dport 5060 -m string --string "CSipSimple" --algo bm --to 65535 -j DROP
iptables -A INPUT -p udp -m udp --dport 5060 -m string --string "SIVuS" --algo bm --to 65535 -j DROP
iptables -A INPUT -p udp -m udp --dport 5060 -m string --string "Gulp" --algo bm --to 65535 -j DROP
iptables -A INPUT -p udp -m udp --dport 5060 -m string --string "sipv" --algo bm --to 65535 -j DROP
iptables -A INPUT -p udp -m udp --dport 5060 -m string --string "smap" --algo bm --to 65535 -j DROP
iptables -A INPUT -p udp -m udp --dport 5060 -m string --string "friendly-request" --algo bm --to 65535 -j DROP
iptables -A INPUT -p udp -m udp --dport 5060 -m string --string "VaxIPUserAgent" --algo bm --to 65535 -j DROP
iptables -A INPUT -p udp -m udp --dport 5060 -m string --string "VaxSIPUserAgent" --algo bm --to 65535 -j DROP
iptables -A INPUT -p udp -m udp --dport 5060 -m string --string "siparmyknife" --algo bm --to 65535 -j DROP
iptables -A INPUT -p udp -m udp --dport 5060 -m string --string "Test Agent" --algo bm --to 65535 -j DROP
