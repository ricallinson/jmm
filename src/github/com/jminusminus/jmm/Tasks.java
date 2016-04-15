//
// Copyright 2016, Yahoo Inc.
// Copyrights licensed under the New BSD License.
// See the accompanying LICENSE file for terms.
//

// ## Stability: 0 - Unstable
// This package contains tasks performed by the JmmCli.
package github.com.jminusminus.jmm;

import github.com.jminusminus.core.Path;
import github.com.jminusminus.core.Fs;

public class Tasks {

    public boolean setWorkspacePath(String path) {
        String jmmPath = this.findWorkspaceSrc(path);
        if (jmmPath == null) {
            return false;
        }
        try {
            java.lang.Runtime.getRuntime().exec("/bin/bash export JMMPATH=" + jmmPath);
        } catch (Exception e) {
            System.out.println(e);
            return false;
        }
        return true;
    }

    public boolean createWorkspace(String path) {
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
        try {
            java.lang.Runtime.getRuntime().exec("/bin/bash export JMMPATH=" + path);
        } catch (Exception e) {
            System.out.println(e);
            return false;
        }
        return true;
    }

    public boolean cleanWorkspace() {
        String path = System.getenv("JMMPATH");
        if (path == null || path.isEmpty()) {
            return false;
        }
        if (!Fs.rmdirr(Path.join(path, "bin"))) {
            return false;
        }
        if (!Fs.rmdirr(Path.join(path, "pkg"))) {
            return false;
        }
        return true;
    }

    protected String findWorkspaceSrc(String path) {
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
