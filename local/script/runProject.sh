#export PYSPARK_PYTHON=python3

#setting current folder to /home/user
cd

#STOP HADOOP IF OPENED 
sh script/stopHadoop.sh 

#RUN HADOOP
sh script/runHadoop.sh 

#Running HIVE and saving query
sh script/runHive.sh

#launching node server for plotting query hive
cd server
node serverPhone.js &
cd ..

#Running SPARK
sh script/runSparkApp.sh 

#launching openscoring
java -jar server/openscoring-server-executable-2.1.1.jar &

#loading model inside openscoring server
sleep 5
curl -X PUT --data-binary @output/model/model.pmml -H "Content-type: text/xml" http://localhost:8080/openscoring/model/model

#Launching chrome with disabled web secutiry (because of CORS problems)
google-chrome --disable-web-security --user-data-dir=[opt/google/chrome] &

