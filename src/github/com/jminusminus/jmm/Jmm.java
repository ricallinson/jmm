//
// Copyright 2016, Yahoo Inc.
// Copyrights licensed under the New BSD License.
// See the accompanying LICENSE file for terms.
//

// [![Build Status](https://travis-ci.org/jminusminus/jmm.svg?branch=master)](https://travis-ci.org/jminusminus/jmm)
// ## Stability: 0 - Unstable
// This package contains the CLI for the Jmm tool.
package github.com.jminusminus.jmm;

public class Jmm {

    public static void main(String[] args) {
        String command = "";
        if (args.length > 0) {
            command = args[0];
        }
        Jmm jmm = new Jmm();
        jmm.info(command);
        jmm.action(command);
        jmm.execute(command);
        System.out.println("jmm: unknown command " + command);
        System.out.println("Run 'go help' for usage.");
        System.exit(1);
    }

    public void info(String command) {
        switch (command) {
            case "help":
                System.out.println("help");
                return;
            case "here":
                System.out.println("here");
                return;
            case "env":
                System.out.println("env");
                return;
            case "version":
                System.out.println("version");
                return;
        }
    }

    public void action(String command) {
        switch (command) {
            case "clean":
                System.out.println("clean");
                return;
            case "doc":
                System.out.println("doc");
                return;
            case "list":
                System.out.println("list");
                return;
            case "run-script":
                System.out.println("run-script");
                return;
            default:
                System.out.println("jmm: unknown command " + command);
                System.out.println("Run 'go help' for usage.");
                System.exit(1);
        }
    }

    public void execute(String command) {
        switch (command) {
            case "get":
                System.out.println("get");
                return;
            case "install":
                System.out.println("install");
                return;
            case "lint":
                System.out.println("lint");
                return;
            case "run":
                System.out.println("run");
                return;
            case "test":
                System.out.println("test");
                return;
        }
    }
}
