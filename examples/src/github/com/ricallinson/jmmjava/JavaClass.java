package github.com.ricallinson.jmmjava;

import java.time.Year;
import github.com.ricallinson.jmmbuild.sub.*;

public class JavaClass {  
    public static void main(String args[]) {
        OtherClass c = new OtherClass();
        int time = Year.MAX_VALUE;
        System.out.println(c.msg());
        System.out.println("Here's one random number: " + Math.random());
    }
}
