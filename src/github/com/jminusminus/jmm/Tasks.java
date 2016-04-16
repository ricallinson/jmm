//
// Copyright 2016, Yahoo Inc.
// Copyrights licensed under the New BSD License.
// See the accompanying LICENSE file for terms.
//

// ## Stability: 0 - Unstable
// This package contains tasks performed by the JmmCli.
package github.com.jminusminus.jmm;

import github.com.jminusminus.core.Arrays;
import github.com.jminusminus.core.Path;
import github.com.jminusminus.core.Fs;

public class Tasks {

    public String getWorkspacePath(String path) {
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

    public String createWorkspace(String path) {
        path = Path.resolve(path);
        if (!Fs.mkdirs(Path.join(path, "bin"))) {
            return null;
        }
        if (!Fs.mkdirs(Path.join(path, "pkg"))) {
            return null;
        }
        if (!Fs.mkdirs(Path.join(path, "src"))) {
            return null;
        }
        return path;
    }

    public boolean cleanWorkspace(String path) {
        path = Path.resolve(path);
        if (path == null || path.isEmpty()) {
            return false;
        }
        if (!Fs.rmdirr(Path.join(path, "bin")) || !Fs.mkdirs(Path.join(path, "bin"))) {
            return false;
        }
        if (!Fs.rmdirr(Path.join(path, "pkg")) || !Fs.mkdirs(Path.join(path, "pkg"))) {
            return false;
        }
        return true;
    }

    public String[] listPackages(String path) {
        path = Path.resolve(path);
        String[] files = Fs.readdirr(path);
        String[] javaFiles = new String[0];
        for (String f : files) {
            if (f.endsWith(".java")) {
                javaFiles = Arrays.append(javaFiles, f);
            }
        }
        return this.findPackages(javaFiles);
    }

    protected String[] findPackages(String[] files) {
        String[] packages = new String[0];
        for (String f : files) {
            String txt = new String(Fs.readFile(f));
            // Find package line in txt.
            int start = txt.indexOf("package") + 8;
            int end = txt.indexOf(";", start);
            String importStr = txt.substring(start, end);
            // Get the package name from the import string.
            // github.com.org.repo
            String packageStr = String.join(".", Arrays.slice(importStr.split("\\."), 0, 4));
            if (!packageStr.isEmpty()) {
                packages = Arrays.append(packages, packageStr);
            }
        }
        return packages;
    }
}
