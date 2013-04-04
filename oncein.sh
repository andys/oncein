#!/bin/bash

seconds=$1
shift
cmd=`which $1`
shift

if [ x$seconds == 'x'  ] || [ x$cmd == 'x' ] || [ ! -x $cmd ] ; then
    echo 'Usage: oncein <seconds> <command> [args..]'
    exit 3
fi

starttime=`/bin/date +"%s"`
timestampfile="/var/lock/oncein_`basename $cmd`.lock"
firstrun=0
runcommand=1
if [ ! -f $timestampfile ] ; then
    firstrun=1
fi

# Get an exclusive lock
exec 9>>$timestampfile
flock 9
{
    if [ ! "$firstrun" -eq "1" ] ; then
    	timenow=`/bin/date +"%s"`
    	filetime=`/usr/bin/stat -c "%Y" $timestampfile`
    	
        # seconds since lockfile was last touched
        age=$(( $timenow - $filetime ))

        if [ $filetime -gt $starttime ] ; then
            # someone else ran the command since we started, so we don't have to
            runcommand=0
        elif [ $age -lt $seconds ] ; then
            # sleep if necessary to make up the correct number of seconds
            sleep $(($seconds - $age))
        fi
    fi

    # we're done sleeping. update the timestamp before releasing the lock
    touch $timestampfile

# release the lock      
} 9<&-
exec 9<&-

if [ $runcommand -eq "1" ] ; then
    # run the requested command
    exec $cmd $@
fi
