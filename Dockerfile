FROM openjdk:17-jdk-slim
WORKDIR /app
COPY . .
RUN ./mvnw clean package
#COPY /app/target/ci-cd-ecosystem-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 7080
ENTRYPOINT ["java", "-jar", "/app/target/ci-cd-ecosystem-0.0.1-SNAPSHOT.jar"]
