echo "=====Start Copy====="

path=$(pwd)

echo "$path"

cp -f app.dart login.dart home_page.dart ../src/pages/

cd $path

cp -f main.dart ../

cd $path

cp -f push_constant.dart ../utils/push

cd $path

cp -f AndroidManifest.xml ../../android/app/src/main/

rm -f ../../android/app/agconnect-services.json

rm -f ../../android/google-services.json

rm -f ../firebase_options.dart

rm -f ../generated_plugin_registrant.dart

cd $path

cp -f build.gradle ../../android/app/

cd $path

cp -f conversation.dart chat.dart ../src/

cd ../src

rm -rf discuss

rm -rf channel.dart

cd ..

rm -rf openSourceTmp

rm -rf utils/discuss.dart

cd ..

rm -rf package_src

echo "=====End Copy====="

ls
