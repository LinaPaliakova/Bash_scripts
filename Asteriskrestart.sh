#!/bin/bash

# The script  waits until Asterisk has no calls in progress, and then it restarts the service. It does not prevent new calls from entering the system.
# The alternative can be core restart now or core restart when convenient

# If asterisk was configured as a service, you can use  service asterisk restart. The service will be restarted immediately.

if [ "$(whoami)" != "asterisk" ]; #optinal part
then
echo "Script must be running as user asterisk"
exit 255
fi


/usr/sbin/asterisk -rx "core stop gracefully" >/dev/null 2>&1# restarting asterisk from cli


while ps ax | grep '[s]afe_asterisk' >/dev/null ; do sleep 3 ; done

service asterisk start >/dev/null 2>&1                              
echo "Asterisk restarted at `date`" | mail -s "Asterisk restarted" abc@gmail.com


# core restart gracefully. These commands do not restart asterisk application: the PID is left as it was; the process /usr/sbin/asterisk is left running; the used memory is left under the process.

