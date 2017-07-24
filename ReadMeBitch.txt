Info-Presentation
Fujikura Electronic (Thailand) Ltd. Northen Region Industrial Estate - Lamphun
Internship as MIT department's trainees around 2 months :
Sirawit Takaew (Jimmy)
Mongkolkarn Tonde (Pae)

Objective of internship :
- Applicability from lecture to career
- Enhances of the academic experience
- Career direction
- Problem solving skills
- Communication skills

Timeline : 1 Jun - 27 Jul

====================================================================================================

Process ->


Requirements : An web application displays plots about main power meter's diff-kWh with analysis. 

Design : https://github.com/ieatbaozi/R-Practicing/blob/master/UI%20report.png

Implementation :
- Do sql query data.
- Do data preprocessing.
(Just done data preparetion but during work in process was having a meeting and getting new requirements.)

New Requirements : An web apllication displays plot about main power meter's diff-kWh and submeter's voltage-current minutely thorough report.

Design : https://github.com/ieatbaozi/R-Practicing/blob/master/design2.png (Make it simple.)

Implementation : 
- Split analysis visualization out for only education. 
- Go on developing web application by using Shiny web application package. 
- Add exporting data table after data filtered by *.csv and plot by *.png.
- Do reactive data plot.
- Simulate web server by linux using Terminal bash configuring all things and deploying web to server before install the real web server. 

Verification : User testing for feedback and get new a little requirements to add submeter's daily diff-kWh data.

====================================================================================================

Tools : Use - sql query on MSSQL server
- Open source R on Rstudio
- VB on Visual Studio
- Bash on Ubuntu 16.04 Virtual machine simulated
- Git on github.com for commiting files
Romote the server on VNC viewer. Moreover, Learn many solutions on stackoverflow.com and github.com / 

====================================================================================================

Problems & Solutions
General : 
- Found meter being out of order or broken from missing or unproper values. -> Tell supervisor or PE department.
- Something takes too long time for tutorial and hard to understand. -> Ask supervisor suggestions.
Developing : 
- Cant fix the error. -> Find another way more safe coding and ask stackoverflow. 
- Lots of missing values and accumulated after got diff-val. -> Filter data again and bin proper values.
- Different format between Windows and Linux platform. -> Create function displaying texts returning values.
- Wrong timezone making time shifted 7 hours. -> Check packages or functions' timezone default which one should set "Asia/Bangkok" or "UTC" to.
- Shell script is very complicated and error. -> Do normal bash (Make it simple.)
- Linux has many packages related. -> Check and install carefully till completely.


====================================================================================================

Benefits
"Lots of learning"
- Work as a team.
- Friendship.
- The importance of going by the book.
"To"
- Be on time.
- Be concentrated.
- Realise about safety.
- Better solution skills.
- Apply concept in practical to real life including career path.
