How to launch R shiny web app on server :

_____________________
1. Install SQL server

#sudo apt-get install -y curl
#sudo apt-get update
#sudo apt-get upgrade
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/16.04/mssql-server.list | sudo tee /etc/apt/sources.list.d/mssql-server.list
sudo apt-get update
sudo apt-get install -y mssql-server

_____________________
2. Install unix-ODBC

curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
sudo apt-get update
sudo apt-get install -y mssql-tools unixodbc-dev
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc

_____________________
3. Install R and R-server

sudo apt-get install -y r-base
sudo su - -c "R -e \"install.packages('shiny', repos='https://cran.rstudio.com/')\""
sudo apt-get install -y gdebi-core
wget https://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.5.3.838-amd64.deb
echo y | sudo gdebi shiny-server-1.5.3.838-amd64.deb

#sudo su - -c "R -e \".libPaths()\""
#It must get the result as
#[1] "/usr/local/lib/R/site-library" "/usr/lib/R/site-library"
#[3] "/usr/lib/R/library"

sudo nano /usr/lib/R/etc/Renviron
#set commenting to the line as '#R_LIBS_USER=${R_LIBS_USER-‘~/R/x86_64-pc-linux-gnu-library/3.2’}' 

_____________________
4. Install all packages used in the shiny web app


sudo chmod 777 /usr/local/lib/R/site-library

sudo apt-get install -y r-cran-rjava
sudo add-apt-repository -y ppa:openjdk-r/ppa  
sudo apt-get update   
sudo apt-get install -y openjdk-7-jdk  
sudo apt-get install -y libgeos-dev
sudo apt-get install -y libcurl4-gnutls-dev
sudo apt-get install -y libssl-dev
sudo R CMD javareconf
sudo su - -c "R -e \"install.packages(c('RJDBC', 'XLConnect', 'devtools', 'RJSONIO', 'sp', 'png', 'pixmap', 'mapdata', 'maptools', 'maps', 'rgeos','RODBC','lubridate','dplyr','ggplot2','plotly','scales','DT','shinyTime'), repos='https://cran.rstudio.com/')\""

_____________________
5. Change the unix time-zone

#Go to 'System Settings' >> Personal : 'Language Support' >> set 'Regional Formats' to "English (United States)"
#Then, to 'System Settings' >> System : 'Time & Date' >> Location: "Bangkok" (Automatically from the Internet)

_____________________
6. Get 'preserve_logs true;' to the 1st line in /etc/shiny-server/shiny-server.conf

sudo nano /etc/shiny-server/shiny-server.conf
#Y to edit and get 'preserve_logs true;' to the 1st line
sudo systemctl start shiny-server

_____________________
7. Move the file to /srv/shiny-server/ to run the web app

sudo apt-get install -y subversion
svn checkout https://github.com/ieatbaozi/R-practicing/trunk/powermeterreport/ 
#Download from git to user home

cd /
sudo mv /home/administrator/powermeterreport/ /srv/shiny-server/ 
#From you path /home/*username*/ (in the case is 'admistrator') to server directory

cd -
sudo systemctl restart shiny-server

_____________________
8. Set Crontab hourly restarting the server

sudo apt-get install -y cron
sudo visudo
 username ALL=(ALL) NOPASSWD: /etc/cron.hourly/zz-reboot

sudo nano /etc/cron.hourly/zz-reboot
 #!/bin/bash
 systemctl restart shiny-server
 
sudo chmod a+x /etc/cron.hourly/zz-reboot

_____________________
9. Test the server by 'server address:3838' then test the domain 'server address:3838/powermeterreport/'
Note : Always check log files in /var/log/shiny-server/ it takes around 1b to most 2kb each file up to characters in log. It is able to delete log files to clear unnecessary allocation.
#sudo truncate -s 0 /var/log/shiny-server/*log 
#For setting bytes to zero but still keep files' name.
