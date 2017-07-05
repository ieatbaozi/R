How to launch R shiny web app on server :
1. Install SQL server
2. Install unix-ODBC
3. Install R-server
4. Install all packages used in the shiny web app
5. Use right odbc to connect database server {ODBC Driver 13 for SQL Server}
6. Correct path file to source file
8. Change the unix time-zone
9. Get 'preserve_logs true;' to the 1st line in /etc/shiny-server/shiny-server.conf
10. Move the file to /srv/shiny-server/ to run the web app
