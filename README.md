# Calculator Demo with GitHub Actions

A simple Java calculator application demonstrating CI/CD with GitHub Actions.

## 🚀 Features

- Basic arithmetic operations (add, subtract, multiply, divide)
- Comprehensive unit tests with JUnit 5
- Automated CI/CD pipeline with GitHub Actions
- Multi-version Java testing (Java 11, 17, 21)

## 📋 Prerequisites

- Java 11 or higher
- Maven 3.6+

## 🔧 Building the Project

```bash
# Compile the code
mvn clean compile

# Run tests
mvn test

# Package as JAR
mvn package
```

## 🏃 Running the Application

```bash
java -jar target/calculator-demo-1.0.0.jar
```

Or run directly:
```bash
mvn exec:java -Dexec.mainClass="com.example.Calculator"
```

## 🧪 Running Tests

```bash
mvn test
```

## 📊 GitHub Actions Workflow

The project includes a comprehensive CI/CD pipeline that:

- ✅ Runs on push to main/master/develop branches
- ✅ Runs on pull requests
- ✅ Tests against multiple Java versions (11, 17, 21)
- ✅ Compiles, tests, and packages the application
- ✅ Uploads build artifacts
- ✅ Generates and publishes test reports
- ✅ Performs code quality checks

### Workflow Badges

Add this to your README once you push to GitHub:

```markdown
![Java CI](https://github.com/YOUR_USERNAME/YOUR_REPO/workflows/Java%20CI%20with%20Maven/badge.svg)
```

## 📁 Project Structure

```
.
├── .github
│   └── workflows
│       └── build.yml          # GitHub Actions workflow
├── src
│   ├── main
│   │   └── java
│   │       └── com
│   │           └── example
│   │               └── Calculator.java
│   └── test
│       └── java
│           └── com
│               └── example
│                   └── CalculatorTest.java
├── pom.xml
├── .gitignore
└── README.md
```

## 🎯 Next Steps

1. Initialize Git repository: `git init`
2. Add files: `git add .`
3. Commit: `git commit -m "Initial commit with Calculator and GitHub Actions"`
4. Create a repository on GitHub
5. Push to GitHub:
   ```bash
   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
   git branch -M main
   git push -u origin main
   ```

The GitHub Actions workflow will automatically run on push!

## 📝 License

MIT License