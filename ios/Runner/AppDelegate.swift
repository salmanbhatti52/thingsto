import UIKit
import Flutter

@UIApplicationMain
GMSServices.provideAPIKey("AIzaSyCl2SWUH5dWbv7VDO9wKaP335h_aIPmX5w")
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
