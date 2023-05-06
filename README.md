<p align="center">
  <a href="https://www.tencentcloud.com/products/im?from=pub">
    <img src="https://qcloudimg.tencent-cloud.cn/raw/429a2f58678a1f5b150c6ae04aa0b569.png" width="320px" alt="Tencent Chat Logo" />
  </a>
</p>

<h1 align="center">Tencent Cloud Chat Sample App</h1>

<br>

<p align="center">
  Globally interconnected In-App Chat, user profile and relationship chains and offline push.
</p>

<br>

<p align="center">
More languages:
  <a href="https://cloud.tencent.com/document/product/269/68823#.E7.AC.AC.E4.B8.89.E9.83.A8.E5.88.86.EF.BC.9A.E4.BD.BF.E7.94.A8-demo">简体中文</a>
  <a href="https://www.tencentcloud.com/ko/document/product/1047/45907#.ED.8C.8C.ED.8A.B83.3A-demo-.EC.82.AC.EC.9A.A9">한국어</a>
  <a href="https://www.tencentcloud.com/jp/document/product/1047/45907?lang=jp&pg=#.E3.81.9D.E3.81.AE3.EF.BC.9Ademo.E3.81.AE.E4.BD.BF.E7.94.A8">日本語</a>
</p>

<br>

![](https://qcloudimg.tencent-cloud.cn/raw/193ec650f17da6bb33edf5df5d978091.png)

## Compatible Platforms

The platforms are compatible with the deployment of our Chat UIKit.

- Android
- iOS
- Web (version 0.1.4 and later)
- Windows (version 2.0.0 and later)
- macOS (version 2.0.0 and later)

## Check Out Our Sample Apps

Experience our Chat and Voice/Video Call modules by trying out our sample apps.

**These apps have been created using the same Flutter project as our SDKs and extensions.**

| Platform | Link | Remark |
|---------|---------|---------|
| Android / iOS | <img src="https://qcloudimg.tencent-cloud.cn/raw/e791bd503ae267aa51234ad66e347f10.png" width="140px" alt="Tencent Chat Logo" /> | Scan to download app for both Android and iOS. Automatically identifies platform. |
| Web | <img src="https://qcloudimg.tencent-cloud.cn/raw/7908cf6f3c16e4059f8f21229d70a918.png" width="140px" alt="Tencent Chat Logo" /> | Supports both desktop and mobile browsers and automatically adjusts its layout accordingly. Same website as link below. |
| Web | [Visit Now](https://comm.qq.com/flutter/#/) | Supports both desktop and mobile browsers and automatically adjusts its layout accordingly. Same website as previous QR code. |
| macOS | [Download Now](https://comm.qq.com/im_demo_download/macos_flutter.dmg) | The macOS version of our sample app. Control-click the app icon, then choose "Open" from the shortcut menu. |
| Windows | [Download Now](https://comm.qq.com/im_demo_download/windows_flutter.appx) | The Windows version of our sample app, which is a UWP (Universal Windows Platform) application. |
| Linux | Coming Soon... | Will be available later this year. |

**Take a look at the screenshots of
TUIKit [here](https://www.tencentcloud.com/document/product/1047/50059?from=pub) to get an idea of
what to expect.**

## Environment Requirements

|   | Version |
|---------|---------|
| Flutter | Flutter 2.2.0 or later for the IM SDK; Flutter 2.10.0 or later for the TUIKit integration component library. |
| Android | Android Studio 3.5 or later; devices with Android 4.1 or later for apps |
| iOS | Xcode 11.0 or later. Ensure that your project has a valid developer signature. |

## Preparation

1. You have [signed up](https://intl.cloud.tencent.com/document/product/378/17985) for a Tencent Cloud account and completed [identity verification](https://intl.cloud.tencent.com/document/product/378/3629).
2. You have created an application as instructed in [Creating and Upgrading an Application](https://intl.cloud.tencent.com/document/product/1047/34577) and recorded the `SDKAppID`.

## Running the sample app

1. Download the source code and install dependencies:

```shell
# Clone the code
git clone https://github.com/TencentCloud/chat-demo-flutter.git

# Clean. Important
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
```shell
# Start the sample app. Replace `SDK_APPID` and `KEY`
flutter run --dart-define=SDK_APPID={YOUR_SDKAPPID} --dart-define=ISPRODUCT_ENV=false --dart-define=KEY={YOUR_KEY}
```


>- `--dart-define=SDK_APPID={YOUR_SDKAPPID}`. Here, `{YOUR_SDKAPPID}` needs to be replaced with the `SDKAppID` of your application.
>- `--dart-define=ISPRODUCT_ENV=false`. Set it to `false` for a development environment.
>- `--dart-define=KEY={YOUR_KEY}`. Here, `{YOUR_KEY}` needs to be replaced with the `Key` recorded in [Tencent Cloud Console](https://console.tencentcloud.com/im/detail).
>

## (Optional) Using the IDE

### Android

1. Go to the discuss/android directory via Android Studio.

![](https://qcloudimg.tencent-cloud.cn/raw/6516f9b17c58915c4ebc93c5c8829831.png)

2. Start an Android simulator, tap **Build And Run** to run the sample app. Enter a random `UserID` (a combination of digits and letters).

> The UI of the latest version of the sample app may look different after adjustments.

### iOS

1. Open Xcode and the file discuss/ios/Runner.xcodeproj:

![](https://qcloudimg.tencent-cloud.cn/raw/6d74814ba9bce54c7439e8b3cea53e73.png)

2. Connect an iPhone, and click **Build And Run**. After the iOS project is built, the Xcode project will be displayed in a new pop-up window.

3. Open the iOS project, and set **Signing & Capabilities** (an iPhone developer account required) for the primary target to run the project on the iPhone.

4. Start the project and debug the sample app on the iPhone device.

![](https://qcloudimg.tencent-cloud.cn/raw/3fe6bbac88bb21ad7a7822bb297793b3.png)


## Sample app code structure

> The [TUIKit](https://www.tencentcloud.com/document/product/1047/50059) for Flutter is used for the UI and business logic of the sample app. The sample app layer itself is only used to build the application, process navigation redirects, and call instantiated [TUIKit](https://www.tencentcloud.com/document/product/1047/50059) components.


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
