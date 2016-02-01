//
// Copyright 2016, Yahoo Inc.
// Copyrights licensed under the New BSD License.
// See the accompanying LICENSE file for terms.
//

package github.com.javaminusminus.jmmrecursiveimport;

import github.com.javaminusminus.jmmrecursiveimport.sub.SecondClass;

public class FirstClass {  
    public static void main(String args[]) {
    	SecondClass c = new SecondClass();
    	System.out.println(c.msg());
    }
}
