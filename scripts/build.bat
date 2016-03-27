javac -d ..\..\apache-tomcat-6.0.18\webapps\flight\WEB-INF\classes -classpath ..\..\apache-tomcat-6.0.18\lib\servlet-api.jar;..\lib\ojdbc6.jar ..\main\*.java
xcopy "..\web\*.html" "..\..\apache-tomcat-6.0.18\webapps\flight\" /y
xcopy "..\web\web.xml" "..\..\apache-tomcat-6.0.18\webapps\flight\WEB-INF\" /y
xcopy "..\web\background.jpg" "..\..\apache-tomcat-6.0.18\webapps\flight\" /y
..\..\apache-tomcat-6.0.18\bin\startup.bat
