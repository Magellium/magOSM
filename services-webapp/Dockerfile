FROM maven:3.9.6-eclipse-temurin-8-alpine AS builder

COPY . /usr/app/magosm

WORKDIR /usr/app/magosm

RUN unset MAVEN_CONFIG && chmod +x ./mvnw && ./mvnw clean install package -Dmaven.test.skip=true


FROM eclipse-temurin:8-alpine

RUN apk add curl

COPY --from=builder /usr/app/magosm/target/services-webapp-magosm-0.0.1-SNAPSHOT.war /usr/app/services-webapp-magosm.war

ENTRYPOINT ["java", "-jar", "/usr/app/services-webapp-magosm.war"]