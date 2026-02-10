package com.example;

/**
 * A simple Calculator class for demonstration purposes
 */
public class Calculator {
    
    /**
     * Adds two numbers
     */
    public int add(int a, int b) {
        return a + b;
    }
    
    /**
     * Subtracts two numbers
     */
    public int subtract(int a, int b) {
        return a - b;
    }
    
    /**
     * Multiplies two numbers
     */
    public int multiply(int a, int b) {
        return a * b;
    }
    
    /**
     * Divides two numbers
     */
    public double divide(int a, int b) {
        if (b == 0) {
            throw new IllegalArgumentException("Cannot divide by zero");
        }
        return (double) a / b;
    }
    
    /**
     * Main method for demonstration
     */
    public static void main(String[] args) {
        Calculator calc = new Calculator();
        System.out.println("Calculator Demo");
        System.out.println("5 + 3 = " + calc.add(5, 3));
        System.out.println("5 - 3 = " + calc.subtract(5, 3));
        System.out.println("5 * 3 = " + calc.multiply(5, 3));
        System.out.println("5 / 3 = " + calc.divide(5, 3));
    }
}
