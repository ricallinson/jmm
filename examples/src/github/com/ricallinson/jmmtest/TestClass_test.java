package github.com.ricallinson.jmmtest;

class TestClass_test {  
    public static void main(String args[]) {
        TestClass test = new TestClass();
        if (!"Hello world".equals(test.msg())) {
            System.exit(1);
        }
    }
}
