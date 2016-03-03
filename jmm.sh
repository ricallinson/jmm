# 
# Copyright 2016, Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.
#

#
# Lint check by http://www.shellcheck.net/
#

{ # this ensures the entire script is downloaded 

#
# Constants
#

COBERTURA_DIR="$JMMHOME/vendor/cobertura"
COBERTURA=$COBERTURA_DIR/cobertura-2.1.1.jar:$COBERTURA_DIR/lib/asm-5.0.1.jar:$COBERTURA_DIR/lib/asm-analysis-5.0.1.jar:$COBERTURA_DIR/lib/asm-tree-5.0.1.jar:$COBERTURA_DIR/lib/asm-commons-5.0.1.jar:$COBERTURA_DIR/lib/asm-util-5.0.1.jar:$COBERTURA_DIR/lib/commons-lang3-3.3.2.jar:$COBERTURA_DIR/lib/slf4j-api-1.7.5.jar:$COBERTURA_DIR/lib/logback-core-1.0.13.jar:$COBERTURA_DIR/lib/logback-classic-1.0.13.jar:$COBERTURA_DIR/lib/oro-2.0.8.jar
JMMHOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export JMMHOME=$JMMHOME
export JMMVERSION="0.0.1"

#
# Helper functions
#

jmm_debug() {
    echo "$1" >> "$JMMPATH/debug.txt"
    return 0
}

# @String $1 - Directory path
# @return "dir/path"
# Returns an absolute path from the give input path.
jmm_helper_path_resolve() {
    if [ "${1:0:1}" = "." ]; then # if starts with a .
        echo "$(pwd)${1:1}"
    elif [ "${1:0:1}" = "~" ]; then # if starts with a ~
        echo "$HOME${1:1}"
    elif [ "${1:0:1}" = "/" ]; then # if starts with a /
        echo "$1"
    else
        echo "$(pwd)/$1"
    fi
    return 0
}

# @String $1 - Directory path
# @return "name"
# Returns the jar name for a given directory path.
jmm_helper_get_jar_name() {
    local base
    base=$(dirname "$1")
    echo "${base##*/}"
    return 0
}

# @String $1 - Directory or file path
# @return "dir/path"
# Returns a list of class files.
jmm_helper_get_class_files_for_coverage() {
    local files
    local absPath
    local jmmSize
    local absSize
    local absPath
    absPath=$(jmm_helper_path_resolve "$1")
    if [[ -d "$absPath" ]]; then
        # if it's a directory recursively find all test files and execute them one at a time.
        for file in $absPath/*; do
            files="$files $(jmm_helper_get_class_files_for_coverage $file)"
        done
    elif [[ -f "$absPath" ]] && [[ "$absPath" == *"_test.java" ]]; then
        jmmSize=${#JMMPATH}+5 # remove $JMMPATH/src/
        absSize=$((${#absPath}-10)) # remove _test.java
        absPath=${absPath:0:$absSize} # $JMMPATH/src/repo/file
        files="$JMMPATH/pkg/${absPath:$jmmSize}.class" # repo/file
    fi
    echo $files
    return 0
}

# @String $1 - Class path to a .java file
# @return "dir/path"
# Returns a class path from a given file path.
jmm_helper_get_class_path() {
    local absPath
    local jmmSize
    local absSize
    local absPath
    absPath=$(jmm_helper_path_resolve "$1") # $JMMPATH/src/repo/file.java
    jmmSize=${#JMMPATH}+5 # remove $JMMPATH/src/
    absSize=$((${#absPath}-5)) # remove .java
    absPath=${absPath:0:$absSize} # $JMMPATH/src/repo/file
    echo "${absPath:$jmmSize}" # repo/file
    return 0
}

# @String $1 - Directory path
# @String $2 - Directory name
# @return "dir/path"
# Searches up through the directories until it finds directory name a match for the given input string.
jmm_helper_find_up() {
    local path
    path=$1
    while [ "$path" != "" ] && [ ! -d "$path/$2" ]; do
        path=${path%/*}
    done
    echo "$path"
    return 0
}

# @String $1 - Directory path
# @return "dir/path" || ""
# Searches up through the directories until it finds a directory named 'src'.
jmm_helper_find_src() {
    local dir
    dir="$(jmm_helper_find_up "$1" 'src')"
    if [ -e "$dir/src" ]; then
        echo "$dir/src"
    fi
    return 0
}

# @String $1 - Directory path
# @return "/abs/dir/path" || ""
# Resolves the given directory if it exists.
jmm_helper_resolve() {
    cd "$1" 2>/dev/null || return $?  # cd to desired directory; if fail, quell any error messages but return exit status
    pwd -P # output full, link-resolved path
    return 0
}

# @String $1 - File path to a .java with the main method for the .jar
# @String $@ - List of .java files to put in the .jar
# @return "path/to.jar" || "compile error"
jmm_helper_compile() {
    local classPath
    local classFiles
    local classPaths
    mkdir -p "$JMMPATH/bin"
    mkdir -p "$JMMPATH/pkg"
    classPath=$(jmm_helper_get_class_path "$1")
    classPath=${classPath//[\/]/\.}
    classFiles=()
    classPaths=""
    for file; do
        if [[ $file != "_test.java"* ]]; then
            classFiles+=("$(jmm_helper_path_resolve "$file")")
            classPaths="$classPaths -C $JMMPATH/pkg $(jmm_helper_get_class_path $file).class"
        fi
    done
    javac -d "$JMMPATH/pkg" "${classFiles[@]}"
    if [[ $? -eq 1 ]]; then
        echo "javac -d $JMMPATH/pkg ${classFiles[@]}"
        return 1
    fi
    echo "$classPath" $classPaths
}

# @String $1 - File path to a .java with the main method for the .jar
# @String $@ - List of .java files to put in the .jar
# @return "path/to.jar" || "compile error"
jmm_helper_build_jar() {
    local jarName
    jarName=$(jmm_helper_get_jar_name "$1")
    jar cfe "$JMMPATH/bin/$jarName.jar" $(jmm_helper_compile "$@")
    echo "$JMMPATH/bin/$jarName.jar"
    return 0
}

# @String $1 - Directory path
# @return "list of .java file paths"
# Looks at the given directory path and returns all .java files in it.
jmm_helper_find_java_files() {
    local files
    files=""
    for file in $(find "$1" -name "*.java"); do
        imports=$(jmm_helper_resolve_imports "$file")
        files="$files $file $imports"
    done
    echo "$files"
    return 0
}

# Creates a new imported.txt file.
jmm_start_import_check() {
    echo "" > "$JMMPATH/imported.txt"
    return 0
}

# Removes an imported.txt file.
jmm_end_import_check() {
    rm "$JMMPATH/imported.txt" > /dev/null
    return 0
}

# @String $1 - Java import package name
# @return "skip" || "import"
# Checks if the given package name has already been imported.
jmm_helper_import_check() {
    local imported
    read -r -a imported < "$JMMPATH/imported.txt"
    for import in "${imported[@]}"; do
        if [[ "$1" == "$import" ]]; then
            echo "skip"
            return 1
        fi
    done
    imported+=("$1")
    echo "${imported[@]}" > "$JMMPATH/imported.txt"
    echo "import"
    return 0
}

# @String $1 - File path to a .java file
# @return "list of .java file paths"
# Looks at the given .java file imports and resolves them to file paths.
jmm_helper_resolve_imports() {
    local files
    local import
    files=""
    for import in $(grep ^import "$1"); do
        if [[ "$import" != "import" ]] && [[ -n "$import" ]] && [[ "$(jmm_helper_import_check "$import")" == "import" ]]; then
            import=${import//[;]/}
            import=${import//[\.]/\/}
            import=$(dirname "$import")
            newFiles=$(jmm_helper_find_java_files "$JMMPATH/src/$import")
            files="$files $newFiles"
        fi
    done
    echo "$files"
    return 0
}

# @String $1 - Directory or path to test.
# @return number of failed tests
# Runs the given test file and returns the number of failures.
jmm_test_run() {
    local failures
    local testClass
    local buf
    local path=$1
    if [[ -d "$path" ]]; then
        # if it's a directory recursively find all test files and execute them one at a time.
        path="${path%/}"
        for dir in $path/*; do
            jmm_test_run "$dir"
            failures=$(($failures + $?))
        done
    elif [[ -f "$path" ]] && [[ "$path" == *"_test.java" ]]; then
        # if the file ends with "_test.java" then run it.
        testClass=$(jmm_helper_get_class_path "$path")
        testClass=${testClass//[\/]/\.}
        java -cp $JMMPATH/pkg $testClass
        failures=$(($failures + $?))
    fi
    return $(($failures))
}

# @String $1 - Directory or path to test.
# @return number of failed tests
# Runs the given test directory or path, generates coverage report and returns the number of failures.
jmm_test_run_coverage() {
    local failures
    local testClass
    local buf
    local path=$1
    if [[ -d "$path" ]]; then
        # if it's a directory recursively find all test files and execute them one at a time.
        path="${path%/}"
        for dir in $path/*; do
            jmm_test_run_coverage "$dir"
            failures=$(($failures + $?))
        done
    elif [[ -f "$path" ]] && [[ "$path" == *"_test.java" ]]; then
        # if the file ends with "_test.java" then run it.
        testClass=$(jmm_helper_get_class_path "$path")
        testClass=${testClass//[\/]/\.}
        java -cp $COBERTURA:$JMMPATH/pkg \
            -Dnet.sourceforge.cobertura.datafile=$JMMPATH/cobertura.ser \
            $testClass
        failures=$(($failures + $?))
    fi
    return $(($failures))
}

#
# Commands
#

# @String $1 - Directory path
# @return "compile error" || ""
# Compiles the files in the given directory resolving all packages and places final class files in $JMMPATH/pkg.
jmm_helper_resolve_dir_for_compile() {
    local path
    local mains
    local imports
    local files
    local jar
    local exe
    local path
    path="$1"
    if [[ -z "$path" ]]; then
        path="."
    fi
    jmm_lint $path
    if [[ $? -gt 0 ]]; then
        return 1
    fi
    path=$(jmm_helper_path_resolve "${path%/}")
    mains=""
    files=""
    jmm_start_import_check
    for file in $(find "$path" -name '*.java'); do
        if [ "$mains" = "" ] && grep -q "public static void main(" "$file"; then
            imports=$(jmm_helper_resolve_imports "$file")
            mains="$file $imports"
        else
            imports=$(jmm_helper_resolve_imports "$file")
            files="$files $file $imports"
        fi
    done
    jmm_end_import_check
    echo "$mains $files"
}

# @String $1 - Directory path
# @return "compile error" || ""
# Compiles the files in the given directory resolving all packages and places final jar in $JMMPATH/bin.
jmm_install() {
    local jar
    jar=$(jmm_helper_build_jar $(jmm_helper_resolve_dir_for_compile $1))
    if [[ $? -eq 1 ]]; then
        echo $jar
        return 1
    fi
    exe=${jar:0:${#jar}-4}
    echo "java -jar $jar" > "$exe"
    chmod +x "$exe"
    return 0
}

# Deletes all files in $JMMPATH/bin and $JMMPATH/pkg
jmm_clean() {
    rm -rf "${JMMPATH:?}/bin/"*
    rm -rf "$JMMPATH/pkg/"*
    return 0
}

# Prints the exported variables used by Jmm.
jmm_env() {
    echo "JMMPATH=\"$JMMPATH\""
    echo "JMMHOME=\"$JMMHOME\""
    echo "JAVA_HOME=\"$JAVA_HOME\""
    return 0
}

# @String $@ - Package names
# Downloads the given github.com package(s) and unpacks them into $JMMPATH/src.
# currently only works with github.com zip files.
jmm_get() {
    local packageDir
    local packageName
    for package; do
        curl -s -o "$JMMPATH/master.zip" -L "$package/archive/master.zip"
        if grep -q "error" "$JMMPATH/master.zip"; then
            rm "$JMMPATH/master.zip"
            echo "Package '$package' not found"
            return 1
        fi
        packageDir=${package//[\.]/\/}
        rm -rf "$JMMPATH/src/$packageDir"
        mkdir -p "$JMMPATH/src/$packageDir"
        unzip -qq "$JMMPATH/master.zip" -d "$JMMPATH/src/$packageDir"
        packageName="$(basename $package)"
        mv "$JMMPATH/src/$packageDir/$packageName-master/"* "$JMMPATH/src/$packageDir/$packageName-master/.."
        mv "$JMMPATH/src/$packageDir/$packageName-master/".[^.]* "$JMMPATH/src/$packageDir/$packageName-master/.."
        rm -r "$JMMPATH/src/$packageDir/$packageName-master"
        rm "$JMMPATH/master.zip"
    done
    return 0
}

# Prints the available commands.
jmm_help() {
    echo "Jmm is a tool for managing Jmm source code."
    echo
    echo "Jmm"
    echo
    echo "Usage:"
    echo
    echo "    jmm command [arguments]"
    echo
    echo "The commands are:"
    echo
    echo "    install       compile packages and dependencies"
    echo "    clean       remove object files"
    echo "    doc         (not implemented) show documentation for package or symbol"
    echo "    env         print Jmm environment information"
    echo "    lint        run lint check on package sources"
    echo "    get         download and install packages and dependencies (currently works with github.com only)"
    echo "    here        set $JMMPATH to the given directory"
    echo "    list        list packages"
    echo "    run         compile and run Jmm program (the first file must have the main method)"
    echo "    test        test packages"
    echo "    version     print Jmm version"
    echo
    return 0
}

# @String $1 - Directory path
# Sets the Java- workspace either by walking up from the given directory
# to find one or creating one in the given directory.
jmv_here() {
    local wPath
    if [ -z "$1" ]; then
        wPath=$(jmm_helper_find_src "$(pwd)")
        wPath=${wPath%/*}
    else
        wPath=$(jmm_helper_resolve "$1")
    fi
    if [ -z "$wPath" ]; then
        echo
        echo "This command must be run in a Jmm workspace"
        echo
        return 0
    fi
    mkdir -p "$wPath/bin"
    mkdir -p "$wPath/pkg"
    mkdir -p "$wPath/src"
    export JMMPATH=$wPath
    export PATH=$PATH:$JMMPATH/bin

    echo
    echo "Jmm workspace set to: $JMMPATH"
    echo

    return 0
}

# @String $@ - Directory path(s)
# Runs the lint rules over the given directories.
jmm_lint() {
    local files
    for file in "$@"; do
        files="$files $file"
    done
    result=$(java -jar "$JMMHOME/vendor/checkstyle/checkstyle-6.14.1-all.jar" -c "$JMMHOME/lint.xml" $files)
    if [[ $? -gt 0 ]]; then
        echo "$result"
        return 1
    fi
    return 0
}

# @String $1 - Directory path
# Prints the packages used in the given directory.
jmm_list() {
    local path
    path="$1"
    if [[ -z "$path" ]]; then
        path="."
    fi
    if [[ -d "$path" ]]; then
        for dir in $path/*; do
            jmm_list "$dir"
        done
    else
        if [[ "$path" == *".java" ]]; then
            for package in $(grep ^package "$1"); do
                if [[ "$package" != "package" ]]; then
                    package=${package//[;]/}
                    if [[ "$(jmm_helper_import_check "$package")" == "import" ]]; then
                        echo "$package"
                    fi
                fi
            done
        fi
    fi
    return 0
}

# @String $@ - File path(s) to .java files
# Creates a jar in $JMMPATH/bin and executes it.
jmm_run() {
    local jarFile
    jmm_lint "$@"
    if [[ $? -gt 0 ]]; then
        return 1
    fi
    jarFile=$(jmm_helper_build_jar "$@")
    java -jar "$jarFile"
    return $?
}

# @String $@ - Directory or file path(s) to _test.java files
# Runs the tests for the given or found files and generate coverage reports.
jmm_test_coverage() {
    local path
    local testPath
    local files
    local compileClassPaths
    local buf
    local failures
    local coverageDir
    path=$(jmm_helper_path_resolve "$1")
    if [[ -d "$path" ]]; then
        files=$(jmm_helper_resolve_dir_for_compile "$path")
        testPath=$path
    elif [[ -e "$path" ]] && [[ "$path" == *"_test.java" ]]; then
        jmm_start_import_check
        files="$path $(jmm_helper_resolve_imports "$path")"
        jmm_end_import_check
        testPath="$(dirname $path)"
        files="$files $(jmm_helper_resolve_dir_for_compile $testPath)"
    fi
    jmm_lint $files
    if [[ $? > 0 ]]; then
        return $?
    fi
    compileClassPaths=$(jmm_helper_compile $files)
    if [[ $? > 0 ]]; then
        return $?
    fi
    coverageFiles=$(jmm_helper_get_class_files_for_coverage $path)
    # echo "instrumenting"
    buf=$(java -cp $COBERTURA net.sourceforge.cobertura.instrument.InstrumentMain \
        --datafile $JMMPATH/cobertura.ser \
        $coverageFiles)
    # echo "running tests"
    jmm_test_run_coverage $path
    failures=$?
    # echo "generating coverage report"
    rm -rf $JMMPATH/coverage
    buf=$(java -cp $COBERTURA net.sourceforge.cobertura.reporting.ReportMain \
        --datafile $JMMPATH/cobertura.ser \
        --destination $JMMPATH/coverage \
        --format html \
        $JMMPATH/src \
        2> /dev/null)
    # echo "checking coverage"
    # buf=$(java -cp $COBERTURA net.sourceforge.cobertura.check.CheckCoverageMain \
    #   --datafile $JMMPATH/cobertura.ser \
    #   --totalbranch 100 \
    #   --totalline 100)
    rm $JMMPATH/cobertura.ser
    return $((failures))
}

# @String $@ - Directory or file path(s) to _test.java files
# Runs the tests for the given or found files.
jmm_test() {
    local path
    local testPath
    local files
    local compileClassPaths
    path=$(jmm_helper_path_resolve "$1")
    if [[ -d "$path" ]]; then
        files=$(jmm_helper_resolve_dir_for_compile "$path")
        testPath=$path
    elif [[ -e "$path" ]] && [[ "$path" == *"_test.java" ]]; then
        jmm_start_import_check
        files="$path $(jmm_helper_resolve_imports "$path")"
        jmm_end_import_check
        testPath="$(dirname $path)"
        files="$files $(jmm_helper_resolve_dir_for_compile $testPath)"
    fi
    jmm_lint $files
    if [[ $? > 0 ]]; then
        return $?
    fi
    compileClassPaths=$(jmm_helper_compile $files)
    if [[ $? > 0 ]]; then
        return $?
    fi
    # echo "running tests"
    jmm_test_run $path
    return $?
}

# Prints the current version of this tool.
jmm_version() {
    echo $JMMVERSION
}

#
# Interface
#

# The main entry point.
jmm() {
    case $1 in
    "help" )
        jmm_help
        return 0
    ;;
    "" )
        jmm_help
        return 0
    ;;
    "here" )
        jmv_here "$2"
        return 0
    ;;
    "env" )
        jmm_env
        return 0
    ;;
    "version" )
        jmm_version
        return 0
    ;;
    esac

    if [[ -z "$JMMPATH" ]]; then
        echo
        echo "You must be in a Jmm workspace to use '$1'."
        echo
        return
    fi

    case $1 in
    "clean" )
        jmm_clean
    ;;
    "doc" )
        echo "TODO"
    ;;
    "get" )
        jmm_get "${@:2}"
    ;;
    "install" )
        jmm_install "$2"
    ;;
    "lint" )
        jmm_lint "${@:2}"
    ;;
    "list" )
        jmm_start_import_check
        jmm_list "$2"
        jmm_end_import_check
    ;;
    "run" )
        jmm_run "${@:2}"
    ;;
    "test" )
        if [[ $2 == "cover" ]]; then
            jmm_test_coverage "${@:3}"
        else
            jmm_test "${@:2}"
        fi
    ;;
    *)
        echo "jmm: unknown subcommand \"$1\""
        echo "Run 'go help' for usage."
        return 1
    esac
    return $?
}

} # this ensures the entire script is downloaded 
