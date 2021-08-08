//
//  Photos.swift
//  VKPhotos
//
//  Created by Dmitry Iv on 07.08.2021.
//

import Foundation

struct CodablePhotos: Codable {
    var items: [CodablePhoto]
}

struct CodablePhoto: Codable {
    var date: Int
    var sizes: [CodablePhotoSize]
}

struct CodablePhotoSize: Codable {
    var type: String
    var url: String
}
