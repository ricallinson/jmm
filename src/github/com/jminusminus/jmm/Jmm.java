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

    // The version of Jmm.
    public static final String version = "0.0.1";

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
                System.out.println("");
                System.out.println("The tool for managing Jmm source code.");
                System.out.println("");
                System.out.println("Usage:");
                System.out.println("");
                System.out.println("    jmm command [arguments]");
                System.out.println("");
                System.out.println("The commands are:");
                System.out.println("");
                System.out.println("    install     compile packages and dependencies");
                System.out.println("    clean       remove object files");
                System.out.println("    doc         show documentation for package or workspace");
                System.out.println("    env         print Jmm environment information");
                System.out.println("    lint        run lint check on package sources");
                System.out.println("    get         download and install packages and dependencies (currently works with github.com only)");
                System.out.println("    here        set /Users/allinson/Java/jmm to the given directory");
                System.out.println("    list        list packages");
                System.out.println("    run         compile and run Jmm program (the first file must have the main method)");
                System.out.println("    test        test packages");
                System.out.println("    version     print Jmm version");
                System.out.println("");
                System.exit(0);
            case "here":
                System.out.println("here");
                System.exit(0);
            case "env":
                System.out.println("JMMPATH=" + System.getenv("JMMPATH"));
                System.out.println("JMMHOME=" + System.getenv("JMMHOME"));
                System.out.println("JAVA_HOME=" + System.getenv("JAVA_HOME"));
                System.exit(0);
            case "version":
                System.out.println(version);
                System.exit(0);
        }
    }

    public void action(String command) {
        switch (command) {
            case "clean":
                System.out.println("clean");
                System.exit(0);
            case "doc":
                System.out.println("doc");
                System.exit(0);
            case "list":
                System.out.println("list");
                System.exit(0);
            case "run-script":
                System.out.println("run-script");
                System.exit(0);
        }
    }

    public void execute(String command) {
        switch (command) {
            case "get":
                System.out.println("get");
                System.exit(0);
            case "install":
                System.out.println("install");
                System.exit(0);
            case "lint":
                System.out.println("lint");
                System.exit(0);
            case "run":
                System.out.println("run");
                System.exit(0);
            case "test":
                System.out.println("test");
                System.exit(0);
        }
    }
}
