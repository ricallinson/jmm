//
// Copyright 2016, Yahoo Inc.
// Copyrights licensed under the New BSD License.
// See the accompanying LICENSE file for terms.
//

// [![Build Status](https://travis-ci.org/jminusminus/jmm.svg?branch=master)](https://travis-ci.org/jminusminus/jmm)
// ## Stability: 0 - Unstable
// This package contains the CLI for the Jmm tool.
package github.com.jminusminus.jmm;

import github.com.jminusminus.core.Path;
import github.com.jminusminus.core.Fs;

public class Jmm {

    // The tool for managing Jmm source code.
    public static void main(String[] args) {
        String command = "";
        String arg = "";
        if (args.length > 0) {
            command = args[0];
        }
        if (args.length > 1) {
            arg = args[1];
        }
        Jmm jmm = new Jmm();
        jmm.info(command, arg);
        jmm.action(command, arg);
        jmm.execute(command, arg);
        System.out.println("jmm: unknown command " + command);
        System.out.println("Run 'go help' for usage.");
        System.exit(1);
    }

    // The version of Jmm.
    protected static final String version = "0.0.1";

    protected void info(String command, String arg) {
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
                if (!this.setJmmPath(arg)) {
                    System.out.println("You must run this command in a Jmm workspace");
                    System.exit(1);
                }
                System.out.println("Jmm workspace set to " + System.getProperty("JMMPATH"));
                System.exit(0);
            case "env":
                System.out.println("JMMPATH=" + System.getenv("JMMPATH"));
                System.out.println("JMMHOME=" + System.getenv("JMMHOME"));
                System.out.println("JAVA_HOME=" + System.getenv("JAVA_HOME"));
                System.exit(0);
            case "version":
                System.out.println(this.version);
                System.exit(0);
        }
    }

    protected void action(String command, String arg) {
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

    protected void execute(String command, String arg) {
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

    protected boolean setJmmPath(String path) {
        String jmmPath = this.findJmmSrc(path);
        if (jmmPath == null) {
            return false;
        }
        System.setProperty("JMMPATH", jmmPath);
        return true;
    }

    protected String findJmmSrc(String path) {
        path = Path.resolve(path);
        while (!path.isEmpty()) {
            String[] files = Fs.readdir(path);
            if (files == null) {
                return null;
            }
            for (String file : files) {
                if ("src".equals(file)) {
                    return path;
                }
            }
            path = Path.dirname(path);
        }
        return null;
    }
}
