package javacode.coolpackage;

public class OrganizedChaos {
    public static int five = 5;
    public class FunnyInnerClass {
        String name = "Funny";
        public void print() { System.out.println("Funny inner class");
        if (name.equals(five)) {
            System.out.println("It's a match!");
        }
        }
    }
    
}
