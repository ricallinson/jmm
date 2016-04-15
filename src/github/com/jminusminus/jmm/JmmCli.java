//
// Copyright 2016, Yahoo Inc.
// Copyrights licensed under the New BSD License.
// See the accompanying LICENSE file for terms.
//

// [![Build Status](https://travis-ci.org/jminusminus/jmm.svg?branch=master)](https://travis-ci.org/jminusminus/jmm)
// ## Stability: 0 - Unstable
// This package contains the CLI for the Jmm tool.
package github.com.jminusminus.jmm;

import github.com.jminusminus.doc.Doc;

public class JmmCli {

    // The tool for managing Jmm source code.
    public static void main(String[] args) {
        String command = "";
        String arg = "";
        // Get the command to execute.
        if (args.length > 0) {
            command = args[0];
        }
        // Get the argument that was given.
        if (args.length > 1) {
            arg = args[1];
        }
        JmmCli jmmCli = new JmmCli();
        // The document server has to start here so it doesn't exit().
        if ("doc".equals(command)) {
            jmmCli.doc(arg);
            return;
        }
        // Pass the command on to see what needs doing.
        jmmCli.info(command, arg);
        jmmCli.action(command, arg);
        jmmCli.execute(command, arg);
        // If we didn't exit then the command was not found.
        System.out.println("jmm: unknown command " + command);
        System.out.println("Run 'go help' for usage.");
        System.exit(1);
    }

    // The version of Jmm.
    protected static final String version = "0.0.2";

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
                System.out.println("    clean       remove object files");
                System.out.println("    doc         show documentation for package or workspace");
                System.out.println("    env         print Jmm environment information");
                System.out.println("    lint        (N/A) run lint check on package sources");
                System.out.println("    get         (N/A) download and install packages and dependencies (currently works with github.com only)");
                System.out.println("    help        list of available Jmm commands");
                System.out.println("    here        set the Jmm workspace to the given directory");
                System.out.println("    list        (N/A) list packages");
                // System.out.println("    run         (N/A) compile and run Jmm program (the first file must have the main method)");
                System.out.println("    test        (N/A) test packages");
                System.out.println("    version     print the Jmm version");
                System.out.println("");
                System.exit(0);
            case "here":
                // $JMMPATH can only be set in the shell.
                // This will output the final path and a script will set the environment variable.
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
                System.exit(this.clean());
            case "list":
                System.exit(this.list(arg));
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
        Tasks t = new Tasks();
        String jmmPath;
        if (path == null || path.isEmpty()) {
            jmmPath = t.getWorkspacePath(path);
        } else {
            jmmPath = t.createWorkspace(path);
        }
        if (jmmPath == null) {
            return 1;
        }
        System.out.println(jmmPath);
        return 0;
    }

    protected int clean() {
        Tasks t = new Tasks();
        if (!t.cleanWorkspace(System.getenv("JMMPATH"))) {
            System.out.println("Could not clean Jmm workspace");
            return 1;
        }
        return 0;
    }

    protected void doc(String jmmClass) {
        Doc doc = new Doc();
        if (jmmClass != null && !jmmClass.isEmpty()) {
            System.out.println("");
            System.out.println(doc.getDoc(jmmClass));
            System.out.println("");
            return;
        }
        doc.startServer(8080);
    }

    protected int list(String path) {
        Tasks t = new Tasks();
        System.out.println(t.listPackages(path));
        return 0;
    }
}
