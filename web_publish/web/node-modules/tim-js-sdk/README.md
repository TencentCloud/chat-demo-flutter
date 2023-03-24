
## Official JavaScript SDK for Tencent Cloud Chat

<div align=center>
<img src="https://web.sdk.qcloud.com/im/demo/latest/img/logo.680f9833.svg" width=365 height=182 />
</div>

## About Tencent Cloud Chat

Tencent Cloud Chat provides globally interconnected chat APIs, multi-platform SDKs, and UIKit components to help you quickly bring messaging capabilities such as one-to-one chat, group chat, chat rooms, and system notifications to your applications and websites.

Through the official javascript SDK tim-js-sdk, you can efficiently integrate real-time chat into your client app.

You can sign up for a Tencent Cloud account at [here](https://www.tencentcloud.com/account/login?s_url=https%3A%2F%2Fconsole.tencentcloud.com%2Fim).

Explore more docs about [Tencent Cloud Chat](https://www.tencentcloud.com/products/im).

## Commonly Used Scenarios

- Online Customer Service
<img src="https://cloudcache.intl.tencent-cloud.com/cms/backend-cms/L7Q6912_%E5%9C%A8%E7%BA%BF%E5%AE%A2%E6%9C%8D%402x.jpg" width=730 height=410 />

- OA
<img src="https://cloudcache.intl.tencent-cloud.com/cms/backend-cms/nXQN331_%E4%BC%81%E4%B8%9A%E5%8A%9E%E5%85%AC%402x.jpg" width=730 height=410 />

- Interactive Live Streaming
<img src="https://cloudcache.intl.tencent-cloud.com/cms/backend-cms/HY4F687_%E4%BA%92%E5%8A%A8%E7%9B%B4%E6%92%AD%402x.jpg" width=730 height=410 />

- Social Messaging
<img src="https://cloudcache.intl.tencent-cloud.com/cms/backend-cms/m9yR325_%E7%A4%BE%E4%BA%A4%E6%B2%9F%E9%80%9A%402x.jpg" width=730 height=410 />

- Influencer Marketing
<img src="https://cloudcache.intl.tencent-cloud.com/cms/backend-cms/VtQ5764_%E7%94%B5%E5%95%86%E5%B8%A6%E8%B4%A7%402x.jpg" width=730 height=410 />

- Interactive Game
<img src="https://cloudcache.intl.tencent-cloud.com/cms/backend-cms/XubI769_%E4%BA%92%E5%8A%A8%E6%B8%B8%E6%88%8F%402x.jpg" width=730 height=410 />

- Online Education
<img src="https://cloudcache.intl.tencent-cloud.com/cms/backend-cms/dkIZ813_%E5%9C%A8%E7%BA%BF%E6%95%99%E8%82%B2%402x.jpg" width=730 height=410 />

- Online Healthcare
<img src="https://cloudcache.intl.tencent-cloud.com/cms/backend-cms/77Ds965_%E5%9C%A8%E7%BA%BF%E5%8C%BB%E7%96%97%402x.jpg" width=730 height=410 />

- Meeting
<img src="https://cloudcache.intl.tencent-cloud.com/cms/backend-cms/24ZF778_%E5%9C%A8%E7%BA%BF%E4%BC%9A%E8%AE%AE%402x.jpg" width=730 height=410 />

- Smart Device
<img src="https://cloudcache.intl.tencent-cloud.com/cms/backend-cms/yMRc936_%E6%99%BA%E8%83%BD%E8%AE%BE%E5%A4%87%402x%20%281%29.jpg" width=730 height=410 />

- Private Cloud Deployment
<img src="https://cloudcache.intl.tencent-cloud.com/cms/backend-cms/aL7m811_%E7%A7%81%E6%9C%89%E5%8C%96%E9%83%A8%E7%BD%B2%402x.jpg" width=730 height=410 />

## Installation

```javascript
npm install tim-js-sdk --save
// The Tencent Cloud Chat upload plugin is required to send messages such as images and files.
npm install tim-upload-plugin --save
```

## Getting started

```javascript
import TIM from 'tim-js-sdk';
import TIMUploadPlugin from 'tim-upload-plugin';

// Create an SDK instance. The `TIM.create()` method returns the same instance for the same `SDKAppID`.
// The SDK instance is usually represented by `tim`.
let tim = TIM.create({
  SDKAppID: 0 // Replace `0` with the `SDKAppID` of your IM app during access.
}); 

tim.setLogLevel(0); // Common level. You are advised to use this level during connection as it covers more logs.
// tim.setLogLevel(1); // Release level, at which the SDK outputs important information. You are advised to use this log level in a production environment.

// Register the Tencent Cloud Chat upload plugin.
tim.registerPlugin({'tim-upload-plugin': TIMUploadPlugin});
```

## Sending your first message

### 1. Generate UserSig

UserSig is a password used to log in to Tencent Cloud Chat. It is the ciphertext obtained after data such as UserID is encrypted. This [document](https://www.tencentcloud.com/document/product/1047/34385) describes how to generate a UserSig.

### 2. Listen to the SDK_READY event

```javascript
// This event is triggered when the SDK enters the ready state. When detecting this event during listening, the access side can call SDK APIs such as the message sending API to use various features of the SDK
let onSdkReady = function(event) {
  // Now you can create a message instance and send it.
};
tim.on(TIM.EVENT.SDK_READY, onSdkReady);

let onMessageReceived = function(event) {
  // A newly pushed one-to-one message, group message, group tip, or group system notification is received. You can traverse event.data to obtain the message list and render it to the UI.
  // event.name - TIM.EVENT.MESSAGE_RECEIVED
  // event.data - An array that stores Message objects - [Message]
};
tim.on(TIM.EVENT.MESSAGE_RECEIVED, onMessageReceived);

```

### 3. Login in to the Chat SDK

```javascript
let promise = tim.login({userID: 'your userID', userSig: 'your userSig'});
promise.then(function(imResponse) {
  console.log(imResponse.data); // Login successful
  if (imResponse.data.repeatLogin === true) {
    // Indicates that the account has logged in and that the current login will be a repeated login. This feature is supported from v2.5.1.
    console.log(imResponse.data.errorInfo);
  }
}).catch(function(imError) {
  console.warn('login error:', imError); // Error information
});
```

After successful login, to call APIs that require authentication, such as [sendMessage](https://web.sdk.qcloud.com/im/doc/en/SDK.html#sendMessage), you must wait until the SDK enters the ready state (you can obtain the status of the SDK by listening to the [TIM.EVENT.SDK_READY](https://web.sdk.qcloud.com/im/doc/en/module-EVENT.html#.SDK_READY) event).

### 3. Create a message instance

```javascript
let message = tim.createTextMessage({
  to: 'user1',
  conversationType: TIM.TYPES.CONV_C2C,
  payload: {
    text: 'Hello Tencent!'
  },
  // Message custom data (saved in the cloud, will be sent to the peer end, and can still be pulled after the app is uninstalled and reinstalled; supported from v2.10.2)
  // cloudCustomData: 'your cloud custom data'
});
```

### 4. Send the message instance

```javascript
let promise = tim.sendMessage(message);
promise.then(function(imResponse) {
  // The message is sent successfully.
  console.log(imResponse);
}).catch(function(imError) {
  // The message fails to be sent.
  console.warn('sendMessage error:', imError);
});
```

## API Docs & Changelogs

If you want to find out more api docs about tim-js-sdk, go to [Docs](https://web.sdk.qcloud.com/im/doc/en/TIM.html).

If you want to check the record of SDK versions, go to [Change Log](https://www.tencentcloud.com/document/product/1047/34281).

## Supported Browsers

|  Browser   |  Supported versions  |
|  ----  | ----  |
| Chrome | 16 or higher |
| Edge | 	13 or higher |
| Firefox | 11 or higher |
| Safari | 7 or higher |
| Internet Explorer	 | 10 or higher |
| Opera | 12.1 or higher |
| iOS Safari	| 7 or higher |
| Android Browswer | 4.4 (Kitkat) or higher |