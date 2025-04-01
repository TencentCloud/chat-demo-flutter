## Based on HarmonyOS [Flutter 3.22](https://gitee.com/harmonycommando_flutter/flutter)
UIKit components are integrated into HarmonyOS in source code form.
### 1. Create a HarmonyOS Platform in the Project  
**Command**:  
```bash
flutter create --platforms ohos .
# OR (using FVM)
# fvm flutter create --platform oho .
```  
*(Note the trailing `.` to specify the current directory.)*  

---
### 2. Depend on the local UIKit component library
Add the local component library as a dependency in the pubspec.yaml file located in the root directory of your project (e.g., tencent_cloud_chat_demo/pubspec.yaml) as follows:
```yaml
dependencies:
  flutter:
    sdk: flutter
  tencent_cloud_chat_common:
    path: ../TIMCommon
  tencent_cloud_chat_intl:
    path: ../TUIInternational
  tencent_cloud_chat_conversation:
    path: ../TUIConversation
  tencent_cloud_chat_message:
    path: ../TUIMessage
  tencent_cloud_chat_contact:
    path: ../TUIContact
  tencent_cloud_chat_sticker:
    path: ../TUIEmoji
  tencent_cloud_chat_message_reaction:
    path: ../TUIEmojiPlugin
  tencent_cloud_chat_search:
    path: ../TUISearch
  tencent_cloud_chat_text_translate:
    path: ../TUITranslationPlugin
  tencent_cloud_chat_sound_to_text:
    path: ../TUIVoiceToTextPlugin
  tencent_cloud_chat_push: ^8.4.6667
```
### 3. Override Third-Party Dependencies (`dependency_overrides`)  
The UIKit uses third-party libraries already adapted by the official HarmonyOS team. Add the following overrides to your `pubspec.yaml`:  
```yaml
dependency_overrides:
  path_provider:
    git:
      url: "https://gitee.com/openharmony-sig/flutter_packages.git"
      path: "packages/path_provider/path_provider"
  shared_preferences:
    git:
      url: "https://gitee.com/openharmony-sig/flutter_packages.git"
      path: "packages/shared_preferences/shared_preferences"
  file_picker_ohos:
    git:
      url: "https://gitee.com/openharmony-sig/fluttertpc_file_picker.git"
      path: "ohos"
  image_picker:
    git:
      url: "https://gitee.com/openharmony-sig/flutter_packages.git"
      path: "packages/image_picker/image_picker"
  permission_handler:
    git:
      url: "https://gitee.com/openharmony-sig/flutter_permission_handler.git"
      path: "permission_handler"
  video_thumbnail_ohos:
    git:
      url: "https://gitee.com/openharmony-sig/fluttertpc_video_thumbnail.git"
      path: "ohos"
  record:
    git:
      url: "https://gitee.com/openharmony-sig/fluttertpc_record.git"
      path: "record"
  audioplayers:
    git:
      url: "https://gitee.com/openharmony-sig/flutter_audioplayers.git"
      path: "packages/audioplayers"
  video_player:
    git:
      url: "https://gitee.com/openharmony-sig/flutter_packages.git"
      path: "packages/video_player/video_player"
  extended_text: ^13.0.0
  extended_text_field: ^15.0.0
```

---

### 4. Fix Compilation Errors in `extended_text_field`  
The `extended_text_field` library may throw compilation errors due to missing `default` cases in platform-switching logic.
<img width="1605" alt="image" src="https://github.com/user-attachments/assets/ee53a421-17ac-4621-b73f-875a2d153daa" />

Follow these steps:  

#### 4.1: Open the Project in VS Code
1). Find the Error File:
   Check the compilation error message to identify the problematic file path (usually in .pub_cache/.../extended_text_field-15.0.0/).
     <img width="2286" alt="image1" src="https://github.com/user-attachments/assets/81401650-502c-441e-8d23-e2fa75b70fba" />

2). Open the Project:
   In VS Code, select File > Open Folder and select `extended_text_field-15.0.0` project directory.
#### 4.2: Replace Platform-Switching Logic 
1). **Search** (use regex):  
   ```regex
   ^( +?)case TargetPlatform.android:
   ```  
2). **Replace** with:  
   ```regex
   $1case TargetPlatform.android:
   $1case TargetPlatform.ohos:
   ```
   <img width="1903" alt="image2" src="https://github.com/user-attachments/assets/ac76b55f-8d1b-465e-b9fa-0ce90d5c0d2e" />

### 4.3: Fix Android/OS Compatibility Check
1). **Search** (exact match):  
   ```text
   TargetPlatform.android ||
   ```  
2). **Replace** with:  
   ```text
   TargetPlatform.android || TargetPlatform.ohos ||
   ```  
<img width="1899" alt="image4" src="https://github.com/user-attachments/assets/f0a49410-eb65-40a6-a7df-d379a503d6d7" />

---

**Note**: After modifications, run `flutter pub get` and rebuild the project.  

