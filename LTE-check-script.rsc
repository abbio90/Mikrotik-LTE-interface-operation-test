/system script
add dont-require-permissions=yes name=LTE-check-script owner=abbio90 policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="#----------------------------------------\r\
    \n# CHECK LTE BY foisfabio.it\r\
    \n# \r\
    \n# Script: LTE interface operation test\r\
    \n# Version: 1.0\r\
    \n# RouterOS v.7.14.2\r\
    \n# Created: 17/11/2023\r\
    \n# Updated: 25/03/2024\r\
    \n# Author:  Fois Fabio\r\
    \n# Editor: Fois Fabio\r\
    \n\r\
    \n# Website: https://foisfabio.it\r\
    \n# Email: consulenza@foisfabio.it\r\
    \n#\r\
    \n#----------------------------------------\r\
    \n{\r\
    \n\r\
    \n:local scheduleName \"LTE-check-Schedule\"\r\
    \n:local myRunTime \"00:30:00\"\r\
    \n:if ([:len [/system scheduler find name=\"\$scheduleName\"]] = 0) do={\r\
    \n    /log warning \"[LTE-check-Schedule] Alert : lo Scheduler non esiste.\"\r\
    \n    /system scheduler add name=\$scheduleName interval=\$myRunTime start-date=Jan/01/1970 start-time=startup on-event=\"/system script run LTE-check-script\"\r\
    \n    /log warning \"[LTE-check-script] Alert : Scheduler creato .\"\r\
    \n    }\r\
    \n#FOLLOW LTE INTERFACE\r\
    \n\r\
    \n:local LTEinterface\r\
    \n:foreach i in=[/interface lte find] do={ \r\
    \n    :set \$LTEinterface [/interface lte get \$i name]\r\
    \n    } \r\
    \n:put \$LTEinterface\r\
    \n \r\
    \n:if ([\$LTEinterface] !=\"lte1\") do={\r\
    \n    :beep frequency=660 length=300ms;\r\
    \n    :delay 150ms;\r\
    \n    :beep frequency=260 length=1000ms;\r\
    \n    :delay 5s;\r\
    \n    :log error \"LTE INTERFACCIA NON RILEVATA\"\r\
    \n    /system reboot\r\
    \n    }\r\
    \n\r\
    \n#SET STATUS LTE INTERFACE\r\
    \n:local check1\r\
    \n:local check2\r\
    \n:local LTEstatus [/interface lte get lte1 value-name=running]\r\
    \n:put \$LTEstatus\r\
    \n:if ([\$LTEstatus] != true) do={\r\
    \n    :set \$check1 \"fail\"\r\
    \n    /log warning \"LTE Interfaccia NOT RUNNING Check 1 - Riavvio Interfaccia LTE da script\"\r\
    \n    } else={\r\
    \n    :set \$check1 \"OK\"\r\
    \n    }\r\
    \n:put \$check1\r\
    \n\r\
    \n\r\
    \n#IF LTE OK RUN CHECK-PING | REBOOT INTERFACE- ELSE RUN CHECK2\r\
    \n\r\
    \n:if ([\$check1] = \"OK\") do={\r\
    \n    :if ([/ping 1.1.1.1 count=20] = 0) do={\r\
    \n        /log warning \"LTE OFFLINE - Riavvio Interfaccia LTE da script\"\r\
    \n        :delay 5s;\r\
    \n         /interface lte disable lte1 \r\
    \n        :delay 2s\r\
    \n        /interface lte enable lte1\r\
    \n        :set \$check2 \"OK\"\r\
    \n        } else={\r\
    \n        /log info \"Check 1 LTE Completato\"\r\
    \n        :set \$check2 \"OK\"\r\
    \n        }\r\
    \n    } else={\r\
    \n    /interface lte disable lte1 \r\
    \n    :delay 2s\r\
    \n    /interface lte enable lte1\r\
    \n    :delay 60s\r\
    \n    :local LTEstatus2 [/interface lte get lte1 value-name=running]\r\
    \n    :put \$LTEstatus2\r\
    \n    :if ([\$LTEstatus2] != true) do={\r\
    \n        :set \$check2 \"fail\"\r\
    \n        } else={\r\
    \n        :set \$check2 \"OK\"\r\
    \n        }\r\
    \n    }\r\
    \n:put \$check2\r\
    \n\r\
    \n#IF LTE OK RUN CHECK-PING - ELSE REBOOT ROUTER\r\
    \n\r\
    \n:if ([\$check2] = \"OK\") do={\r\
    \n    :if ([/ping 1.1.1.1 count=20] = 0) do={\r\
    \n        /log error \"LTE OFFLINE - Riavvio da Script\"\r\
    \n        /interface lte disable lte1 \r\
    \n        :delay 2s\r\
    \n        /interface lte enable lte1\r\
    \n        } else={\r\
    \n        /log info \"Check 2 LTE Completato\"\r\
    \n        }\r\
    \n    } else={\r\
    \n    /log error \"LTE Interfaccia NOT RUNNING dopo Check 2 - Riavvio da Script\"\r\
    \n     :beep frequency=660 length=300ms;\r\
    \n     :delay 150ms;\r\
    \n     :beep frequency=260 length=1000ms;\r\
    \n     :delay 5s;\r\
    \n     /system reboot\r\
    \n     }\r\
    \n }"
