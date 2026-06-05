import UIKit
import Flutter
import KakaoSDKAuth

@objc class SceneDelegate: FlutterSceneDelegate {
  override func scene(
    _ scene: UIScene,
    openURLContexts URLContexts: Set<UIOpenURLContext>
  ) {
    if let url = URLContexts.first?.url, AuthApi.isKakaoTalkLoginUrl(url) {
      AuthController.handleOpenUrl(url: url)
      return
    }

    super.scene(scene, openURLContexts: URLContexts)
  }
}
