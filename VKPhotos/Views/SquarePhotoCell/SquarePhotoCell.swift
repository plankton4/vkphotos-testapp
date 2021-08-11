//
//  SquarePhotoCell.swift
//  VKPhotos
//
//  Created by Dmitry Iv on 07.08.2021.
//

import UIKit
import Kingfisher

class SquarePhotoCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(urlString: String) {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let url = URL(string: urlString)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            options: [
                .transition(.fade(0.3))
            ])
    }
}
