//
//  UserData.swift
//  VKPhotos
//
//  Created by Dmitry Iv on 07.08.2021.
//

import Foundation

class UserData {
    
    static let shared = UserData()
    private let photosModel: PhotosModel
    var photos: [PhotoData] {
        photosModel.photos
    }
    
    private init() {
        photosModel = PhotosModel()
    }
    
    func setPhotos(photos: [CodablePhoto]) {
        photosModel.fill(photos: photos)
    }
}
