export JMMVERSION="0.0.1"
export JMMHOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#
# Constants
#

ILLEGAL_PACKAGE="Illegal package"
LEGAL_PACKAGES=(                # This list is temporary until someone thinks about it
                                # https://docs.oracle.com/javase/8/docs/api/overview-summary.html
    "java.io.BufferedReader"    # https://docs.oracle.com/javase/8/docs/api/java/io/BufferedReader.html
    "java.io.InputStreamReader" # https://docs.oracle.com/javase/8/docs/api/java/io/InputStreamReader.html
    "java.io.IOException"       # https://docs.oracle.com/javase/8/docs/api/java/io/IOException.html
    "java.io.PrintWriter"       # https://docs.oracle.com/javase/8/docs/api/java/io/PrintWriter.html
    "java.net.ServerSocket"     # https://docs.oracle.com/javase/8/docs/api/java/net/ServerSocket.html
    "java.net.Socket"           # https://docs.oracle.com/javase/8/docs/api/java/net/Socket.html
    "java.time"                 # https://docs.oracle.com/javase/8/docs/api/java/time/package-summary.html
)

#
# Helper functions
#

# @String $1 - Java import path
# @return "false" || ""
# Checks an import against the legal Java-- packages.
jmm_package_allowed() {
    if [[ "$1" == "java."* ]]; then
        for package in ${LEGAL_PACKAGES[@]}; do
            if [[ "$1" == "$package"* ]]; then
                return 0
            fi
        done
    fi
    echo "false"
    return 1
}

# @String $1 - Directory path
# @return "dir/path"
# Returns an absolute path from the give input path.
jmm_helper_path_resolve() {
    if [ ${1:0:1} = "." ]; then # if starts with a .
        echo $(pwd)${1:1}
    elif [ ${1:0:1} = "~" ]; then # if starts with a ~
        echo  $HOME${1:1}
    elif [ ${1:0:1} = "/" ]; then # if starts with a /
        echo  $1
    else
        echo $(pwd)/$1
    fi
    return 0
}

