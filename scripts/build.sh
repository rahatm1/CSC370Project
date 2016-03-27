javac -d ../../apache-tomcat-6.0.18/webapps/flight/WEB-INF/classes -classpath ../../apache-tomcat-6.0.18/lib/servlet-api.jar:../lib/ojdbc6.jar ../main/*.java
cp -r ../web/*.html ../../apache-tomcat-6.0.18/webapps/flight/
cp ../web/web.xml ../../apache-tomcat-6.0.18/webapps/flight/WEB-INF/
cp ../web/background.jpg ../../apache-tomcat-6.0.18/webapps/flight/
cd ../../apache-tomcat-6.0.18/bin/ && ./startup.sh
