# Java--

[![Build Status](https://travis-ci.org/ricallinson/jmm.svg?branch=master)](https://travis-ci.org/ricallinson/jmm)

A joke created after having coffee with a fellow engineer. Java-- is taking Java in a different direction by using highly opinionated choices as to what should or should not be used from the language. Java-- is not a new language, it's just a collection of tools that let you work with Java in a different way.

## Install

Using git, clone this repository into a directory named `~/.jmm`.

    git clone git@github.com:ricallinson/jmm.git ~/.jmm

To activate jmm, you need to source it from your shell:

    source ~/.jmm/jmm.sh

I always add this line to my _~/.bashrc_, _~/.profile_, or _~/.zshrc_ file to have it automatically sourced upon login.

## Usage

Java-- follows the same development patten as [Go](https://golang.org/). There are no externally linked libraries and all the source code for a program is contained in a Java-- workspace. A workspace is a directory that contains a projects code. Generally you'll have one workspace per project which contains the following directories.

	bin
	pkg
	src

Raw `.java` files are placed under the `src` directory with a package name derived from their location in a source control system such as [Github](https://github.com/).

Compiled `.class` files are generated under the `pkg` directory.

Self contained `.jar` files are put in the `bin` directory along with an executable script to run them.

### Getting Started Example

This example creates a Java-- workspace, gets the source code for a module, builds a `.jar` and then executes it.

	mkdir ./jmmtest
	cd ./jmmtest
	jmm here .
	jmm get github.com/ricallinson/jmmexample
	jmm build ./src/github/com/ricallinson/jmmexample
	jmmexample

## Help

### jmm build

Builds a `.jar` from the `.java` files in the given directory. A `.jar` named the same as the directory is created and placed in the `$JMMPATH/bin` directory. An executable to run the `.jar` is also created and placed in the `$JMMPATH/bin` directory. All imports are resolved to modules in the current workspace.

	jmm build ./src/github/com/ricallinson/jmmbuild

### jmm clean

Removes all files in the `$JMMPATH/bin` and `$JMMPATH/pkg` directories.

	jmm clean

### jmm env

Prints the values of all Java-- environment variables.

	jmm env

### jmm get

Get a package from [github.com](https://github.com/) and copy its source into the current workspace.

	jmm get github.com/ricallinson/jmmimporttest

### jmm here

Creates a new Java-- workspace at the given path and exports the `$JMMPATH` as that directory.

	jmm here ./some/dir

Determines if the current directory is part of a Java-- workspace. If it is the `$JMMPATH` is changed to that workspace.

	jmm here

### jmm lint

Checks the give packages or files against the Java-- opinionated style. Note: The opinionated style is not complete.

	jmm lint ./src/github/com/ricallinson/jmmbuild

### jmm run

Provide one or more `.java` files to run. The first file must have the main method. A `.jar` named the same as the first class files directory is created and placed in the `$JMMPATH/bin` directory. Note: this will overwrite an existing `.jar` if it has the same name.

	jmm run ./src/github/com/ricallinson/jmmrun/TestClass.java ./src/github/com/ricallinson/jmmrun/OtherClass.java

### jmm version

Prints the version of jmm in use.

	jmm version

## Legal Packages

This is the complete list of "legal" Java-- packages allowed from the [Java 8](https://docs.oracle.com/javase/8/docs/api/overview-summary.html) package list.

* [java.io.BufferedReader](https://docs.oracle.com/javase/8/docs/api/java/io/BufferedReader.html)
* [java.io.InputStreamReader](https://docs.oracle.com/javase/8/docs/api/java/io/InputStreamReader.html)
* [java.io.IOException](https://docs.oracle.com/javase/8/docs/api/java/io/IOException.html)
* [java.io.PrintWriter](https://docs.oracle.com/javase/8/docs/api/java/io/PrintWriter.html)
* [java.net.ServerSocket](https://docs.oracle.com/javase/8/docs/api/java/net/ServerSocket.html)
* [java.net.Socket](https://docs.oracle.com/javase/8/docs/api/java/net/Socket.html)
* [java.time](https://docs.oracle.com/javase/8/docs/api/java/time/package-summary.html)

## Run Tests

Tests to validate everything is working as expected.

	./test/run.sh
