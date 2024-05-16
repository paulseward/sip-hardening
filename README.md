# SIPTABLEs

> [!CAUTION]
> The list of clients as provided may block your legitimate clients. Equally, it will allow through some scans with a legitimate user-agent
> 
> Use it with care, and read `siptables.sh` before deploying!

## It should be deployed in conjunction with:
* non-numeric SIP usernames - the bulk scanners are looking for accounts where the username matches an extension number
* strong SIP passwords - you're only going to have to type it into your ATA once, make it long and complex

* Asterisk chan_sip
  * If you're using asterisk, make sure you set `alwaysauthreject=yes` in your `sip.conf`
  * Where possible, limit the number of simultaneous calls each SIP entity can make
  * Don't allow unauthenticated callers into a context that has exit points to other contexts

* Asterisk chan_pjsip
  * TODO: add the pjsip equivalent advice of the defaults mentioned above

* IP Address Blocking
  * A sip specific block list such as [apiban.org](apiban.org) is useful
  * fail2ban can help too

## Known caveats:
* The list of User-Agents may include clients that are legitimate in your network.  You should review that!
* User-Agent matching isn't going to stop determined or compitent attackers, but it does reduce the noise to levels that makes them easier to spot
* We're using iptables string matching, I haven't tested this on a high throughput server.  My hosts only handle a couple of dozen legitimate calls a day.
* Some scanners use randomized User-Agent strings, which we can't currently spot.  If you've got `kprce` and can do regex bases string matching in iptables, you may be able to add that
* We're only touching IPv4 traffic, if you extend this to cover IPv6 I'd welcome a PR

## User-Agent Identification Methodology
Suspect User-Agents have been sourced from:
* As many security papers as I could lay my hands on
* A SIP Honeypot that I ran in GCP,  The logging code is GCP specific but is easy to strip out, the source can be found at https://gitlab.com/paulseward/honeypot-sip
* Scanning scripts that run on my Asterisk Servers

There are some experimental rules in there that block based on non-User-Agent indicators of sipvicious, these may expend over time.
