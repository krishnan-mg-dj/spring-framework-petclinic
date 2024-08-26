FROM ubuntu:22.04 AS build

RUN apt update -y && apt install openjdk-17-jdk -y && apt install wget git -y

RUN wget -O /opt/apache-maven-3.9.9-bin.tar.gz https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz \
    && tar -xzvf /opt/apache-maven-3.9.9-bin.tar.gz -C /opt \
    && rm /opt/apache-maven-3.9.9-bin.tar.gz

ENV MAVEN_HOME=/opt/apache-maven-3.9.9
ENV PATH=$MAVEN_HOME/bin:$PATH

ENV JAVA_HOME=/usr/lib/jvm/java-1.17.0-openjdk-amd64
ENV JAVA_PATH=/usr/lib/jvm/java-1.17.0-openjdk-amd64/bin

RUN git clone https://github.com/krishnan-mg-dj/spring-framework-petclinic.git

RUN cd spring-framework-petclinic && mvn clean install

FROM tomcat:jdk17

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=build /spring-framework-petclinic/target/petclinic.war /usr/local/tomcat/webapps

EXPOSE 8080

CMD ["catalina.sh", "run"]
