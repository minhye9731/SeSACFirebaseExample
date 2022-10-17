//
//  AppDelegate.swift
//  SeSACFirebaseExample
//
//  Created by 강민혜 on 10/5/22.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let config = Realm.Configuration(schemaVersion: 3) { migration, oldSchemaVersion in
            
            if oldSchemaVersion < 1 { // DetailTodo, List 추가
                
            }
            
            if oldSchemaVersion < 2 { // EmbeddedObject 추가
                
            }
            
            if oldSchemaVersion < 3 { // DetailTodo에 deadline 추가
                
            }
        }
        
        Realm.Configuration.defaultConfiguration = config
        
        
        
        
        
        
        
        
        
        
        
        // aboutRealmMigration()
        
        UIViewController.swizzleMethod()
        
        
        // firebase 초기화
        FirebaseApp.configure()
        
        // 원격 알림 시스템에 앱을 등록
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self // un어쩌구는 권한대리 설정

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        // 메시지 대리자 설정
        Messaging.messaging().delegate = self
        
        // 현재 등록된 토큰 가져오기
        // 꼭 있어야 하는 코드는 아님
        // 실제 유저 입장에서는 이거를 다 실행할 필요가 없음
//        Messaging.messaging().token { token, error in
//          if let error = error {
//            print("Error fetching FCM registration token: \(error)")
//          } else if let token = token {
//            print("FCM registration token: \(token)")
//          }
//        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

// MARK: - migration
extension AppDelegate {
    
    func aboutRealmMigration() {
        // deleteRealmIfMigrationNeeded: 마이그레이션이 필요한 경우 기존 렘 삭제(Realm Browser 닫고 다시 열기!)
        // deleteRealmIfMigrationNeeded 는 개발시에만 쓰자. 실제 출시할땐 이 문구 삭제필요
        //let config = Realm.Configuration(schemaVersion: 1, deleteRealmIfMigrationNeeded: true)
        
        let config = Realm.Configuration(schemaVersion: 6) { migration, oldSchemaVersion in
            
            // 컬럼 단순 추가 삭제의 경우, 별도 코드 필요 X
            if oldSchemaVersion < 1 { }
            
            if oldSchemaVersion < 2 { }
            
            if oldSchemaVersion < 3 {
                migration.renameProperty(onType: Todo.className(), from: "importance", to: "favorite")
            }
            
            if oldSchemaVersion < 4 {
                migration.enumerateObjects(ofType: Todo.className()) { oldObject, newObject in
                    
                    guard let new = newObject else { return }
                    guard let old = oldObject else { return }
                    
                    // 컬럼 단순 추가 삭제의 경우, 별도 코드 필요 X
                    new["userDescription"] = "안녕하세요 \(old["title"])의 중요도는 \(old["favorite"])입니다"
                }
            }
            
            if oldSchemaVersion < 5 {
                migration.enumerateObjects(ofType: Todo.className()) { oldObject, newObject in
                    
                    guard let new = newObject else { return }
                    new["count"] = 100
                }
            }
            
            if oldSchemaVersion < 6 {
                migration.enumerateObjects(ofType: Todo.className()) { oldObject, newObject in
                    
                    guard let new = newObject else { return }
                    guard let old = oldObject else { return }
                    
                    new["favorite"] = old["favorite"] ?? 1.0
                }
            }
        }
        
        
        
        Realm.Configuration.defaultConfiguration = config
    }
    
    
}




// MARK: - push notification
// 애플 내장
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
    }
    
    // foreground 상태에서도 알림 발송되도록 하는 함수
    // 포그라운드 알림 수신: 로컬/푸시 동일
    // ex) 카카오톡: 푸시마다 설정, 화면마다 설정
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // Setting 화면에 있다면 포그라운드 푸시 띄우지 마라
        // 현위치 확인
        guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
        
        if viewController is SettingViewController {
            // 제약 조건을 다르게 설정할 수도 있음
            completionHandler([]) // 아무것도 없으면 알림이 안온다.
        } else {
            // .banner, .list: iOS14+
            completionHandler([.badge, .sound, .banner, .list])
        }

    }
    
    // 푸시 클릭: 호두과자 장바구니 담는 화면
    // 유저가 푸시를 클릭했을 때에만 수신 확인 가능
    // 특정 푸시를 클릭하면 특정 상세 화면으로 화면 전환
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        print("사용자가 푸시를 클릭했습니다.")
        
        print(response.notification.request.content.body)
        print(response.notification.request.content.userInfo)
        
        let userInfo = response.notification.request.content.userInfo
        
        if userInfo[AnyHashable("sesac")] as? String == "project" {
            print("SESAC PROJECT")
        } else {
            print("NOTHING")
        }
        
        // 현위치 확인
        guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
        
        print(viewController)
        
        // 현재뷰가 뷰컨이라면, 설정화면으로 상세하게 들어가주자
        if viewController is ViewController {
            viewController.navigationController?.pushViewController(SettingViewController(), animated: true)
        } else if viewController is ProfileViewController {
            // 현재뷰가 프로필이라면, 자동으로 dismiss 시켜주자
            viewController.dismiss(animated: true)
        } else if viewController is SettingViewController {
            viewController.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
}

// firebase
extension AppDelegate: MessagingDelegate {
    
    // 토큰 갱신 모니터링 : 토큰 정보가 언제 바뀔까?
    // 현재 토큰은 아래 didReceiveRegistrationToken 함수의 fcmToken를 통해서도 알 수 있음
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }

}
