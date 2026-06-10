import UIKit
import Flutter

@objc class SceneDelegate: FlutterSceneDelegate {
  private var appleIntelligenceSettingsChannel: FlutterMethodChannel?

  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)
    registerAppleIntelligenceSettingsChannel()
  }

  private func registerAppleIntelligenceSettingsChannel() {
    guard appleIntelligenceSettingsChannel == nil,
          let controller = window?.rootViewController as? FlutterViewController else {
      return
    }

    let channel = FlutterMethodChannel(
      name: "starting_block/apple_intelligence_settings",
      binaryMessenger: controller.binaryMessenger
    )
    channel.setMethodCallHandler { call, result in
      guard call.method == "open" else {
        result(FlutterMethodNotImplemented)
        return
      }
      self.openAppleIntelligenceSettings(result: result)
    }
    appleIntelligenceSettingsChannel = channel
  }

  private func openAppleIntelligenceSettings(result: @escaping FlutterResult) {
    let candidateStrings = [
      "App-prefs:APPLE_INTELLIGENCE_AND_SIRI",
      "App-prefs:root=APPLE_INTELLIGENCE_AND_SIRI",
      "App-prefs:root=SIRI",
      "prefs:root=SIRI"
    ]
    let fallbackURL = URL(string: UIApplication.openSettingsURLString)

    func openCandidate(at index: Int) {
      if index >= candidateStrings.count {
        guard let fallbackURL = fallbackURL else {
          result(false)
          return
        }
        UIApplication.shared.open(fallbackURL, options: [:]) { success in
          result(success)
        }
        return
      }

      guard let url = URL(string: candidateStrings[index]) else {
        openCandidate(at: index + 1)
        return
      }

      UIApplication.shared.open(url, options: [:]) { success in
        if success {
          result(true)
        } else {
          openCandidate(at: index + 1)
        }
      }
    }

    DispatchQueue.main.async {
      openCandidate(at: 0)
    }
  }
}
