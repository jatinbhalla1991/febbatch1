# Java Docker Multi-Stage Build Demo

This folder contains a Java application with a multi-stage Dockerfile.

## Project Structure

```
docker1/
├── Dockerfile              # Multi-stage Docker build file
├── src/
│   └── com/
│       └── example/
│           └── app/
│               ├── HelloDocker.java    # Main application
│               └── Calculator.java     # Calculator utility
└── README.md
```

## Multi-Stage Build Benefits

1. **Smaller Image Size**: Runtime image only contains JRE and compiled classes
2. **Security**: Build tools are not included in final image
3. **Faster Deployments**: Smaller images deploy faster
4. **Separation of Concerns**: Build and runtime environments are separated

## Build Stages

### Stage 1: Builder
- Base Image: `maven:3.9.5-eclipse-temurin-17`
- Purpose: Compile Java source code
- Size: ~700MB (not in final image)

### Stage 2: Runtime
- Base Image: `eclipse-temurin:17-jre-alpine`
- Purpose: Run the compiled application
- Size: ~180MB (final image)

## Building the Docker Image

```bash
# Navigate to docker1 folder
cd docker1

# Build the image
docker build -t java-multistage-demo .

# Build with custom tag
docker build -t java-multistage-demo:v1.0 .
```

## Running the Container

```bash
# Run the container with port mapping
docker run -p 8080:8080 java-multistage-demo

# Run in detached mode (background)
docker run -d -p 8080:8080 java-multistage-demo

# Run with custom environment variable
docker run -p 8080:8080 -e ENVIRONMENT=development java-multistage-demo

# Run with custom name
docker run -d -p 8080:8080 --name my-java-app java-multistage-demo
```

**Access the application:**
- Home: http://localhost:8080
- Health Check: http://localhost:8080/health
- System Info: http://localhost:8080/info
- Calculator: http://localhost:8080/calculate

## Verify Image Size

```bash
# Check image size
docker images java-multistage-demo

# Compare with single-stage build (if you had one)
docker history java-multistage-demo
```

## Docker Commands Cheatsheet

```bash
# Build image
docker build -t java-multistage-demo .

# Run container
docker run java-multistage-demo

# Run interactively
docker run -it java-multistage-demo sh

# View logs
docker logs <container-id>

# Remove image
docker rmi java-multistage-demo

# View build layers
docker history java-multistage-demo

# Inspect image
docker inspect java-multistage-demo
```

## Optimization Tips

1. **Use Alpine base images**: Smaller footprint
2. **Multi-stage builds**: Separate build and runtime
3. **Layer caching**: Order commands from least to most changing
4. **Non-root user**: Run as non-privileged user for security
5. **.dockerignore**: Exclude unnecessary files

## Expected Output

When you run the container, you should see:
```
========================================
  Welcome to Multi-Stage Docker Demo!  
========================================

Application: Java Hello World
Java Version: 17.x.x
OS: Linux

Sample Calculation: 10 + 20 = 30
Environment: production

Application running successfully!
========================================
```
