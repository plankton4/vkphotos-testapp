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
                print("Success vk auth \(info)")
                if let successFunc = successFunc {
                    DispatchQueue.main.async {
                        successFunc()
                    }
                }
            },
            onError: { error in
                switch error {
                case .sessionAlreadyAuthorized(_):
                    print("Session already authorized")
                    if let successFunc = successFunc {
                        DispatchQueue.main.async {
                            successFunc()
                        }
                    }
                default:
                    print("Error vk auth \(error)")
                    DispatchQueue.main.async {
                        Utils.showAlert(title: "Error!", message: "Ошибка авторизации")
                    }
                }
            }
        )
    }
    
    func logout() {
        VK.sessions.default.logOut()
        print("VK Logout")
    }
    
    func isTokenValid() -> Bool {
        return VK.sessions.default.accessToken?.isValid ?? false
    }
    
    func getPhotos(callback: ((_ isOk: Bool) -> ())?) {
        print("Get photos")
        VK.API.Photos.get([
            .ownerId: "-128666765", // MobileUp community id
            .albumId: "266276915"
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
            print(error)
            DispatchQueue.main.async {
                Utils.showAlert(title: "Error!", message: "Не удалось получить фото")
            }
        }.send()
    }
}
