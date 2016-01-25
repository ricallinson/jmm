package github.com.ricallinson.jmmtest;

class TestClass_test {  
    public static void main(String args[]) {
        TestClass test = new TestClass();
        if (test.msg() != "Hello world") {
        	System.exit(1);
        }
    }
}
