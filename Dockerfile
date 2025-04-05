FROM adoptopenjdk/openjdk11:alpine-jre
ARG JAR_FILE=target/assignment.jar
WORKDIR /opt/app
COPY ${JAR_FILE} assignment.jar
ENTRYPOINT ["java","-jar","assignment.jar"]
