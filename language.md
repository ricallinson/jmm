# Jmm Language Spec

## Language Restrictions

### abstract

The use of the `abstract` keyword is __NOT__ allowed.

### private

The use of the `private` keyword is __NOT__ allowed.

### throws

The use of the `throws` keyword is __NOT__ allowed.

### annotations

The use of `@annotations` are __NOT__ allowed.

### Generics

The use of generics is __NOT__ allowed.

### Inner Classes

The use of inner classes are __NOT__ allowed.

### In-line Conditionals

The use of in-line conditionals is __NOT__ allowed.

### Static Import

Static import statements are __NOT__ allowed.

### Star Import

Star import statements are __NOT__ allowed.

## Style

### Cyclomatic Complexity

Cyclomatic Complexity can be no higher than 8.

### No Nested Blocks

Nested blocks are __NOT__ allowed.

### Empty Block

Empty blocks are __NOT__ allowed.

### Interface

An interface __MUST__ contain methods.

### One Class

There can only be __ONE__ class or interface defined per `.java` file.

### ArrayTrailingComma

Array initialization __MUST__ have a trailing comma.

### Empty Statement

Empty Statements are __NOT__ allowed.

### String Equals

Calling the `equals()` method on String literals is __REQUIRED__ for comparasons.

### Catch Blocks

Catch blocks are __NOT__ allowed to trap the following `java.lang.Exception`, `java.lang.Throwable`, `java.lang.RuntimeException`.

### Throw

Declaring that a methods that throw either `java.lang.Throwable`, `java.lang.Error` or `java.lang.RuntimeException` is __NOT__ allowed.

### Inner Assignment

InnerAssignment is __NOT__ allowed.

### Multiple Variable Declarations

Multiple variable declarations are __NOT__ allowed.

### One Statement Per Line

The can be only __ONE__ statment per line.

### Overloaded Methods

Overloaded methods __MUST__ be defined together.

### PackageDeclaration

All `.java` files __MUST__ have a package declaration and the package name __MUST__ match the directory name for the source file.

### This

References to instance variables and methods of the present object __MUST__ take the form `this.varName` or `this.methodName(args)`.

### Redundant Import

Imports from the same package or `java.lang` are not __NOT__ allowed.

### UnusedImports

Imports that are unused are __NOT__ allowed.

### Indentation

Indentation __MUST__ be four spaces.

### OuterTypeFilename

The class or interface name __MUST__ be the same as the file name.

### RedundantModifier

Modifiers that are redundant are __NOT__ allowed.

### End of File

All files __MUST__ end with a new line.

## Legal Packages

__Note: All package maybe blocked and require direct referencing if they are to be used.__

This is the complete list of "legal" Jmm packages allowed from the [Java 8](https://docs.oracle.com/javase/8/docs/api/overview-summary.html) package list. Note: The opinionated package list is not complete yet.

* [java.io.IOException](https://docs.oracle.com/javase/8/docs/api/java/io/IOException.html)
* [java.io.InputStream](https://docs.oracle.com/javase/8/docs/api/java/io/InputStream.html)
* [java.io.OutputStream](https://docs.oracle.com/javase/8/docs/api/java/io/OutputStream.html)
* [java.math](https://docs.oracle.com/javase/8/docs/api/java/math/MathContext.html)
* [java.net.ServerSocket](https://docs.oracle.com/javase/8/docs/api/java/net/ServerSocket.html)
* [java.net.Socket](https://docs.oracle.com/javase/8/docs/api/java/net/Socket.html)
* [java.util.regex.Pattern](https://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html)
* [java.util.regex.Matcher](https://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html)
