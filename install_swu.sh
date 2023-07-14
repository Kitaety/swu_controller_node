#!/bin/bash

. ~/.bash_profile

echo 'start install nvm';
sudo curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash;
sudo wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash;
echo 'nvm was installed';

echo '';
echo 'start install node';
nvm install 18.16.1;
echo 'node v18.16.1 was installed';
echo '';


echo '';
echo 'build application';
parentDir=$(dirname "$(realpath $0)")

cd $parentDir;
nvm use;
npm i;
npm run build;
echo '';

echo '';
echo 'creating swu service';
cat ./swu.service_template > swu.service;
sed -i "s|%%USER%%|$USER|g" swu.service;
sed -i "s|%%DIR%%|$parentDir|g" swu.service;
sudo cp swu.service /etc/systemd/system/
sudo systemctl start swu.service
sudo systemctl enable swu.service
echo '';

echo '';
echo 'adding swu to autorun application';
cat ./swu.desktop_template > swu.desktop;
sed -i "s|%%DIR%%|$parentDir|g" swu.desktop;

cp swu.desktop ~/Desktop/;
sudo chmod u+x ~/Desktop/swu.desktop;

sudo cp swu.desktop ~/.config/autostart;
sudo chmod a+x ~/.config/autostart/swu.desktop;
echo '';
