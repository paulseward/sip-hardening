# SIPTABLEs
This is a proof of concept, and a partial solution.

## It should be deployed in conjunction with:
* non-numeric SIP usernames - don't just use your extension numbers
* strong SIP passwords - you're only going to have to type it into your ATA once, make it long and complex
* If you're using asterisk, make sure you set `alwaysauthreject=yes` in your `sip.conf`
* Where possible, limit the number of simultaneous calls each SIP entity can make
* Don't allow unauthenticated callers into a context that has exit points to other contexts
* fail2ban is still useful

## Known caveats:
* This script currently blindly adds the rules to the front of the `INPUT` chain.  You should probably check that is what you want to happen.
* The list of User-Agents may include clients that are legitimate in your network.  You should review that before deploying.
* We're using iptables string matching, I haven't tested this on a high throughput server.  My hosts only handle a couple of dozen legitimate calls a day.
* User-Agent matching isn't going to stop determined or compitent attackers

## User-Agent Identification Methodology
The list of User-Agents has been culled from as many security papers as I could lay my hands on and has been sanitized to remove User-Agents which I have legitimately talking to my servers.  This has been combined with User-Agents I've identified scanning my servers that don't match my legitimate clients.

The list of clients as provided may block your legitimate clients, it may allow through a scan.

Use it with care!

-Paul
