SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PROJECT_DIR="${SCRIPT_DIR}/code"


compile_android(){
    cd ${PROJECT_DIR}
    godot --export-debug "Android" dist/android/android.apk
}
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
zip_files "web"
compile_windows
zip_files "windows"
compile_linux
zip_files "linux"
compile_android
zip_files "android"



