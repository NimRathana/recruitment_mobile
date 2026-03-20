## Getting Started

===== CHANGE THESE VALUES =====

$oldName = "modern_app"
$newName = "new_project_name"
$appName = "New App Name"
$packageName = "com.rathana.modernapp"

===== INSTALL TOOLS =====

dart pub add rename
dart pub add change_app_package_name

===== CHANGE APP NAME =====

dart run rename setAppName --value "$appName"

===== CHANGE PACKAGE NAME =====

dart run change_app_package_name:main $packageName

===== CHANGE pubspec.yaml NAME =====

(Get-Content pubspec.yaml) -replace "name: $oldName", "name: $newName" | Set-Content pubspec.yaml

===== UPDATE ALL IMPORTS =====

Get-ChildItem -Recurse -Include *.dart,*.yaml,*.c,*.h,*.cpp,*.rc,*.plist,*.swift,*.mm | ForEach-Object {
    (Get-Content $_.FullName) -replace 'recruitment_mobile', 'Modern App' | Set-Content $_.FullName
}

===== RENAME PROJECT FOLDER =====

cd ..
Rename-Item $oldName $newName
cd $newName

===== CLEAN PROJECT =====

flutter clean
flutter pub get
flutter run
