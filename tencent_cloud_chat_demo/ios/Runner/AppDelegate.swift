import UIKit
//import Flutter

// Add these two import lines
import tencent_cloud_chat_push
import TIMPush
import ImSDK_Plus

// Add `, TIMPushDelegate` to the following line
@main
@objc class AppDelegate: FlutterAppDelegate, TIMPushDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // Add this function
    @objc func offlinePushCertificateID() -> Int32 {
        return TencentCloudChatPushFlutterModal.shared.offlinePushCertificateID();
    }

    // Add this function
    @objc func businessID() -> Int32 {
        return TencentCloudChatPushFlutterModal.shared.businessID();
    }
    
    // Add this function
    @objc func applicationGroupID() -> String {
        return TencentCloudChatPushFlutterModal.shared.applicationGroupID()
    }
    
    // Add this function
    func onRemoteNotificationReceived(_ notice: String?) -> Bool {
        TencentCloudChatPushPlugin.shared.tryNotifyDartOnNotificationClickEvent(notice)
        return true
    }
}
