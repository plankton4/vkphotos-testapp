//
//  PhotosModel.swift
//  VKPhotos
//
//  Created by Dmitry Iv on 07.08.2021.
//

import Foundation

class PhotosModel {
    private(set) var photos = [PhotoData]()
    
    func fill(photos: [CodablePhoto]) {
        self.photos.removeAll()
        
        for photo in photos {
            let photoData = PhotoData()
            photoData.date = photo.date
            
            for size in photo.sizes {
                if let type = SizeType(rawValue: size.type) {
                    if !SizeType.allCases.contains(type) {
                        /// нужны только m, x, w
                        continue
                    }
                    
                    photoData.urlDict[type] = size.url
                }
            }
            
            self.photos.append(photoData)
        }
    }
    
    func clearModel() {
        photos.removeAll()
    }
}

class PhotoData {
    
    /// value: Size.url
    fileprivate var urlDict = [SizeType: String]()
    
    var date: Int?
    
    var sUrl: String? {
        return urlDict[.m]
    }
    
    var mUrl: String? {
        return urlDict[.x] ?? sUrl
    }
    
    var lUrl: String? {
        return urlDict[.w] ?? mUrl
    }
}

extension PhotoData: CustomStringConvertible {
    
    var description: String {
        return "\n\nSmall: \(String(describing: sUrl)), \nmedium: \(String(describing: mUrl)), \nlarge: \(String(describing: lUrl))"
    }
}

/**
 m — пропорциональная копия изображения с максимальной стороной 130px,
     используем в ленте фото, которая находится внизу, на экране просмотра отдельного фото
 x — пропорциональная копия изображения с максимальной стороной 604px,
     для главного экрана. где фотки в 2 столбика
 w — пропорциональная копия изображения с максимальным размером 2560x2048px,
     на экране просмотра отдельного фото
 */
fileprivate enum SizeType: String, CaseIterable {
    case m, x, w
}
