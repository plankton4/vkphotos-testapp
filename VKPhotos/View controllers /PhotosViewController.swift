//
//  PhotosViewController.swift
//  VKPhotos
//
//  Created by Dmitry Iv on 07.08.2021.
//

import UIKit
import Kingfisher

private let reuseIdentifier = "Cell"

class PhotosViewController: UICollectionViewController {
    
    var photos = [PhotoData]()
    var cellSideLength: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .reversedSystemColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Utils.tr("quit button"), style: .plain, target: self, action: #selector(logout))
        cellSideLength = view.frame.width * 0.5 - 1

        let nibName = UINib(nibName: "SquarePhotoCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: reuseIdentifier)
        
        requestVKPhotos()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let collectionViewFlowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewFlowLayout.estimatedItemSize = .zero
            
            let cellSize = CGSize(width: cellSideLength, height: cellSideLength)
            collectionViewFlowLayout.itemSize = cellSize
            collectionViewFlowLayout.minimumLineSpacing = 2.0
        }
    }
    
    @objc func logout() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(identifier: "LoginViewController")
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.changeRootViewController(loginViewController)
        }
        VKHelper.shared.logout()
    }
    
    func requestVKPhotos() {
        VKHelper.shared.getPhotos { [weak self] isOk in
            if isOk {
                self?.reload()
            }
        }
    }
    
    func reload() {
        photos = UserData.shared.photos
        collectionView.reloadData()
    }

}

extension PhotosViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SquarePhotoCell
        cell.configure(urlString: photos[indexPath.item].mUrl ?? "")
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailPhotoViewController") as? DetailPhotoViewController
        {
            vc.initialIndex = indexPath.item
            vc.photos = UserData.shared.photos
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
