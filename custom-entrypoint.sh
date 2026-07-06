#!/bin/bash

# 1. Ensure the /oem directory exists
mkdir -p /oem

# 2. Grab the environment variable (with an optional fallback)
URL=${LIGHTBURN_URL:-"https://github.com/LightBurnSoftware/deployment/releases/download/v1.5.01/LightBurn-v1.5.01.exe"}

# 3. Generate the Windows batch script dynamically
cat <<EOF > /oem/install.bat
@echo off
echo Downloading LightBurn from $URL...
curl.exe -L -o C:\LightBurn_Installer.exe "$URL"

echo Installing LightBurn...
:: LightBurn uses Inno Setup. These flags force a completely silent, unattended install.
C:\LightBurn_Installer.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-

echo Cleaning up...
del C:\LightBurn_Installer.exe
EOF

# 4. Convert line endings from Linux (LF) to Windows (CRLF) just to be safe
sed -i 's/$/\r/' /oem/install.bat

# 5. Hand control back to Dockur's original entrypoint to start the VM
exec /usr/bin/tini -s -- /run/entry.sh
