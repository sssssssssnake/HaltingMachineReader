package javacode;

import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import static javacode.coolpackage.OrganizedChaos.five; // Import all classes in the package
import javacode.coolpackage.RandomLogic; // Import all static classes in the package
import java.util.Arrays.*; // Import all classes in the package  
import javacode.coolpackage.OrganizedChaos;
@SuppressWarnings("unused")
public class Main {
    // Main method
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        List<String> list = new ArrayList<>();
        RandomLogic bob = new RandomLogic();
        OrganizedChaos oc = new OrganizedChaos();
        RandomLogic.InnerClass inner = bob.new InnerClass( oc.new FunnyInnerClass());

        System.out.println("Hello, World!");
        boolean test = true;
        if (test) {
            test = false;
        }
        System.out.println(test);
        inner.print();
        System.out.println(five);
    }
}