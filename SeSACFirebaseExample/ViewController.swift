//
//  ViewController.swift
//  SeSACFirebaseExample
//
//  Created by 강민혜 on 10/5/22.
//

import UIKit
import FirebaseAnalytics

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Analytics.logEvent("rejack", parameters: [
//          "name": "고래밥", // realm이나 유저디폴트에ㅓㅅ 갑을 가져와도 됨, 혹은 랜덤이나
//          "full_text": "안녕하세요",
//        ])
//
//        Analytics.setDefaultEventParameters([
//          "level_name": "Caverns01",
//          "level_difficulty": 4
//        ])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ViewController - viewWillAppear")
    }
    
    @IBAction func profileButtonClicked(_ sender: UIButton) {
        present(ProfileViewController(), animated: true)
    }
    
    @IBAction func settingButtonClicked(_ sender: UIButton) {
        navigationController?.pushViewController(SettingViewController(), animated: true)
    }
    
    @IBAction func crashTapped(_ sender: UIButton) {
    }

}

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ProfileViewController - viewWillAppear")
    }
    
    
}


class SettingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .brown
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SettingViewController - viewWillAppear")
    }
    
    
}


extension UIViewController {
    
    var topViewController: UIViewController? {
        return self.topViewController(currentViewController: self)
    }
    
    // 최상위 뷰컨트롤러를 판단해주는 메서드
    func topViewController(currentViewController: UIViewController) -> UIViewController {
        
        if let tabBarController = currentViewController as? UITabBarController, let selectedViewController = tabBarController.selectedViewController {
            
            return self.topViewController(currentViewController: selectedViewController)
            
        } else if let navigationController = currentViewController as? UINavigationController, let visibleViewController = navigationController.visibleViewController {
            
            return self.topViewController(currentViewController: visibleViewController)
            
        } else if let presentedViewController = currentViewController.presentedViewController {
            
            return self.topViewController(currentViewController: presentedViewController)
            
        } else {
            return currentViewController
        }
        
    }
}


extension UIViewController {
    
    // static
    // 구조체 싱글턴(X) vs 클래스 싱글턴
    // 구조체 싱글턴(X) - 이게 왜 안되는지 공부해봐라.
    
    // 여기서의 class는 오버라이드 역할 (class vs. static)
    class func swizzleMethod() {
        
        let origin = #selector(viewWillAppear)
        let change = #selector(changeViewWillAppear)
        
        guard let originMethod = class_getInstanceMethod(UIViewController.self, origin), let changeMethod = class_getInstanceMethod(UIViewController.self, change) else {
            print("함수를 찾을 수 없거나 오류 발생")
            return
        }
        
        method_exchangeImplementations(originMethod, changeMethod)
    }
    
    @objc func changeViewWillAppear() {
        print("Change ViewWillAppear SUCCEED")
    }
    
    
}














