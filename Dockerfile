# Use an official Maven runtime as a parent image
FROM maven:3.8.4-openjdk-17-slim AS build

# Set the working directory in the container
WORKDIR /app

# Copy the POM file and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the project source code into the container
COPY src ./src

# Build the JAR file
RUN mvn package -DskipTests

# Use an OpenJDK runtime as a parent image for the final image
FROM openjdk:17-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file from the previous build stage to the final image
COPY --from=build /app/target/*.jar hw-test.jar

# Expose the port that your Spring Boot application runs on (e.g., 8080)
EXPOSE 8080

# Specify the command to run your Spring Boot application
CMD ["java", "-jar", "hw-test.jar"]
