#!/bin/bash

java -Xmx1024m -jar signapk.jar -w testkey.x509.pem testkey.pk8 OpenELEC.zip OpenELEC-signed.zip
