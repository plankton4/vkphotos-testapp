//
//  DetailPhotoViewController.swift
//  VKPhotos
//
//  Created by Dmitry Iv on 07.08.2021.
//

import UIKit
import Kingfisher

class DetailPhotoViewController: UIViewController {
    
    var imageView: UIImageView!
    var photos = [PhotoData]()
    var initialIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ShareButton"), style: .plain, target: nil, action: nil)
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        let imageView = UIImageView()
        self.imageView = imageView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let navigationBarFrameHeight = navigationController?.navigationBar.frame.size.height ?? 0
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor,
                                               constant: -((navigationBarFrameHeight + statusBarHeight) / 2)),
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
        
        setImage(index: initialIndex)
    }
    
    func setImage(index: Int) {
        if let largeUrl = photos[index].lUrl {
            let url = URL(string: largeUrl)
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(
                with: url,
                options: [
                    .transition(.fade(0.3)),
                    .forceRefresh
                ])
        }
        updateTitle(index: index)
    }
    
    func updateTitle(index: Int) {
        if let date = photos[index].date {
            let now = Date(timeIntervalSince1970: Double(date))
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            var datetime = formatter.string(from: now)
            
            if datetime.hasSuffix("г.") {
                datetime = String(datetime.dropLast(2))
            }
            
            title = datetime
        }
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DetailPhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
