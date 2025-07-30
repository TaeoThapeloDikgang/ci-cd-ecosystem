FROM openjdk:17-jdk-slim
WORKDIR /app
COPY . .
ENV APP_TAG=$APP_TAG
RUN ./mvnw clean package
EXPOSE 7080
ENTRYPOINT ["java", "-jar", "/app/target/ci-cd-ecosystem-0.0.1-SNAPSHOT.jar"]
