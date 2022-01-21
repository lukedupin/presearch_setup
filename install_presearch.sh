#!/bin/sh

echo "*** Initial system setup"
apt update -y
apt upgrade -y
apt install -y docker.io

echo ""
echo "*** Setup script"

echo "#!/bin/bash" > ~/run
echo "" >> ~/run
echo "YOUR_REGISTRATION_CODE_HERE=$1" >> ~/run
echo "" >> ~/run
echo "docker stop presearch-node ; docker rm presearch-node ; docker stop presearch-auto-updater ; docker rm presearch-auto-updater ; docker run -d --name presearch-auto-updater --restart=unless-stopped -v /var/run/docker.sock:/var/run/docker.sock presearch/auto-updater --cleanup --interval 900 presearch-auto-updater presearch-node ; docker pull presearch/node ; docker run -dt --name presearch-node --restart=unless-stopped -v presearch-node-storage:/app/node -e REGISTRATION_CODE=$YOUR_REGISTRATION_CODE_HERE presearch/node ; docker logs -f presearch-node" >> ~/run
chmod 755 ~/run

echo ""
echo "*** Setup systemd"

echo "cp presearch.service /etc/systemd/system/"
cp presearch.service /etc/systemd/system/
echo "systemctl daemon-reload"
systemctl daemon-reload
echo "systemctl enable presearch.service"
systemctl enable presearch.service

echo ""
echo "*** Running presearch for the first time"

echo "systemctl start presearch.service"
systemctl start presearch.service
