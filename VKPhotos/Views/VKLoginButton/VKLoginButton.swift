//
//  VKLoginButton.swift
//  VKPhotos
//
//  Created by Dmitry Iv on 07.08.2021.
//

import UIKit

class VKLoginButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class func instanceFromNib() -> VKLoginButton {
        return UINib(nibName: "VKLoginButton", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! VKLoginButton
    }
    
    func configure() {
        backgroundColor = .reversedSystemColor
        setTitleColor(.systemBackground, for: .normal) 
        layer.cornerRadius = 8
        if let superview = superview {
            NSLayoutConstraint.activate([
                self.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 0.872)
            ])
        }
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 56)
        ])
    }

}
