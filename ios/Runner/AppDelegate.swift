import UIKit
import Flutter
import flutter_background_service_ios // flutter_background_service


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // flutter_background_service
    SwiftFlutterBackgroundServicePlugin.taskIdentifier = "your.custom.task.identifier"
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
