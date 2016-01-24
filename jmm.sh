export JMM_VERSION="0.0.1"

#
# Constants
#

ILLEGAL_PACKAGE="Illegal package"
LEGAL_PACKAGES=(                # https://docs.oracle.com/javase/8/docs/api/overview-summary.html
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

jmm_package_allowed() {
	if [[ "$1" == "java."* ]]; then
		for package in ${LEGAL_PACKAGES[@]}; do
			if [[ "$1" == "$package"* ]]; then
				return
			fi
		done
	fi
	echo "false"
}

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
}

jmm_helper_get_dir_name() {
	local base
	base=$(dirname $1)
	echo ${base##*/}
}

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
}

jmm_helper_find_up() {
  local path
  path=$1
  while [ "$path" != "" ] && [ ! -d "$path/$2" ]; do
	path=${path%/*}
  done
  echo "$path"
}

jmm_helper_find_src() {
  local dir
  dir="$(jmm_helper_find_up $1 'src')"
  if [ -e "$dir/src" ]; then
	echo "$dir/src"
  fi
}

jmm_helper_resolve() {
	cd "$1" 2>/dev/null || return $?  # cd to desired directory; if fail, quell any error messages but return exit status
	echo "`pwd -P`" # output full, link-resolved path
}

jmm_helper_build_jar() {
	local jarName
	local classPath
	local classFiles
	local classPaths
	mkdir -p $JMMPATH/bin
	mkdir -p $JMMPATH/pkg
	jarName=$(jmm_helper_get_dir_name $1)
	classPath=$(jmm_helper_get_class_path $1)
	classPath=${classPath//[\/]/\.}
	classFiles=""
	classPaths=""
	for file; do
		classFiles="$classFiles $file"
		classPaths="$classPaths -C $JMMPATH/pkg $(jmm_helper_get_class_path $file).class"
	done
	javac -d $JMMPATH/pkg $classFiles
	if [[ $? -eq 1 ]]; then
		return
	fi
	jar cfe $JMMPATH/bin/$jarName.jar $classPath $classPaths
	echo $JMMPATH/bin/$jarName.jar
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
}

#
# Commands
#

jmm_build() {
	local path
	local main
	local imports
	local files
	local jar
	local exe
	path=$(jmm_helper_path_resolve $1) # TODO: strip last / if it's there.
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
}

jmm_clean() {
	rm -rf $JMMPATH/bin/*
	rm -rf $JMMPATH/pkg/*
}

jmm_env() {
	echo "JMMPATH=\"$JMMPATH\""
	echo "JAVA_HOME=\"$JAVA_HOME\""
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
	echo "    build       compile packages and dependencies"
	echo "    clean       remove object files"
	echo "    doc*        show documentation for package or symbol"
	echo "    env         print Jmm environment information"
	echo "    fmt*        run jmmfmt on package sources"
	echo "    get         download and install packages and dependencies (currently works with github.com only)"
	echo "    here        set $JMMPATH to the given directory"
	echo "    list*       list packages"
	echo "    run         compile and run Jmm program (the first file must have the main method)"
	echo "    test*       test packages"
	echo "    version     print Jmm version"
	echo
	echo "    * not implemented"
	echo
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
}

jmm_run() {
	local jarFile
	jarFile=$(jmm_helper_build_jar "$@")
	java -jar $jarFile
}

jmm_version() {
	echo $JMM_VERSION
}

#
# Interface
#

jmm() {
	case $1 in
	"help" )
		jmm_help
	;;
	"" )
		jmm_help
	;;
	"build" )
		jmm_build $2
	;;
	"clean" )
		jmm_clean
	;;
	"doc" )
		echo "TODO"
	;;
	"env" )
		jmm_env
	;;
	"fmt" )
		echo "TODO"
	;;
	"generate" )
		echo "TODO"
	;;
	"get" )
		jmm_get "${@:2}"
	;;
	"here" )
		jmv_here $2
	;;
	"list" )
		echo "TODO"
	;;
	"run" )
		jmm_run "${@:2}"
	;;
	"test" )
		echo "TODO"
	;;
	"tool" )
		echo "TODO"
	;;
	"version" )
		jmm_version
	;;
	"vet" )
		echo "TODO"
	;;
	*)
		echo "jmm: unknown subcommand \"$1\""
		echo "Run 'go help' for usage."
	esac
}
