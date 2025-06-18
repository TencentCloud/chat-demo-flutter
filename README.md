## Compatible Platforms

The platforms are compatible with the deployment of our Chat UIKit.

- Android
- iOS
- Web (version 0.1.4 and later)
- Windows (version 2.0.0 and later)
- macOS (version 2.0.0 and later)

## Check Out Our Sample Apps

This document introduces how to quickly run the Chat demo on the iOS platform.
For the other platforms, please refer to document：
- [**chat-uikit-android**](https://github.com/TencentCloud/chat-uikit-android)
- [**chat-uikit-ios**](https://github.com/TencentCloud/chat-uikit-ios)
- [**chat-uikit-vue**](https://github.com/TencentCloud/chat-uikit-vue)
- [**chat-uikit-react**](https://github.com/TencentCloud/chat-uikit-react)
- [**chat-uikit-uniapp**](https://github.com/TencentCloud/chat-uikit-uniapp)
- [**chat-uikit-wechat**](https://github.com/TencentCloud/chat-uikit-wechat)

## Environment Requirements

| Platform  | Version                                                                                                     |
|---------|-------------------------------------------------------------------------------------------------------------|
| Flutter | Flutter 3.0.0 or later for the IM SDK; Flutter 3.24.0 or later for the TUIKit component library. |
| Android | Android Studio 3.5 or later; devices with Android 4.1 or later for apps                                     |
| iOS | Xcode 11.0 or later. Ensure that your project has a valid developer signature.                              |


<table >
  <tr >
    <th width="180px" style="text-align:center">Flutter version</th>
    <th width="180px" style="text-align:center">tencent_cloud_chat_uikit version</th>
    <th width="500px" style="text-align:center">Third-party libraries</th>
    <th width="500px" style="text-align:center">Compatible Configurations</th>
  </tr>

  <tr>
     <td style="text-align:center">3.32.4</td>
     <td style="text-align:center">^5.0.0</td>
     <td style="text-align:center">
        <ul>
            <li>intl: ^0.20.2</li>
        </ul>
     </td>
    <td style="text-align:center"></td>

  <tr>
     <td style="text-align:center">3.29.0</td>
     <td style="text-align:center">^5.0.0</td>
     <td style="text-align:center">
        <ul>
            <li>extended_text: ^15.0.0</li>
        </ul>
     </td>
    <td style="text-align:center">
      <img width="892" alt="Clipboard_Screenshot_1750234261" src="https://github.com/user-attachments/assets/7e9e01c3-deb8-42e7-92d2-644f8dc1bab9" />
    </td>

  </tr>

  <tr>
     <td style="text-align:center">3.27.0</td>
     <td style="text-align:center">^3.1.0+2</td>
     <td style="text-align:center">
        <ul>
            <li>Replace the flutter_slidable library with flutter_slidable_plus_plus to solve the compatibility issue of flutter 3.27.0 version.</li>
        </ul>
     </td>
    <td style="text-align:center"></td>

  </tr>

  <tr >
     <td style="text-align:center">3.24.0 - 3.24.4</td>
     <td style="text-align:center">^3.0.0</td>
     <td style="text-align:center">
        <ul>
          <li>extended_text: ^14.0.0</li>
          <li>extended_text_field: ^16.0.0</li>
          <li>flutter_plugin_record_plus: ^0.0.17</li>
          <li>image_gallery_saver：The latest version of this library does not support Flutter 3.24. Please refer to the [Compatible Configuration] on the right.</li>
        </ul>
     </td>
     <td style="text-align:center">
        <img width="911" alt="build.gradle" src="https://github.com/user-attachments/assets/598a325a-9681-425e-8e07-ea3229e19dc2">
     </td>
    
  </tr>

  <tr>
     <td style="text-align:center">3.22.0 - 3.22.3</td>
     <td style="text-align:center">^2.7.2</td>
     <td style="text-align:center">
        <ul>
            <li>extended_text: ^13.0.0</li>
            <li>extended_text_field: ^15.0.0</li>
        </ul>
     </td>
    <td style="text-align:center"></td>

  </tr>
</table>


## Preparation


### Step 1. Create an App
1. Log in to the [Chat Console](https://console.trtc.io/). If you already have an app, record its SDKAppID.
2. On the **Application List** page, click **Create Application**.
3. In the **Create Application** dialog box, enter the app information and click **Confirm**.
After the app is created, an app ID (SDKAppID) will be automatically generated, which should be noted down.

### Step 2: Obtain Key Information

1. Click **Application Configuration** in the row of the target app to enter the app details page.
2. Click **View Key** and copy and save the key information.
> Please store the key information properly to prevent leakage.

## Running the sample app

1. Download the source code and install dependencies:

```shell
# Clone the code
git clone https://github.com/TencentCloud/chat-demo-flutter.git

# Flutter clean
flutter clean

# Install dependencies
flutter pub get
```

2. [Optional] Running or Deploying on the Web

If you prefer to run or deploy this sample app on the web, you'll need to complete a few additional steps first.

Navigate to the `web/` directory of your project and use npm or Yarn to install the required JavaScript dependencies.

```bash
cd web

npm install
```

Once you've completed these steps, you'll be ready to run or deploy the sample app on the web.

3. Run it:

Start the sample app. Fill in sdkAppID and key recorded in [Chat Console](https://console.trtc.io/) in config.dart


## (Optional) Using the IDE

### Android

1. Go to the discuss/android directory via Android Studio.
<img src="https://qcloudimg.tencent-cloud.cn/raw/6516f9b17c58915c4ebc93c5c8829831.png" width="600px" />

2. Start an Android simulator, tap **Build And Run** to run the sample app. Enter a random `UserID` (a combination of digits and letters).

> The UI of the latest version of the sample app may look different after adjustments.

### iOS

1. Open Xcode and the file discuss/ios/Runner.xcodeproj:
<img src="https://qcloudimg.tencent-cloud.cn/raw/6d74814ba9bce54c7439e8b3cea53e73.png" width="600px" />

2. Connect an iPhone, and click **Build And Run**. After the iOS project is built, the Xcode project will be displayed in a new pop-up window.

3. Open the iOS project, and set **Signing & Capabilities** (an iPhone developer account required) for the primary target to run the project on the iPhone.

4. Start the project and debug the sample app on the iPhone device.
<img src="https://qcloudimg.tencent-cloud.cn/raw/3fe6bbac88bb21ad7a7822bb297793b3.png" width="600px" />


## Sample app code structure

> The [TUIKit Library Overview](https://trtc.io/document/50059?platform=flutter&product=chat) for Flutter is used for the UI and business logic of the sample app. The sample app layer itself is only used to build the application, process navigation redirects, and call instantiated TUIKit components.


|  Folder  | Description |
|---------|---------|
| lib | Core application directory |
| lib/i18n | Internationalization code, excluding the internationalization capabilities and strings of TUIKit, which can be imported as needed. |
| lib/src | Main application directory |
| lib/src/pages | Important navigation pages of the sample app. After the application is initialized, `app.dart` displays the loading animation, judges the login status, and redirects the user to `login.dart` or `home_page.dart`. After the user logs in, the login information will be stored locally through the `shared_preference` plugin and used for automatic login upon future application launch. If there is no such information or the login fails, the user will be redirected to the login page. During automatic login, the user is still on `app.dart` and can see the loading animation. `home_page.dart` has a bottom tab to switch between the four main feature pages of the sample app. |
| lib/utils | Some tool function classes. |


Basically, a TUIKit component is imported into each `dart` file in `lib/src`. After the component is instantiated in the file, the page can be rendered.

Below are main files:

|  Main File in `lib/src`  | Description |
|---------|---------|
| add_friend.dart | Friend request page that uses the `TIMUIKitAddFriend` component. |
| add_group.dart | Group joining request page that uses the `TIMUIKitAddGroup` component.|
| blacklist.dart| Blocklist page that uses the `TIMUIKitBlackList` component. |
| chat.dart | Main chat page that uses all the chat capabilities of TUIKit and the `TIMUIKitChat` component. |
| chatv2.dart | Main chat page that uses atomic capabilities and the `TIMUIKitChat` component. |
| contact.dart | Contacts page that uses the `TIMUIKitContact` component. |
| conversation.dart | Conversation list page that uses the `TIMUIKitConversation` component. |
| create_group.dart | Group chat page that is implemented in the sample app with no component used. |
| group_application_list.dart | Group application list page that uses the `TIMUIKitGroupApplicationList` component. |
| group_list.dart | Group list page that uses the `TIMUIKitGroup` component.  |
| group_profile.dart | Group profile and management page that uses the `TIMUIKitGroupProfile` component. |
| newContact.dart | New contact request page that uses the `TIMUIKitNewContact` component. |
| routes.dart | Sample app route that navigates users to the login page `login.dart` or homepage `home_page.dart`. |
| search.dart | Global search and in-conversation search page that uses the `TIMUIKitSearch` (global search) and `TIMUIKitSearchMsgDetail` (in-conversation search) components. |
| user_profile.dart | User information and relationship chain maintenance page that uses the `TIMUIKitProfile` component. |

The navigation redirect method needs to be imported into most TUIKit components; therefore, the sample app layer needs to process `Navigator`.

You can modify the above sample app for secondary development or implement your business needs based on it.

## Recommended Resources

For those who require real-time voice and video call capabilities alongside our Chat UIKit,
we highly recommend our dedicated voice and video call UI component package, [tencent\_calls\_uikit](https://pub.dev/packages/tencent_calls_uikit).
This robust and feature-rich package is specifically designed to complement our existing solution and seamlessly integrate with it,
providing a comprehensive, unified communication experience for your users.
