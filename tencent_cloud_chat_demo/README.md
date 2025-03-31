## About Tencent Cloud Chat UIKit V2
This sample app demonstrates the usage of our restructured and redesigned version of UIKit, V2, which offers an enhanced development and user experience.

The V2 UIKit is designed to provide developers with a comprehensive set of tools to easily create feature-rich chat applications.

Built with a modular approach, it allows you to pick and choose the components you need while keeping your application lightweight and efficient.

![uikit.png](https://comm.qq.com/im/static-files/uikit.jpg)

The UIKit includes a wide range of capabilities, such as [Conversation List](https://pub.dev/packages/tencent_cloud_chat_conversation), [Message handling](https://pub.dev/packages/tencent_cloud_chat_message),
[Contact lists](https://pub.dev/packages/tencent_cloud_chat_contact), [User](https://pub.dev/packages/tencent_cloud_chat_user_profile) and [Group Profiles](https://pub.dev/packages/tencent_cloud_chat_group_profile), Search functionality, and more.

This sample app showcases each component of our brand-new UIKit.

For more information, please refer to [Install UIKit](https://trtc.io/document/58585?platform=flutter&product=chat&menulabel=uikit).


## Compatible Platforms

The platforms are compatible with the deployment of our Chat UIKit.

- Android
- iOS
- _Web (Will be supported later)_
- Windows
- macOS

## Environment Requirements

|   | Version                                                                        |
|---------|--------------------------------------------------------------------------------|
| Flutter | Flutter 3.24.0 or later                                                        |
| Android | Android Studio 3.5 or later; devices with Android 4.1 or later for apps        |
| iOS | Xcode 11.0 or later. Ensure that your project has a valid developer signature. |

<table >
  <tr >
    <th width="180px" style="text-align:center">Flutter version</th>
    <th width="250px" style="text-align:center">UIKit-V2 Components version</th>
    <th width="500px" style="text-align:center">Third-party libraries</th>
    <th width="500px" style="text-align:center">Compatible Configurations</th>
  </tr>

  <tr >
     <td style="text-align:center">3.24.0 - 3.24.4</td>
     <td style="text-align:center">tencent_cloud_chat_message: ^2.0.0</td>
     <td style="text-align:center">
        <ul>
          <li>extended_text: ^14.0.0</li>
          <li>extended_text_field: ^16.0.0</li>
        </ul>
     </td>
     <td style="text-align:center">
        <img width="611" alt="build.gradle" src="https://github.com/user-attachments/assets/598a325a-9681-425e-8e07-ea3229e19dc2">
     </td>
    
  </tr>

  <tr>
     <td style="text-align:center">3.22.0 - 3.22.3</td>
     <td style="text-align:center">tencent_cloud_chat_message: ^1.5.0</td>
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

# Checkout the 'v2' branch
git checkout v2

# Clean the project. Important
flutter clean

# Install dependencies
flutter pub get
```

2. Configure the user info for login.

Open `lib/config.dart`, and specify the `sdkappid`, `userid`, and `usersig` obtained and generated in the previous step.

3. Run the app.

```shell
flutter run
```

