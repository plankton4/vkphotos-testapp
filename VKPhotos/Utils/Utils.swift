//
//  Utils.swift
//  VKPhotos
//
//  Created by Dmitry Iv on 06.08.2021.
//

import Foundation
import UIKit

class Utils {
    
    static func showAlert(title: String? = nil, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        var rootViewController = (UIApplication.shared.windows.first { $0.isKeyWindow })?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        alertController.addAction(UIAlertAction(title: "👍", style: .default))
        rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
