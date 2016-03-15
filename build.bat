javac -d ..\apache-tomcat-6.0.18\webapps\flight\WEB-INF\classes -classpath ..\apache-tomcat-6.0.18\lib\servlet-api.jar;ojdbc6.jar *.java
xcopy "web\*.html" "..\apache-tomcat-6.0.18\webapps\flight\" /y
..\apache-tomcat-6.0.18\bin\startup.bat