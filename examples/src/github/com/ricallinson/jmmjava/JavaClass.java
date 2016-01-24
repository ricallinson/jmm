package github.com.ricallinson.jmmjava;

import java.net.Socket;
import github.com.ricallinson.jmmbuild.sub.*;

public class JavaClass {  
    public static void main(String args[]) {
        OtherClass c = new OtherClass();
        System.out.println(c.msg());
        System.out.println("Here's one random number: " + Math.random());
    }
}
