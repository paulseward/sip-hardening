#!/bin/bash
sudo ln -s $(pwd)/siptables.sh /usr/local/bin/siptables
sudo cp siptables.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable siptables.service

