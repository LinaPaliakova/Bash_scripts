#!/bin/bash

# The script  waits until Asterisk has no calls in progress, and then it restarts the service. It does not prevent new calls from entering the system.
# The alternative can be core restart now or core restart when convenient

# If asterisk was configured as a service, you can use  service asterisk restart. The service will be restarted immediately.

if [ "$(whoami)" != "asterisk" ];
then
echo "Script must be running as user asterisk"
exit 255
fi


/usr/sbin/asterisk -rx "core restart gracefully" # restarting asterisk from cli
                                      
echo "Asterisk restarted at `date`" | mail -s "Asterisk restarted" abc@gmail.com
