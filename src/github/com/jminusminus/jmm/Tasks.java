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

    public boolean setJmmPath(String path) {
        String jmmPath = this.findJmmSrc(path);
        if (jmmPath == null) {
            return false;
        }
        System.setProperty("JMMPATH", jmmPath);
        return true;
    }

    public boolean createJmmWorkspace(String path) {
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

    public boolean cleanWorkspace() {
        return false;
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
