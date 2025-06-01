import Flutter
import flutter_local_notifications
import FirebaseCore
import FirebaseMessaging
import app_links

@main
@objc class AppDelegate: FlutterAppDelegate {
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    FirebaseApp.configure()
    
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
        GeneratedPluginRegistrant.register(with: registry)
    }

    GeneratedPluginRegistrant.register(with: self)

    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self
    }

    if let url = AppLinks.shared.getLink(launchOptions: launchOptions) {
        // Handle deep links
        AppLinks.shared.handleLink(url: url)
        return true // Stops propagation to other packages
    }

    application.registerForRemoteNotifications() // Ensure push notifications are registered

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // ✅ Added 'override' to fix the compiler error
  override func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
  }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("🔥 Firebase FCM Token: \(fcmToken ?? "No Token")")
    }
}
