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

public class JmmCli {

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
        JmmCli jmm = new JmmCli();
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
                System.out.println("    install     (N/A) compile packages and dependencies");
                System.out.println("    clean       (N/A) remove object files");
                System.out.println("    doc         (N/A) show documentation for package or workspace");
                System.out.println("    env         (N/A) print Jmm environment information");
                System.out.println("    lint        (N/A) run lint check on package sources");
                System.out.println("    get         (N/A) download and install packages and dependencies (currently works with github.com only)");
                System.out.println("    help        list of available Jmm commands");
                System.out.println("    here        set the Jmm workspace to the given directory");
                System.out.println("    list        (N/A) list packages");
                System.out.println("    run         (N/A) compile and run Jmm program (the first file must have the main method)");
                System.out.println("    test        (N/A) test packages");
                System.out.println("    version     print the Jmm version");
                System.out.println("");
                System.exit(0);
            case "here":
                System.exit(this.here(arg));
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

    protected int here(String path) {
        if (path == null || path.isEmpty()) {
            if (!this.setJmmPath(path)) {
                System.out.println("You must run this command in a Jmm workspace");
                return 1;
            }
        } else {
            if (!this.createJmmWorkspace(path)) {
                System.out.println("Could not create Jmm workspace");
                return 1;
            }
        }
        System.out.println("Jmm workspace set to " + System.getProperty("JMMPATH"));
        return 0;
    }

    protected boolean setJmmPath(String path) {
        String jmmPath = this.findJmmSrc(path);
        if (jmmPath == null) {
            return false;
        }
        System.setProperty("JMMPATH", jmmPath);
        return true;
    }

    protected boolean createJmmWorkspace(String path) {
        path = Path.resolve(path);
        if (!Fs.mkdirs(Path.join(path, "bin"))) {
            return false;
        }
        if (!Fs.mkdirs(Path.join(path, "pkg"))) {
            return false;
        }
        if (!Fs.mkdirs(Path.join(path, "src"))) {
            return false;
        }
        System.setProperty("JMMPATH", path);
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
