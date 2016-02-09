# Jmm Language Spec

### What's Different?

The main departure from standard Java development is that all source code is contained in one __workspace__ directory. There are no extra class paths, no external `.jar` files and no version conflicts. To achieve this all packages are relative to a __workspace__ directory. For example the Java package `github.com.jminusminus.jmmexample` would be found in the directory`$JMMPATH/github/com/jminusminus/jmmexample` where `$JMMPATH` is the __workspace__ directory.

Maven, Gradle, Ant etc will __NOT__ work with Jmm by design. Like [Go](https://golang.org/) there is no packaging system as such. All Java packages are pulled from source control systems like [github.com](https://github.com/) as source code. All dependences for a program must be in a projects workspace are compiled into one `.jar`. Each project has it's own workspace with it's own dependencies. The dependencies are defined in code as `import` statements so no external dependency management system is required.

## Language Basics

### One Definition a File

There can only be __ONE__ class or interface defined per `.java` file and the class or interface name __MUST__ be the same as the file name.

### Package Declaration

All `.java` files __MUST__ have a package declaration and the package name __MUST__ match the directory path to the source file relative to `$JMMPATH`.

### This

References to instance variables and methods of the present object __MUST__ take the form `this.varName` or `this.methodName(args)`.

### abstract

The use of the `abstract` keyword is __NOT__ allowed. In its place you either define an `interface` or a `concrete` class.

### private

The use of the `private` keyword is __NOT__ allowed. In its place use `protected`.

### throws

The use of the `throws` keyword is __NOT__ allowed. There is no alternative, errors must be caught at the point they are thrown.

### annotations

The use of `@annotations` are __NOT__ allowed. There is no alternative.

### Generics

The use of generics is __NOT__ allowed. There is no alternative.

### Inner Classes

The use of inner classes is __NOT__ allowed. Classes must be defined in their own files.

### In-line Conditionals

The use of in-line conditionals is __NOT__ allowed. Use `if` `else` in their place.

### Interface

An interface __MUST__ contain methods.

## Style

### Cyclomatic Complexity

Cyclomatic complexity can be no higher than 8. Methods that have a higher complexity value must be broken down into smaller methods.

### Catch Blocks

Catch blocks are __NOT__ allowed to trap the following `java.lang.Exception`, `java.lang.Throwable`, `java.lang.RuntimeException`.

### Throw

Declaring methods that throw either `java.lang.Throwable`, `java.lang.Error` or `java.lang.RuntimeException` is __NOT__ allowed.

### No Nested Blocks

Nested blocks are __NOT__ allowed. There is no alternative.

### No Empty Blocks

Empty blocks are __NOT__ allowed.

### No Empty Statements

Empty Statements are __NOT__ allowed.

### Static Import

Static import statements are __NOT__ allowed. There is no alternative.

### Star Import

Star import statements are __NOT__ allowed. There is no alternative.

### Arrays with Trailing Comma

Array initialization __MUST__ have a trailing comma.

### String Equals

Calling the `equals()` method on String literals is __REQUIRED__ for comparisons.

### Inner Assignment

Inner assignment is __NOT__ allowed.

### Multiple Variable Declarations

Multiple variable declarations are __NOT__ allowed.

### One Statement Per Line

The can be only __ONE__ statement per line.

### Overloaded Methods

Overloaded methods __MUST__ be defined together.

### Redundant Import

Imports from the same package or `java.lang` are not __NOT__ allowed.

### Unused Imports

Imports that are unused are __NOT__ allowed.

### Indentation

Indentation __MUST__ be four spaces.

### Redundant Modifier

Modifiers that are redundant are __NOT__ allowed.

### End of File

All files __MUST__ end with a new line.
