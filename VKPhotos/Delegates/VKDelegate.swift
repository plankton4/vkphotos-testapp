//
//  VKDelegate.swift
//  VKPhotos
//
//  Created by Dmitry Iv on 06.08.2021.
//

import Foundation
import SwiftyVK

class VKDelegate: SwiftyVKDelegate {
    
    let appId = "7918598"
    
    init() {
        VK.setUp(appId: self.appId, delegate: self)
    }
    
    deinit {
        print("VKDelegate destroyed")
    }

    func vkNeedsScopes(for sessionId: String) -> Scopes {
      // Called when SwiftyVK attempts to get access to user account
      // Should return a set of permission scopes
        return []
    }

    func vkNeedToPresent(viewController: VKViewController) {
      // Called when SwiftyVK wants to present UI (e.g. webView or captcha)
      // Should display given view controller from current top view controller
        if let rootController = (UIApplication.shared.windows.first { $0.isKeyWindow })?.rootViewController {
            rootController.present(viewController, animated: true)
        }
    }

    func vkTokenCreated(for sessionId: String, info: [String : String]) {
      // Called when user grants access and SwiftyVK gets new session token
      // Can be used to run SwiftyVK requests and save session data
        print("token created in session \(sessionId) with info \(info)")
    }

    func vkTokenUpdated(for sessionId: String, info: [String : String]) {
      // Called when existing session token has expired and successfully refreshed
      // You don't need to do anything special here
        print("token updated in session \(sessionId) with info \(info)")
    }

    func vkTokenRemoved(for sessionId: String) {
      // Called when user was logged out
      // Use this method to cancel all SwiftyVK requests and remove session data
        print("token removed in session \(sessionId)")
    }
}
