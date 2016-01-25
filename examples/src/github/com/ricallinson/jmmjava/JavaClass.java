package github.com.ricallinson.jmmjava;

import java.io.IOException;
import java.net.ServerSocket;
import github.com.ricallinson.jmminstall.sub.*;

public class JavaClass {  
    public static void main(String args[]) throws IOException {
    	ServerSocket listener = new ServerSocket(8080);
    	listener.close();
        OtherClass c = new OtherClass();
        System.out.println(c.msg());
        System.out.println("Here's one random number: " + Math.random());
    }
}
