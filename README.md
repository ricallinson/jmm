# Java--

[![Build Status](https://travis-ci.org/ricallinson/jmm.svg?branch=master)](https://travis-ci.org/ricallinson/jmm)

A joke created after having coffee with a fellow engineer. Java-- is taking Java in a different direction by using highly opinionated choices as to what should or should not be used from the language. Java-- is not a new language, it's just a collection of tools that let you work with Java in a different way.

## Manual Install

For manual install create a folder somewhere in your filesystem with the jmm.sh file inside it. I put mine in a folder called `~/.jmm`.

Or if you have git installed, then just clone it:

    git clone git@github.com:ricallinson/jmm.git ~/.jmm

To activate jmm, you need to source it from your shell:

    source ~/.gwm/gwm.sh

I always add this line to my _~/.bashrc_, _~/.profile_, or _~/.zshrc_ file to have it automatically sourced upon login.

## Run Tests

	./test/run.sh

## Usage

Java-- follows the same development patten as [Go](https://golang.org/).

	bin
	pkg
	src

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

Determine if the current directory is part of a Java-- workspace. If it is exports the `$JMMPATH` as that directory.

	jmm here

### jmm run

Provide one or more `.java` files to run. The first file must have the main method. A `.jar` named the same as the first class files directory is created and placed in the `$JMMPATH/bin` directory.

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
