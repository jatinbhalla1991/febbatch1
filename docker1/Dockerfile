# Multi-Stage Dockerfile for Java Application
# Stage 1: Build Stage - Compile Java code
FROM maven:3.9.5-eclipse-temurin-17 AS builder

# Set working directory
WORKDIR /app

# Copy source code
COPY src/ /app/src/

# Create directory structure for compiled classes
RUN mkdir -p /app/build

# Compile Java files
RUN javac -d /app/build /app/src/com/example/app/*.java

# Stage 2: Runtime Stage - Run the application with minimal image
FROM eclipse-temurin:17-jre-alpine

# Set working directory
WORKDIR /app

# Copy only compiled classes from builder stage
COPY --from=builder /app/build /app

# Set environment variable
ENV ENVIRONMENT=production

# Expose port 8080
EXPOSE 8080

# Create non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Set the entrypoint
ENTRYPOINT ["java", "-cp", "/app", "com.example.app.HelloDocker"]

# Metadata
LABEL maintainer="devops@example.com"
LABEL description="Multi-stage Docker build for Java web application"
LABEL version="1.0"
