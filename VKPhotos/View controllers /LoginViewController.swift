//
//  LoginViewController.swift
//  VKPhotos
//
//  Created by Dmitry Iv on 07.08.2021.
//

import UIKit

class LoginViewController: UIViewController {
    
    var loginButton: VKLoginButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton = VKLoginButton.instanceFromNib()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        loginButton.configure()
        NSLayoutConstraint.activate([
            loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
    
    @objc func login() {
        VKHelper.shared.authorize(successFunc: { [weak self] in
            self?.showNextScreen()
        })
    }
    
    func showNextScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
        
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.changeRootViewController(mainViewController)
        }
    }
}
