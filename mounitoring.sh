#!/bin/bash

ARCH=$(uname -a)

#CPU
PCPU=$(grep "physical id" /proc/cpuinfo | uniq | wc -l)
VCPU=$(grep -c "^processor" /proc/cpuinfo)

#RAM
RAM=$(free -m | grep Mem | awk '{printf("%d/%dMB (%.2f%%)\n",$3,$2,$3/$2*100)}')

#Storage
TDSK=$(df -h --total | grep "total" | awk '{print $2+0"Gb"}')
UDSK=$(df -BM --total | grep "total" | awk '{print $3+0}')
PDSK=$(df -h --total | grep "total" | awk '{printf("%.2f", $3/$2*100)}')

#Last boot date/time
BOOT=$(who -b | awk '{print $3 " " $4}')

#CPU Load
LOAD=$(top -bn1 | grep "Cpu(s)" | awk '{printf("%.2f%%", $2+$4)}')

#LVM
LVMS=$(lsblk | awk '{print $6}' | grep -q "lvm" && echo yes || echo no)

#Active Connections / Users
CONN=$(ss -t | grep -c "ESTAB")
USRS=$( who | awk '{print $1}' | uniq | wc -l)

#ADDRESSES
IPAD=$(hostname -I | awk '{print $1}')
MACA=$(ip link | grep "ether" | awk '{print $2}')

#SUDO Commands
SUCD=$(journalctl -q _COMM=sudo | grep COMMAND | wc -l)

wall "
    #Architecture:     $ARCH
    #CPU physical:     $PCPU
    #vCPU :         $VCPU
    #Memory Usage:     $RAM
    #Disk Usage:     $UDSK/$TDSK ($PDSK%)
    #CPU load:         $LOAD
    #Last boot:        $BOOT
    #LVM use:         $LVMS
    #Connections TCP :  $CONN ESTABLISHED
    #User log:         $USRS
    #Network:         IP $IPAD ($MACA)
    #Sudo :         $SUCD cmd
"
