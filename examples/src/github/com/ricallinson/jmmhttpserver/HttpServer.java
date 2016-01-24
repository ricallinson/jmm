package github.com.ricallinson.jmmhttpserver;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;

public class HttpServer {

    public static void main(String[] args) throws IOException {
        ServerSocket listener = new ServerSocket(8080);
        try {
            while (true) {
                Socket socket = listener.accept();
                try {
                    BufferedReader input = new BufferedReader(new InputStreamReader(socket.getInputStream()));
                    String line = input.readLine();
                    while (line.length() > 0) {
                        System.out.println(line);
                        line = input.readLine();
                    }
                    PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
                    out.println("Hello");
                } finally {
                    socket.close();
                }
            }
        }
        finally {
            listener.close();
        }
    }
}
