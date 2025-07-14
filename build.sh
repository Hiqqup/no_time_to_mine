SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PROJECT_DIR="${SCRIPT_DIR}/code"


compile_windows(){
    cd ${PROJECT_DIR}
    godot --export-release "Windows Desktop" dist/windows/windows.exe
}
compile_web(){
    cd ${PROJECT_DIR}
    godot --export-release "Web" dist/web/index.html
}
compile_linux(){
    cd ${PROJECT_DIR}
    godot --export-release "Linux" dist/linux/linux.x86_64
}

zip_files(){
    PLATFORM="$1"
    cd ${PROJECT_DIR}/dist/${PLATFORM}
    ZIP_PATH="../../../builds/${PLATFORM}.zip" 
    FILES="*"
    rm ${ZIP_PATH}
    zip ${ZIP_PATH} ${FILES}
}

compile_web
#compile_windows
#compile_linux

#zip_files "web"
#zip_files "windows"
#zip_files "linux"


