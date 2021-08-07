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
    
    func configure(urlString: String, sideLength: CGFloat) {
    
        /// ставим frame, чтобы "DownsamplingImageProcessor(size: imageView.frame.size)" нормально сработал
        self.frame.size = CGSize(width: sideLength, height: sideLength)
        imageView.frame.size = self.frame.size
        
//        print("ImageView boundsSize \(imageView.bounds.size), frame \(imageView.frame.size) \n cell bounds \(self.bounds.size), cell frame \(self.frame.size)")
        
        imageView.setContentHuggingPriority(UILayoutPriority(1), for: .horizontal)
        imageView.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        imageView.setContentCompressionResistancePriority(UILayoutPriority(1), for: .vertical)
        imageView.setContentCompressionResistancePriority(UILayoutPriority(1), for: .horizontal)
        
        let url = URL(string: urlString)
        let processor = DownsamplingImageProcessor(size: imageView.frame.size)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            //placeholder: UIImage(named: "WhyCow"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.3))
            ])
    }
}
