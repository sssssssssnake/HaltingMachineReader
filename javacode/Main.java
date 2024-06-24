package javacode;

import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import javacode.coolpackage.RandomLogic; // Import all classes in the package
public class Main {
    // Main method
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        List<String> list = new ArrayList<>();
        RandomLogic bob = new RandomLogic();
        RandomLogic.InnerClass inner = bob.new InnerClass();

        System.out.println("Hello, World!");
        boolean test = true;
        if (test) {
            test = false;
        }
        System.out.println(test);
    }
}