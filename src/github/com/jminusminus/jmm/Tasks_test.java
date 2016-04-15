//
// Copyright 2016, Yahoo Inc.
// Copyrights licensed under the New BSD License.
// See the accompanying LICENSE file for terms.
//

package github.com.jminusminus.jmm;

import github.com.jminusminus.simplebdd.Test;

public class Tasks_test extends Test {
    public static void main(String[] args) {
        Tasks_test test = new Tasks_test();
        test.run();
    }

    public void test_new_Tasks() {
        this.should("return an instance of Tasks");
        Tasks t = new Tasks();
        this.assertEqual("github.com.jminusminus.jmm.Tasks", t.getClass().getName());
    }
}
