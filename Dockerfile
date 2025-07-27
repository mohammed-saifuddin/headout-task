FROM eclipse-temurin:21

# Set workdir
WORKDIR /app

# Copy the JAR into the container
COPY build/libs/jb-hello-world-0.1.0.jar app.jar

# Expose port
EXPOSE 9000

# Run the application
CMD ["java", "-jar", "app.jar"]
