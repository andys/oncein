
## oncein bash script

Ensure a command is only run once in N seconds. It creates a lock file in
/var/lock/ based on the md5sum of the entire command string.

### Example

    oncein 30 apache2ctl graceful


This means the command "apache2ctl graceful" will be only run once per 30 seconds. 

If it has run more than 30 seconds ago, it will run immediately.

If it was run less than 30 seconds ago, it will sleep as required to make up
30 seconds.  If another identical command is run during this time, it will
also sleep but won't actually run the command at the end of the sleep.
