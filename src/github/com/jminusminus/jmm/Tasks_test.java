//
// Copyright 2016, Yahoo Inc.
// Copyrights licensed under the New BSD License.
// See the accompanying LICENSE file for terms.
//

package github.com.jminusminus.jmm;

import github.com.jminusminus.core.Fs;
import github.com.jminusminus.simplebdd.Test;

public class Tasks_test extends Test {
    public static void main(String[] args) {
        Tasks_test test = new Tasks_test();
        test.run();
    }

    protected Tasks t;

    public void beforeEach() {
    	this.t = new Tasks();
    }

    public void test_new_Tasks() {
        this.should("return an instance of Tasks");
        this.assertEqual("github.com.jminusminus.jmm.Tasks", this.t.getClass().getName());
    }

    public void test_getWorkspacePath() {
        this.should("return a path to the workspace");
        String p = this.t.getWorkspacePath("./fixtures/workspace/src/github/com/org/somepackage");
        this.assertEqual(System.getProperty("user.dir") + "/fixtures/workspace", p);
    }

    public void test_getWorkspacePath_null() {
        this.should("return null as there is no workspace");
        String p = this.t.getWorkspacePath("/dev/null");
        this.assertEqual(true, p == null);
    }

    public void test_createWorkspace() {
        this.should("return a path to the new workspace");
        String p = this.t.createWorkspace("./fixtures/tmp");
        this.assertEqual(System.getProperty("user.dir") + "/fixtures/tmp", p);
        Fs.rmdirr("./fixtures/tmp");
    }

    public void test_cleanWorkspace() {
        this.should("remove files in bin and pkg directories");
        String p = this.t.createWorkspace("./fixtures/tmp");
        Fs.writeFile("./fixtures/tmp/bin/foo", "foo");
        Fs.writeFile("./fixtures/tmp/pkg/bar", "bar");
        this.assertEqual(true, this.t.cleanWorkspace(p));
        this.assertEqual(false, Fs.access("./fixtures/tmp/bin/foo"));
        this.assertEqual(false, Fs.access("./fixtures/tmp/pkg/bar"));
        Fs.rmdirr("./fixtures/tmp");
    }

    public void test_listPackages() {
        this.should("return a list of all the packages in the workspace");
        String[] p = this.t.listPackages(System.getenv("JMMPATH") + "/examples");
        this.assertEqual(10, p.length);
    }
}
