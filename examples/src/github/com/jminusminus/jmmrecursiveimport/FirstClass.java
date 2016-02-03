//
// Copyright 2016, Yahoo Inc.
// Copyrights licensed under the New BSD License.
// See the accompanying LICENSE file for terms.
//

package github.com.jminusminus.jmmrecursiveimport;

import github.com.jminusminus.jmmrecursiveimport.sub.SecondClass;

public class FirstClass {  
    public static void main(String args[]) {
    	SecondClass c = new SecondClass();
    	System.out.println(c.msg());
    }
}
