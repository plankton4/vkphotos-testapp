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
        imageView.setContentHuggingPriority(UILayoutPriority(1), for: .horizontal)
        imageView.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        imageView.setContentCompressionResistancePriority(UILayoutPriority(1), for: .vertical)
        imageView.setContentCompressionResistancePriority(UILayoutPriority(1), for: .horizontal)
        
        let url = URL(string: urlString)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            options: [
                .transition(.fade(0.3))
            ])
    }
}
