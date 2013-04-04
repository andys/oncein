
## oncein bash script

Ensure a command is only run once in N seconds.

### Example

    oncein 30 apache2ctl graceful


In this case, it creates a lock file called

    /var/lock/oncein_apache2ctl.lock


This means any command called "apache2ctl" will be only run once per 30 seconds. 

If it has run more than 30 seconds ago, it will run immediately.

If it was run less than 30 seconds ago, it will sleep as required to make up
30 seconds.  If another identical command is run during this time, it will
also sleep but won't actually run the command at the end of the sleep.



