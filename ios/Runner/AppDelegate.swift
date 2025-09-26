import UIKit
import Flutter

import UIKit
import Flutter
import Firebase // 👈 ye import zaroori hai

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

      FirebaseApp.configure() // 👈 yeh line zaroori hai
      GeneratedPluginRegistrant.register(with: self)

      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
