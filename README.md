# Mikrotik-LTE-interface-operation-test
LTE interface monitoring script for mikrotik router

This script was created to monitor the Mikrotik LTE interface.
The script develops according to various logics:
1. It is checked whether the LTE interface is detected, otherwise a BEEP is played in the router and a reboot takes place. A log error appears in the logs indicating that the LTE interface was not detected.
2. It is checked whether the LTE interface is running. If it is, 20 pings are performed to a public host. if everything is OK the check is finished. If the LTE interface is not running, the interface is restarted and a second test is subsequently performed.
3. If the interface is not running when the second test is performed, the error beep is played and the router is restarted.


Instructions:
1. Copy the check-lte-import.rsc file to the Mikrotik router terminal;
2. Go to /system script, select the "LTE-check-script" script and click on "Run Script";
3. Check in the LOGs that the Schedule was created correctly. The script will check every 30 minutes;
4. Go to the terminal and paste the code you find in the logging.rsc file so that when the router reboots caused by a fail detected by this script it will be indicated in the logs even after the reboot.


GUIDA IN ITALIANO AL LINK: https://foisfabio.it/index.php/2024/03/28/mikrotik-script-check-lte/
