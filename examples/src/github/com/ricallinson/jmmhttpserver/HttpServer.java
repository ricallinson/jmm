package github.com.ricallinson.jmmhttpserver;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.time.*;

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
                    System.out.println("");
                    PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
                    String time = java.time.format.DateTimeFormatter.RFC_1123_DATE_TIME.format(ZonedDateTime.now(ZoneId.of("GMT")));
                    String body = "<h1>Hello world</h1>";
                    out.println("HTTP/1.1 200 OK");
                    out.println("Date: " + time);
                    out.println("Server: JmmHttpServerExample");
                    out.println("Last-Modified: " + time);
                    out.println("Content-Length: " + Integer.toString(body.length()));
                    out.println("Content-Type: text/html");
                    out.println("Connection: Closed");
                    out.println("");
                    out.println(body);
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
