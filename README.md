# Jmm

[![Build Status](https://travis-ci.org/jminusminus/jmm.svg?branch=master)](https://travis-ci.org/jminusminus/jmm)

__UNSTABLE: This project is currently under development and will change.__

This project started life as a joke after having coffee with a fellow engineer. Jmm is taking Java in a different direction by using highly opinionated choices as to what should or should not be used from the language. Jmm is not a new language, it's just a collection of tools and libraries that let you work with Java in a different way. See more information about the [Jmm Language](https://github.com/jminusminus/jmm/blob/master/language.md) choices.

## Install

Using git, clone this repository into a directory named `~/.jmm`.

    git clone git@github.com:jminusminus/jmm.git ~/.jmm

To activate jmm, you need to source it from your shell:

    source ~/.jmm/jmm.sh

I always add this line to my _~/.bashrc_, _~/.profile_, or _~/.zshrc_ file to have it automatically sourced upon login.

## Usage

Jmm follows the same development patten as [Go](https://golang.org/). There are no externally linked libraries and all the source code for a program is contained in a Jmm workspace. A workspace is a directory that contains a projects code. Generally you'll have one workspace per project which contains the following directories.

    bin
    pkg
    src

Raw `.java` files are placed under the `src` directory with a package name derived from their location in a source control system such as [Github](https://github.com/).

Compiled `.class` files are generated under the `pkg` directory.

Self contained `.jar` files are put in the `bin` directory along with an executable script to run them.

### Getting Started Example

This example creates a Jmm workspace, gets the source code for a package, installs a `.jar` and then executes it.

    mkdir ./jmmtest
    cd ./jmmtest
    jmm here .
    jmm get github.com/jminusminus/simplebdd
    jmm get github.com/jminusminus/jmmexample
    jmm test ./src/github/com/jminusminus/jmmexample
    jmm install ./src/github/com/jminusminus/jmmexample
    jmmexample

## Help

### jmm clean

Removes all files in the `$JMMPATH/bin` and `$JMMPATH/pkg` directories.

    jmm clean

### jmm doc

Prints [Markdown](https://daringfireball.net/projects/markdown/) documentation for a given Jmm class `doc [jmm_classpath]`.

    jmm doc github.com.jminusminus.doc.Doc
    // Prints the Markdown for class "github.com.jminusminus.doc.Doc" to stdout.

Starts a web server using all documentation in the current Jmm workspace.

    jmm doc
    // Server started on port 8080, using 4 cores and 8 threads...
    // Document server started at http://localhost:8080/
    // Serving documentation from /Users/allinson/Java/jmmworkspace

### jmm env

Prints the values of all Jmm environment variables.

    jmm env

### jmm get

Get a package from [github.com](https://github.com/) and copy its source into the current workspace.

    jmm get github.com/jminusminus/jmmimporttest

### jmm here

Creates a new Jmm workspace at the given path and exports the `$JMMPATH` as that directory.

    jmm here ./some/dir

Determines if the current directory is part of a Jmm workspace. If it is the `$JMMPATH` is changed to that workspace.

    jmm here

### jmm install

Builds a `.jar` from the `.java` files in the given directory. A `.jar` named the same as the directory is created and placed in the `$JMMPATH/bin` directory. An executable to run the `.jar` is also created and placed in the `$JMMPATH/bin` directory. All imports are resolved to packages in the current workspace.

    jmm install ./src/github/com/jminusminus/jmminstall

The following will install the current working directory.

    jmm install

### jmm lint

Checks the given packages or files against the Jmm opinionated style. Note: The opinionated style is not complete yet.

    jmm lint ./src/github/com/jminusminus/jmminstall

### jmm list

List all packages under a given directory.

    jmm list ./src/github/com/jminusminus/jmminstall

The following will list packages in the current working directory.

    jmm list

### run-script

Execute a script in a packages `scripts` folder. From within a Jmm workspace;

    jmm run-script path/to/package foo

Ot if you are i the package directory;

    jmm run-script foo

Jmm supports automatic execution for the following scripts:

* preinstall: Run BEFORE the package is installed.
* postinstall: Run AFTER the package is installed.
* pretest: Run BEFORE the package is tested.
* posttest: Run AFTER the package is tested.

### jmm test

Tests in Jmm are identified by the postfix `_test` on a `.java` file. The class must have a main method and be in the same directory as the code it's testing or import the code it's testing. Test files are executed one at time in isolation from each other. All test files are excluded from a install.

    jmm test ./src/github/com/jminusminus/jmmtest/TestClass_test.java

Directories are tested recursively to allow packages to be tested with one command.

    jmm test ./src/github/com/jminusminus/jmmtest

Coverage reports can be generated when running tests. To instrument a file for coverage the `Xxx.java` file must have a corresponding `Xxx_test.java` file.

Generating a coverage report from a test file.

    jmm test cover ./src/github/com/jminusminus/jmmtest/TestClass_test.java
    open ./coverage/index.html

Generating a coverage report from a directory and recursively all sub directories.

    jmm test cover ./src/github/com/jminusminus/jmmtest
    open ./coverage/index.html

### jmm version

Prints the version of jmm in use.

    jmm version

## Run Tests

Tests to validate everything is working as expected.

    ./test/run.sh
