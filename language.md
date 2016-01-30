# Java-- Language Spec

## Language Restrictions

### abstract

The use of the `abstract` keyword is __NOT__ allowed.

### private

The use of the `private` keyword is __NOT__ allowed.

### throws

The use of the `throws` keyword is __NOT__ allowed.

### annotations

The use of `@annotations` are __NOT__ allowed.

### Inner Classes

The use of inner classes are __NOT__ allowed.

### In-line Conditionals

The use of in-line conditionals is __NOT__ allowed.

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

Each `.java` file can only have __ONE__ class defined in it.

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

References to instance variables and methods of the present object _MUST__ take the form `this.varName` or `this.methodName(args)`.

### StringLiteralEquality

### AvoidStaticImport

### AvoidStarImport

### RedundantImport

### UnusedImports

### Indentation

### OuterTypeFilename

### RedundantModifier

### OuterTypeNumber

### NewlineAtEndOfFile
