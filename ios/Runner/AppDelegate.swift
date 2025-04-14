import UIKit
import Flutter
import KakaoSDKCommon
import KakaoSDKAuth

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // Kakao SDK 초기화 (앱 키를 사용하여 초기화)
    KakaoSDK.initSDK(appKey: "49b9cdd5c3366e805ef2180657040178")
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // URL 리다이렉션 처리 메서드
  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    var applicationResult = false

    // Kakao 로그인 URL 처리
    if AuthApi.isKakaoTalkLoginUrl(url) {
        applicationResult = AuthController.handleOpenUrl(url: url)
    }

    // 기타 URL 처리가 필요한 경우 (없다면 생략 가능)
    if !applicationResult {
        applicationResult = super.application(app, open: url, options: options)
    }

    return applicationResult
  }
}
