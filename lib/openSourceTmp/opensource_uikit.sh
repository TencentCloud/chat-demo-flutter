echo "=====Start Copy====="

path=$(pwd)

echo "$path"


cd ../../../

echo "当前目录"

ls

echo "开始拷贝"

cp -rf im-flutter-uikit/package_src/tim_ui_kit ./

rm -rf im-flutter-uikit

echo "=====End Copy====="

ls
