#!/bin/bash

MISP_URL=""
MISP_KEY=""

sed -i -e '/s/YOUR_MISP_URL/${MISP_URL}/g' /root/mail_to_misp/mail_to_misp_config.py
sed -i -e '/s/YOUR_KEY_HERE/${MISP_KEY}/g' /root/mail_to_misp/mail_to_misp_config.py
