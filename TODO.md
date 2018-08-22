## Rough TODO list
This in no way represents features that will appear in this script

### Things to actually do:
* categorise the ruleset, possibly split into multiple lists?
* rate limit rules
  * See https://github.com/phreakme/DC23/blob/master/iptables.txt
* suite of LOG rules for spotting unusual behaviour
* see how close we can get porting http://c.sipvicious.org/resources/snortrules.txt to iptables LOG
* More thorough assessment of SIP headers

### Random selection of links to explore
* only accept clients configured with your domainname not with your IP - http://www.cyber-cottage.eu/?p=1028
* http://blog.sipvicious.org/2010/11/distributed-sip-scanning-during.html has some interesting ideas about other bits of the SIP header
* http://data.proidea.org.pl/confidence/5edycja/materialy/prezentacje/sandro_gauci_confidence_2009.pdf - lots of interesting
* https://github.com/jesusprubio/bluebox-ng
* https://github.com/orgdeftcode/vsaudit
