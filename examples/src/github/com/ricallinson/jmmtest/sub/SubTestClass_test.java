package github.com.ricallinson.jmmtest.sub;

class SubTestClass_test {  
    public static void main(String args[]) {
        SubTestClass test = new SubTestClass();
        if (test.msg() == "Hello world") {
        	System.exit(1);
        }
    }
}
