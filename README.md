# Java--

A joke created after having coffee with a fellow engineer. Java-- is taking Java in a different direction by using highly opinionated choices as to what should or should not be used from the core language. Java-- is not a new language, it's just a collection of tools that let you work with Java in a different way.

## Manual Install

For manual install create a folder somewhere in your filesystem with the jmm.sh file inside it. I put mine in a folder called `~/.jmm`.

Or if you have git installed, then just clone it:

    git clone git@github.com:ricallinson/jmm.git ~/.jmm

To activate jmm, you need to source it from your shell:

    source ~/.gwm/gwm.sh

I always add this line to my _~/.bashrc_, _~/.profile_, or _~/.zshrc_ file to have it automatically sourced upon login.

## Usage

### jmm build

Builds a `.jar` from the `.java` files in the given directory. A `.jar` named the same as the directory is created and placed in the `bin` directory. All imports are resolved to modules in the current workspace.

	jmm build ./src/github/com/ricallinson/jmmbuild

### jmm clean

Removes all files in the `bin` and `pkg` directories.

	jmm clean

### jmm env

Prints the values of all Java-- environment variables.

	jmm env

### jmm here

Creates a new Java-- workspace at the given path and exports the JMMPATH as that directory.

	jmm here ./some/dir

Determine if the current directory is part of a Java-- workspace. If it is export the JMMPATH as that directory.

	jmm here

### jmm run

Provide a one or more `.java` files to run. The first file must have the main method. A `.jar` named the same as the first class files directory is created and placed in the `bin` directory.

	jmm run ./src/github/com/ricallinson/jmmrun/TestClass.java ./src/github/com/ricallinson/jmmrun/OtherClass.java

### jmm version

Prints the version of jmm in use.

	jmm version