This is a proof of concept, not a complete solution.

This script blindly adds the rules to the end of the `INPUT` chain, not caring what comes before or after it.  This is likely not what you want.

If you have a "default deny" rule at the end of your `INPUT` chain, these rules will be added after it and will never be hit.

If you have a "allow SIP" rule before these rules in your `INPUT` chain, then these rules will be added after it and will never be hit.

The list of User-Agents has been culled from as many security papers as I could lay my hands on and has been sanitized to remove User-Agents which I have legitimately talking to my servers.

Use it with care!

-Paul
