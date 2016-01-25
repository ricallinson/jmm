package github.com.ricallinson.jmmtest.sub;

class SubTestClass_test {  
    public static void main(String args[]) {
        SubTestClass test = new SubTestClass();
        if ("Hello world".equals(test.msg())) {
            System.exit(1);
        }
    }
}
