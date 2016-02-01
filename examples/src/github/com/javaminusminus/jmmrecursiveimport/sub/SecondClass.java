//
// Copyright 2016, Yahoo Inc.
// Copyrights licensed under the New BSD License.
// See the accompanying LICENSE file for terms.
//

package github.com.javaminusminus.jmmrecursiveimport.sub;

import github.com.javaminusminus.jmmrecursiveimport.FirstClass;

public class SecondClass {  
    
    public SecondClass() {
    	new FirstClass();
    }

    public String msg() {
    	return "Hello world";
    }
}