# @String $1 - Directory path
# @return "name"
# Returns the jar name for a given directory path.
jmm_helper_get_jar_name() {
    local base
    base=$(dirname $1)
    echo ${base##*/}
    return 0
}

# @String $1 - Directory path
# @return "dir/path"
# Returns a class path from a given absolute path.
jmm_helper_get_class_path() {
    local absPath
    local jmmSize
    local absSize
    local absPath
    absPath=$(jmm_helper_path_resolve $1)
    jmmSize=${#JMMPATH}+5 # remove /src/
    absSize=${#absPath}
    absPath=${absPath:0:absSize-5} # remove .class
    echo ${absPath:$jmmSize}
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
    dir="$(jmm_helper_find_up $1 'src')"
    if [ -e "$dir/src" ]; then
        echo "$dir/src"
    fi
    return 0
}

# @String $1 - Directory path
# Resolves the given directory if it exists.
jmm_helper_resolve() {
    cd "$1" 2>/dev/null || return $?  # cd to desired directory; if fail, quell any error messages but return exit status
    echo "`pwd -P`" # output full, link-resolved path
    return 0
}

jmm_helper_build_jar() {
    local jarName
    local classPath
    local classFiles
    local classPaths
    mkdir -p $JMMPATH/bin
    mkdir -p $JMMPATH/pkg
    jarName=$(jmm_helper_get_jar_name $1)
    classPath=$(jmm_helper_get_class_path $1)
    classPath=${classPath//[\/]/\.}
    classFiles=""
    classPaths=""
    for file; do
        if [[ $file != "_test.java"* ]]; then
            classFiles="$classFiles $file"
            classPaths="$classPaths -C $JMMPATH/pkg $(jmm_helper_get_class_path $file).class"
        fi
    done
    javac -d $JMMPATH/pkg $classFiles
    if [[ $? -eq 1 ]]; then
        return 1
    fi
    jar cfe $JMMPATH/bin/$jarName.jar $classPath $classPaths
    echo $JMMPATH/bin/$jarName.jar
    return 0
}

jmm_helper_resolve_imports() {
    local files
    files=""
    for import in $(grep ^import $1); do
        if [ "$import" != "import" ] && [ -n $import ]; then
            if [ "${import:0:4}" == "java" ] && [ "$(jmm_package_allowed $import)" == "false" ]; then
                echo "$ILLEGAL_PACKAGE: $import"
                return
            elif [ "${import:0:4}" != "java" ]; then
                import=${import//[\.]/\/}
                import=$(dirname $import)
                newFiles=$(jmm_helper_find_java_files $JMMPATH/src/$import)
                if [[ "$newFiles" == "$ILLEGAL_PACKAGE"* ]]; then
                    echo "$newFiles"
                    return
                fi
                files="$files $newFiles"
            fi
        fi
    done
    echo $files
    return 0
}

jmm_helper_find_java_files() {
    local files
    files=""
    for file in $(find $1 -name '*.java'); do
        imports=$(jmm_helper_resolve_imports $file)
        if [[ "$imports" == "$ILLEGAL_PACKAGE"* ]]; then
            echo "$imports"
            return
        fi
        files="$files $file $imports"
    done
    echo $files
    return 0
}

jmm_run_test() {
    local files
    local dir
    # get all the files used in the imports.
    files="$1 $(jmm_helper_resolve_imports $1)"
    # get all the files in the same directory.
    for file in $(find $(dirname $1) -name '*.java'); do
        if [[ ! -d "$file" ]] && [[ "$file" != *"_test.java" ]]; then
            files="$files $file"
        fi
    done
    # run the test.
    jmm_run $files
    if [[ $? -eq 0 ]]; then
        echo "pass"
        return 0
    fi
    echo "fail"
    return 1
}

#
# Commands
#

jmm_install() {
    local path
    local main
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
    path=$(jmm_helper_path_resolve "$path") # TODO: strip last / if it's there.
    main=""
    files=""
    for file in $(find $path -name '*.java'); do
        if [ "$main" = "" ] && grep -q "public static void main(" "$file"; then
            imports=$(jmm_helper_resolve_imports $file)
            if [[ "$imports" == "$ILLEGAL_PACKAGE"* ]]; then
                echo "$imports"
                return
            fi
            main="$file $imports"
        else
            imports=$(jmm_helper_resolve_imports $file)
            if [[ "$imports" == "$ILLEGAL_PACKAGE"* ]]; then
                echo "$imports"
                return
            fi
            files="$files $file $imports"
        fi
    done
    jar=$(jmm_helper_build_jar $main $files)
    if [[ "$jar" = "" ]]; then
        return
    fi
    exe=${jar:0:${#jar}-4}
    echo "java -jar $jar" > $exe
    chmod +x $exe
    return 0
}

jmm_clean() {
    rm -rf $JMMPATH/bin/*
    rm -rf $JMMPATH/pkg/*
    return 0
}

jmm_env() {
    echo "JMMPATH=\"$JMMPATH\""
    echo "JMMHOME=\"$JMMHOME\""
    echo "JAVA_HOME=\"$JAVA_HOME\""
    return 0
}

jmm_get() { # currently only works with github zip files
    local packageDir
    local packageName
    for package; do
        # need to filter out none github imports
        $(curl -s -o $JMMPATH/master.zip -L $package/archive/master.zip)
        if grep -q "error" "$JMMPATH/master.zip"; then
            rm $JMMPATH/master.zip
            echo "Package '$package' not found"
            return 1
        fi
        packageDir=${package//[\.]/\/}
        rm -rf $JMMPATH/src/$packageDir
        mkdir -p $JMMPATH/src/$packageDir
        unzip -qq $JMMPATH/master.zip -d $JMMPATH/src/$packageDir
        packageName=$(basename $package)
        mv $JMMPATH/src/$packageDir/$packageName-master/* $JMMPATH/src/$packageDir/$packageName-master/..
        mv $JMMPATH/src/$packageDir/$packageName-master/.[^.]* $JMMPATH/src/$packageDir/$packageName-master/..
        rm -r $JMMPATH/src/$packageDir/$packageName-master
        rm $JMMPATH/master.zip
    done
    return 0
}

jmm_help() {
    echo "Jmm is a tool for managing Java-- source code."
    echo
    echo "Java--"
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

jmv_here() {
    local wPath
    if [ -z $1 ]; then
        wPath=$(jmm_helper_find_src $(pwd))
        wPath=${wPath%/*}
    else
        wPath=$(jmm_helper_resolve $1)
    fi
    if [ -z $wPath ]; then
        echo
        echo "This command must be run in a Jmm workspace"
        echo
        return 0
    fi
    mkdir -p $wPath/bin
    mkdir -p $wPath/pkg
    mkdir -p $wPath/src
    export JMMPATH=$wPath
    export PATH=$PATH:$JMMPATH/bin

    echo
    echo "Java-- workspace set to: $JMMPATH"
    echo

    return 0
}

jmm_lint() {
    local files
    for file in "$@"; do
        files="$files $file"
    done
    result=$(java -jar $JMMHOME/vendor/checkstyle/checkstyle-6.14.1-all.jar -c $JMMHOME/lint.xml $files)
    if [[ $? -gt 0 ]]; then
        echo $result
        return 1
    fi
    return 0
}

jmm_list() {
    local path
    path="$1"
    if [[ -z "$path" ]]; then
        path="."
    fi
    if [[ -d "$path" ]]; then
        for dir in $path/*; do
            jmm_list $dir
        done
    else
        if [[ "$path" == *".java" ]]; then
            for package in $(grep ^package $1); do
                if [[ "$package" != "package" ]]; then
                    echo "$package"
                fi
            done
        fi
    fi
    return 0
}

jmm_run() {
    local jarFile
    jmm_lint $@
    if [[ $? -gt 0 ]]; then
        return 1
    fi
    jarFile=$(jmm_helper_build_jar "$@")
    java -jar $jarFile
    return $?
}

jmm_test() {
    local failures
    jmm_lint $@
    if [[ $? -gt 0 ]]; then
        return 1
    fi
    failures=0
    for path in "$@"; do
        if [[ -d "$path" ]]; then
            # if it's a directory recursively find all test files and execute them one at a time.
            for dir in $path/*; do
                jmm_test $dir
            done
        elif [[ -e "$path" ]] && [[ "$path" == *"_test.java" ]]; then
            # if the file ends with "_test.java" then run it.
            jmm_run_test $path
        fi
    done
    return 0
}

jmm_version() {
    echo $JMMVERSION
}

#
# Interface
#

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
        jmv_here $2
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

    if [[ -z $JMMPATH ]]; then
        echo
        echo "You must be in a Java-- workspace to use '$1'."
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
        jmm_install $2
    ;;
    "lint" )
        jmm_lint "${@:2}"
    ;;
    "list" )
        jmm_list $2
    ;;
    "run" )
        jmm_run "${@:2}"
    ;;
    "test" )
        jmm_test "${@:2}"
    ;;
    *)
        echo "jmm: unknown subcommand \"$1\""
        echo "Run 'go help' for usage."
        return 1
    esac
    return $?
}
