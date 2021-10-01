//
//  DetailPhotoViewController.swift
//  VKPhotos
//
//  Created by Dmitry Iv on 07.08.2021.
//

import UIKit
import Kingfisher

private let reuseIdentifier = "Cell"

class DetailPhotoViewController: UIViewController {
    
    var imageView: UIImageView!
    var bottomPhotoView: UICollectionView!
    var photos = [PhotoData]()
    var initialIndex = 0
    let bottomViewHeight = 56 // по макету
    let bottomViewBottomMargin = -34 // по макету
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ShareButton"), style: .plain, target: self, action: #selector(sharePhoto))
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let navigationBarFrameHeight = navigationController?.navigationBar.frame.size.height ?? 0
        let bottomNotchHeight = window?.safeAreaInsets.bottom ?? 0
        let shiftValue = navigationBarFrameHeight + statusBarHeight
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(
                equalTo: scrollView.heightAnchor,
                constant: -(shiftValue + bottomNotchHeight)),
            imageView.centerYAnchor.constraint(
                equalTo: scrollView.centerYAnchor,
                constant: -shiftValue)
        ])
        
        setImage(index: initialIndex)
        
        
        /**
         * Горизонтальная лента фото внизу
         */
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        bottomPhotoView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        bottomPhotoView.translatesAutoresizingMaskIntoConstraints = false
        bottomPhotoView.showsHorizontalScrollIndicator = false
        bottomPhotoView.backgroundColor = .systemBackground
        bottomPhotoView.delegate = self
        bottomPhotoView.dataSource = self
        let nibName = UINib(nibName: "SquarePhotoCell", bundle: nil)
        bottomPhotoView.register(nibName, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(bottomPhotoView)
        
        NSLayoutConstraint.activate([
            bottomPhotoView.widthAnchor.constraint(equalTo: view.widthAnchor),
            bottomPhotoView.heightAnchor.constraint(equalToConstant: CGFloat(bottomViewHeight)),
            bottomPhotoView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: CGFloat(bottomViewBottomMargin))
        ])
    }
    
    func setImage(index: Int) {
        if let largeUrl = photos[index].lUrl {
            let url = URL(string: largeUrl)
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(
                with: url,
                options: [
                    .transition(.fade(0.3))
                ])
        }
        updateTitle(index: index)
    }
    
    func updateTitle(index: Int) {
        if let date = photos[index].date {
            let now = Date(timeIntervalSince1970: Double(date))
            let formatter = DateFormatter()
            formatter.locale = Locale.current
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
    
    @objc func sharePhoto() {
        guard let image = imageView.image?.jpegData(compressionQuality: 1) else {
            Utils.showAlert(title: Utils.tr("alert error title"), message: Utils.tr("unknown error"))
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.completionWithItemsHandler = { (_, success, _, error) in
            if success {
                Utils.showAlert(title: Utils.tr("alert success title"), message: Utils.tr("photo saved with success"))
            } else {
                if error != nil {
                    Utils.showAlert(title: Utils.tr("alert error title"), message: Utils.tr("photo saved with error"))
                }
            }
        }
        present(vc, animated: true)
    }
}

extension DetailPhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if !bottomPhotoView.isHidden {
                bottomPhotoView.isHidden = true
            }
        } else {
            if bottomPhotoView.isHidden {
                bottomPhotoView.isHidden = false
            }
        }
    }
}

extension DetailPhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? SquarePhotoCell else {
            fatalError("Unable to dequeue SquarePhotoCell.")
        }
        cell.configure(urlString: photos[indexPath.item].sUrl ?? "")
        
        return cell
    }

   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

       return CGSize(width: bottomViewHeight, height: bottomViewHeight)
   }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setImage(index: indexPath.item)
    }
}
