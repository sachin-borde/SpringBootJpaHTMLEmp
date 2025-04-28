# 1) Builder stage: compile the Spring Boot JAR
FROM eclipse-temurin:21-jdk-jammy AS builder # Match host JDK
WORKDIR /app

# Pre-fetch dependencies to leverage layer cache
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN ./mvnw dependency:go-offline

# Copy source and package application (skip tests for speed)
COPY src ./src
RUN ./mvnw package -DskipTests

# 2) Runtime stage: smaller image with only the JRE and your app
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# Copy the JAR from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Expose the default Spring Boot port
EXPOSE 8080

# Run the application as a simple java -jar
ENTRYPOINT ["java", "-jar", "app.jar"]
