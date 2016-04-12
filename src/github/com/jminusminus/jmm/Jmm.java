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
        switch (command) {
            default:
                System.out.println("jmm: unknown command " + command);
                System.out.println("Run 'go help' for usage.");
                System.exit(1);
        }
    }
}
