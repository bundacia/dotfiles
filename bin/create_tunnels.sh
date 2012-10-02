#!/bin/bash
sudo ifconfig lo0 inet 192.168.0.1 netmask 255.255.255.0 alias 
sudo ifconfig lo0 inet 192.168.0.2 netmask 255.255.255.0 alias 
sudo ifconfig lo0 inet 192.168.0.3 netmask 255.255.255.0 alias 
sudo ifconfig lo0 inet 192.168.0.4 netmask 255.255.255.0 alias 

echo "Opening tunnels. Ctrl+C to quit..."
ssh -L 192.168.0.1:3306:shyguy:3306 -L 192.168.0.2:3306:rep01:3306 -L 192.168.0.3:3306:rep02:3306 -L 192.168.0.3:5029:mole:5029 daisy2.webassign.net -N

sudo ifconfig lo0 inet 192.168.0.1 netmask 255.255.255.0 -alias 
sudo ifconfig lo0 inet 192.168.0.2 netmask 255.255.255.0 -alias 
sudo ifconfig lo0 inet 192.168.0.3 netmask 255.255.255.0 -alias 
sudo ifconfig lo0 inet 192.168.0.4 netmask 255.255.255.0 -alias 

