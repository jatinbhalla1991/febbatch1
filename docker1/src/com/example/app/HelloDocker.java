package com.example.app;

import com.sun.net.httpserver.HttpServer;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpExchange;
import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class HelloDocker {
    
    public static void main(String[] args) throws IOException {
        // Create HTTP server on port 8080
        HttpServer server = HttpServer.create(new InetSocketAddress(8080), 0);
        
        // Create endpoints
        server.createContext("/", new HomeHandler());
        server.createContext("/health", new HealthHandler());
        server.createContext("/info", new InfoHandler());
        server.createContext("/calculate", new CalculateHandler());
        
        server.setExecutor(null);
        server.start();
        
        System.out.println("========================================");
        System.out.println("  Java Web Server Started!  ");
        System.out.println("========================================");
        System.out.println("Server running on: http://localhost:8080");
        System.out.println("Endpoints:");
        System.out.println("  - http://localhost:8080/");
        System.out.println("  - http://localhost:8080/health");
        System.out.println("  - http://localhost:8080/info");
        System.out.println("  - http://localhost:8080/calculate");
        System.out.println("========================================");
    }
    
    // Home page handler
    static class HomeHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange exchange) throws IOException {
            String response = buildHtmlPage(
                "Welcome to Multi-Stage Docker Demo!",
                "<h2>Java Application Running in Docker</h2>" +
                "<p>This application demonstrates multi-stage Docker builds.</p>" +
                "<h3>Available Endpoints:</h3>" +
                "<ul>" +
                "<li><a href='/health'>/health</a> - Health check endpoint</li>" +
                "<li><a href='/info'>/info</a> - System information</li>" +
                "<li><a href='/calculate'>/calculate</a> - Sample calculation</li>" +
                "</ul>" +
                "<p><strong>Time:</strong> " + getCurrentTime() + "</p>"
            );
            sendResponse(exchange, response);
        }
    }
    
    // Health check handler
    static class HealthHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange exchange) throws IOException {
            String response = buildHtmlPage(
                "Health Check",
                "<h2>✅ Application Status: Healthy</h2>" +
                "<p><strong>Status:</strong> Running</p>" +
                "<p><strong>Timestamp:</strong> " + getCurrentTime() + "</p>" +
                "<p><a href='/'>← Back to Home</a></p>"
            );
            sendResponse(exchange, response);
        }
    }
    
    // System info handler
    static class InfoHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange exchange) throws IOException {
            String env = System.getenv("ENVIRONMENT");
            String response = buildHtmlPage(
                "System Information",
                "<h2>System Information</h2>" +
                "<table style='border-collapse: collapse; width: 100%;'>" +
                "<tr><th style='border: 1px solid #ddd; padding: 8px; text-align: left; background-color: #4CAF50; color: white;'>Property</th>" +
                "<th style='border: 1px solid #ddd; padding: 8px; text-align: left; background-color: #4CAF50; color: white;'>Value</th></tr>" +
                "<tr><td style='border: 1px solid #ddd; padding: 8px;'>Java Version</td><td style='border: 1px solid #ddd; padding: 8px;'>" + System.getProperty("java.version") + "</td></tr>" +
                "<tr><td style='border: 1px solid #ddd; padding: 8px;'>OS Name</td><td style='border: 1px solid #ddd; padding: 8px;'>" + System.getProperty("os.name") + "</td></tr>" +
                "<tr><td style='border: 1px solid #ddd; padding: 8px;'>OS Architecture</td><td style='border: 1px solid #ddd; padding: 8px;'>" + System.getProperty("os.arch") + "</td></tr>" +
                "<tr><td style='border: 1px solid #ddd; padding: 8px;'>Java Home</td><td style='border: 1px solid #ddd; padding: 8px;'>" + System.getProperty("java.home") + "</td></tr>" +
                "<tr><td style='border: 1px solid #ddd; padding: 8px;'>Environment</td><td style='border: 1px solid #ddd; padding: 8px;'>" + (env != null ? env : "Not set") + "</td></tr>" +
                "</table>" +
                "<p><a href='/'>← Back to Home</a></p>"
            );
            sendResponse(exchange, response);
        }
    }
    
    // Calculate handler
    static class CalculateHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange exchange) throws IOException {
            Calculator calc = new Calculator();
            String response = buildHtmlPage(
                "Calculator Demo",
                "<h2>Calculator Results</h2>" +
                "<table style='border-collapse: collapse; width: 100%;'>" +
                "<tr><th style='border: 1px solid #ddd; padding: 8px; text-align: left; background-color: #2196F3; color: white;'>Operation</th>" +
                "<th style='border: 1px solid #ddd; padding: 8px; text-align: left; background-color: #2196F3; color: white;'>Result</th></tr>" +
                "<tr><td style='border: 1px solid #ddd; padding: 8px;'>10 + 20</td><td style='border: 1px solid #ddd; padding: 8px;'>" + calc.add(10, 20) + "</td></tr>" +
                "<tr><td style='border: 1px solid #ddd; padding: 8px;'>20 - 5</td><td style='border: 1px solid #ddd; padding: 8px;'>" + calc.subtract(20, 5) + "</td></tr>" +
                "<tr><td style='border: 1px solid #ddd; padding: 8px;'>6 × 7</td><td style='border: 1px solid #ddd; padding: 8px;'>" + calc.multiply(6, 7) + "</td></tr>" +
                "<tr><td style='border: 1px solid #ddd; padding: 8px;'>100 ÷ 4</td><td style='border: 1px solid #ddd; padding: 8px;'>" + calc.divide(100, 4) + "</td></tr>" +
                "</table>" +
                "<p><a href='/'>← Back to Home</a></p>"
            );
            sendResponse(exchange, response);
        }
    }
    
    // Helper method to build HTML page
    private static String buildHtmlPage(String title, String content) {
        return "<!DOCTYPE html>" +
               "<html>" +
               "<head>" +
               "<meta charset='UTF-8'>" +
               "<title>" + title + "</title>" +
               "<style>" +
               "body { font-family: Arial, sans-serif; max-width: 800px; margin: 50px auto; padding: 20px; background-color: #f0f0f0; }" +
               "h1 { color: #333; border-bottom: 3px solid #4CAF50; padding-bottom: 10px; }" +
               "h2 { color: #555; }" +
               "a { color: #2196F3; text-decoration: none; }" +
               "a:hover { text-decoration: underline; }" +
               ".container { background-color: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }" +
               "ul { line-height: 1.8; }" +
               "</style>" +
               "</head>" +
               "<body>" +
               "<div class='container'>" +
               "<h1>" + title + "</h1>" +
               content +
               "</div>" +
               "</body>" +
               "</html>";
    }
    
    // Helper method to send HTTP response
    private static void sendResponse(HttpExchange exchange, String response) throws IOException {
        exchange.getResponseHeaders().set("Content-Type", "text/html; charset=UTF-8");
        exchange.sendResponseHeaders(200, response.getBytes().length);
        OutputStream os = exchange.getResponseBody();
        os.write(response.getBytes());
        os.close();
    }
    
    // Helper method to get current time
    private static String getCurrentTime() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        return LocalDateTime.now().format(formatter);
    }
}
