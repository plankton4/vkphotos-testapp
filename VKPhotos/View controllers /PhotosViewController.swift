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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        requestVKPhotos()
    }
    
    
    /// для поддержки поворотов экрана
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        updateCellSize(parentSize: size)
    }
    
    func setupView() {
        navigationController?.navigationBar.tintColor = .reversedSystemColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Utils.tr("quit button"), style: .plain, target: self, action: #selector(logout))

        let nibName = UINib(nibName: "SquarePhotoCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: reuseIdentifier)
        
        if let collectionViewFlowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewFlowLayout.estimatedItemSize = .zero
            collectionViewFlowLayout.minimumLineSpacing = 2.0
            updateCellSize(parentSize: CGSize(width: view.bounds.width,
                                              height: view.bounds.height))
        }
    }
    
    func updateCellSize(parentSize: CGSize) {
        if let collectionViewFlowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            
            let isPortrait = parentSize.width < parentSize.height
            let cellSideLength = isPortrait
                ? (parentSize.width / 2 - 1)
                : (parentSize.width / 4 - 1)
            let cellSize = CGSize(width: cellSideLength, height: cellSideLength)
            collectionViewFlowLayout.itemSize = cellSize
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? SquarePhotoCell else {
            fatalError("Unable to dequeue SquarePhotoCell.")
        }
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
