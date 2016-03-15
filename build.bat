javac -d ../apache-tomcat-6.0.18/webapps/flight/WEB-INF/classes -classpath ../apache-tomcat-6.0.18/lib/servlet-api.jar:ojdbc6.jar *.java
xcopy web/*.html 
cd ../apache-tomcat-6.0.18/bin/ && startup.bat
