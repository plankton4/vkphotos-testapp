//
//  SplashScreenViewController.swift
//  VKPhotos
//
//  Created by Dmitry Iv on 07.08.2021.
//

import UIKit

class SplashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// Решаем какой экран показать первым, в зависимости от валидности токена
    override func viewDidAppear(_ animated: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let isTokenValid = VKHelper.shared.isTokenValid()
        print("Token is valid? \(isTokenValid)")
        
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            if isTokenValid {
                print("Set MainViewController")
                let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
                sceneDelegate.changeRootViewController(mainViewController)
            } else {
                print("Set LoginViewController")
                let loginViewController = storyboard.instantiateViewController(identifier: "LoginViewController")
                sceneDelegate.changeRootViewController(loginViewController)
            }
        }
    }
}
