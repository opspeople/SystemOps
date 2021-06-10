#!/bin/bash
cp node-exporter.service /usr/lib/systemd/system/
cp node_exporter /usr/local/bin/
systemctl daemon-reload
systemctl start node-exporter
systemctl status node-exporter
