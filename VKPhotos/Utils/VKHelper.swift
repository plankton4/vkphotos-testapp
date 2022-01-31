//
//  VKHelper.swift
//  VKPhotos
//
//  Created by Dmitry Iv on 06.08.2021.
//

import Foundation
import SwiftyVK

class VKHelper {
    
    static let shared = VKHelper()
    
    private init() { }
    
    func authorize(successFunc: (() -> ())?) {
        VK.sessions.default.logIn(
            onSuccess: { info in
                if let successFunc = successFunc {
                    DispatchQueue.main.async {
                        successFunc()
                    }
                }
            },
            onError: { error in
                switch error {
                case .sessionAlreadyAuthorized(_):
                    if let successFunc = successFunc {
                        DispatchQueue.main.async {
                            successFunc()
                        }
                    }
                default:
                    DispatchQueue.main.async {
                        Utils.showAlert(title: Utils.tr("alert error title"), message: Utils.tr("auth error"))
                    }
                }
            }
        )
    }
    
    func logout() {
        UserData.shared.clearDataOnLogout()
        VK.sessions.default.logOut()
    }
    
    func isTokenValid() -> Bool {
        return VK.sessions.default.accessToken?.isValid ?? false
    }
    
    func getPhotos(callback: ((_ isOk: Bool) -> Void)?) {
        VK.API.Photos.get([
            .ownerId: "-131738005",
            .albumId: "250604539"
        ]).onSuccess { data in
            let decoder = JSONDecoder()
        
            if let parsedPhotos = try? decoder.decode(CodablePhotos.self, from: data) {
                UserData.shared.setPhotos(photos: parsedPhotos.items)
                if let callback = callback {
                    DispatchQueue.main.async {
                        callback(true)
                    }
                }
            }
        }.onError { error in
            DispatchQueue.main.async {
                Utils.showAlert(title: Utils.tr("alert error title"), message: Utils.tr("get photos error"))
            }
        }.send()
    }
}
