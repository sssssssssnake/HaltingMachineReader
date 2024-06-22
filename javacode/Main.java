package javacode;

import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
public class Main {
    // Main method
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        List<String> list = new ArrayList<>();

        System.out.println("Hello, World!");
        boolean test = true;
        if (test) {
            test = false;
        }
        System.out.println(test);
    }
}