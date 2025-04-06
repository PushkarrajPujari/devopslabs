FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install Java and Maven
RUN apt-get update && \
    apt-get install -y git curl unzip wget software-properties-common && \
    apt-get install -y openjdk-17-jdk && \
    wget https://downloads.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz && \
    tar xzf apache-maven-3.9.6-bin.tar.gz -C /opt && \
    ln -s /opt/apache-maven-3.9.6 /opt/maven && \
    ln -s /opt/maven/bin/mvn /usr/bin/mvn && \
    rm apache-maven-3.9.6-bin.tar.gz

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV MAVEN_HOME=/opt/maven
ENV PATH=$PATH:$JAVA_HOME/bin:$MAVEN_HOME/bin

WORKDIR /app

# Clone your actual Spring Boot app (replace with your Git repo)
RUN git clone https://github.com/spring-projects/spring-petclinic.git .

# Build and rename the jar
RUN mvn clean package -DskipTests && \
    cp target/*.jar app.jar

EXPOSE 8080

# Final fix: no wildcard in CMD
CMD ["java", "-jar", "app.jar"]
