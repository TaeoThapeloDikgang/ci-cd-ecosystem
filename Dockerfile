FROM openjdk:17-jdk-slim

# Re-declare ARG inside the build stage
ARG APP_TAG

# Set environment variable for runtime
ENV APP_TAG=${APP_TAG}

WORKDIR /app
COPY . .

# Optional: print during build
RUN echo "Building image with tag: $APP_TAG"

RUN ./mvnw clean package

EXPOSE 7080

ENTRYPOINT ["java", "-jar", "/app/target/ci-cd-ecosystem-0.0.1-SNAPSHOT.jar"]
