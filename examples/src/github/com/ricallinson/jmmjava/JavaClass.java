package github.com.ricallinson.jmmjava;

import java.time.*;
import github.com.ricallinson.jmmbuild.sub.*;

public class JavaClass {  
    public static void main(String args[]) {
        OtherClass c = new OtherClass();
        String time = java.time.format.DateTimeFormatter.RFC_1123_DATE_TIME.format(ZonedDateTime.now(ZoneId.of("GMT")));
        System.out.println(c.msg());
        System.out.println("Here's one random number: " + Math.random());
    }
}
