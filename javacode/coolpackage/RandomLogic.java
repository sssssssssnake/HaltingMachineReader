package javacode.coolpackage;




public class RandomLogic {
    
    public class InnerClass {
        public void print() {
            System.out.println("Inner class");
        }
        Integer i = 0;
        OrganizedChaos.FunnyInnerClass funny;
        public InnerClass(OrganizedChaos.FunnyInnerClass funny) {
            this.funny = funny;
        }
    }

}
