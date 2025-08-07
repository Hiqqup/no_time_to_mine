PREVIOUS_DIR=$(pwd)
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PROJECT_DIR="${SCRIPT_DIR}/code"

cd ${SCRIPT_DIR}



compile_for(){
    #windows needs extra consideraion because it has a space
    TEMPLATE_NAME="$1"
    if [ "$TEMPLATE_NAME" == "Windows" ]; then
        TEMPLATE_NAME='Windows Desktop'
    fi

    cd ${PROJECT_DIR}
    COMPILE_PATH="dist/$1"
    mkdir ${COMPILE_PATH} -p
    godot --export-debug "$TEMPLATE_NAME" "${COMPILE_PATH}/$2"
    zip_files "$1"
}

zip_files(){
    cd ${PROJECT_DIR}/dist/"$1"
    ZIP_PATH="../../../builds/$1.zip" 
    FILES="*"
    mkdir  ../../../builds/ -p
    rm ${ZIP_PATH}
    zip ${ZIP_PATH} ${FILES}
}

compile_for "Web" "index.html"
compile_for 'Windows' "no_time_to_mine.exe"
compile_for "Linux" "no_time_to_mine.x86_64"
compile_for "Android" "no_time_to_mine.apk"

cd ${PREVIOUS_DIR}



