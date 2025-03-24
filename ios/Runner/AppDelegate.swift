import UIKit
import Flutter

// Add these two import lines
import TIMPush
import tencent_cloud_chat_push
import TUIVoIPExtension

@main
@objc class AppDelegate: FlutterAppDelegate, TIMPushDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        TUIVoIPExtension.setCertificateID(000)
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([any UIUserActivityRestoring]?) -> Void) -> Bool {
        TUIVoIPExtension.call(userActivity)
        return true
    }

    // Add this function
    func businessID() -> Int32 {
        return TencentCloudChatPushFlutterModal.shared.businessID();
    }
    
    
    // Add this function
    func applicationGroupID() -> String {
        return TencentCloudChatPushFlutterModal.shared.applicationGroupID()
    }
    
    // Add this function
    func onRemoteNotificationReceived(_ notice: String?) -> Bool {
        TencentCloudChatPushPlugin.shared.tryNotifyDartOnNotificationClickEvent(notice)
        return true
    }
    
}
