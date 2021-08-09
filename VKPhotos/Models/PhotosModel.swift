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
    init() { }
    
    var date: Int?
    
    var sUrl: String? {
        if let url = urlDict[.m] {
            return url
        }
        return nil
    }
    
    var mUrl: String? {
        if let url = urlDict[.x] {
            return url
        }
        return nil
    }
    
    var lUrl: String? {
        if let url = urlDict[.w] {
            return url
        }
        return nil
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
