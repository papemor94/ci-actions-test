# First stage: complete build environment

FROM maven:3.5.4-jdk-8-alpine AS builder

ARG BRANCH
ARG GITHUBLOGIN
ARG GITHUBPASSWORD
ARG SONAR_URL
ARG SONAR_TOKEN
ARG MINOR

COPY pom.xml /services/pom.xml
COPY /src /services/src
WORKDIR /services

RUN mvn clean compile package


# Second stage: minimal runtime environment
From openjdk:8-jre-alpine
# copy jar from the first stage
COPY --from=builder services/target/App-1.0-SNAPSHOT-withdependencies.jar msb.jar
# run jar
CMD ["java", "-jar", "msb.jar"]
