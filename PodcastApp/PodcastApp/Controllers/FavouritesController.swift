//
//  FavouritesController.swift
//  PodcastApp
//
//  Created by Christopher Lee on 21/5/18.
//  Copyright © 2018 Christopher Lee. All rights reserved.
//

import UIKit

class FavouritesController: UICollectionViewController {
    
    fileprivate let cellID = "cellID"
    
    var podcasts = UserDefaults.standard.savedPodcasts()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        podcasts = UserDefaults.standard.savedPodcasts()
        collectionView?.reloadData()
        UIApplication.mainTabBarController()?.viewControllers?[0].tabBarItem.badgeValue = nil
    }
    
    // MARK:- Setup Collection View
    fileprivate func setupCollectionView() {
        collectionView?.backgroundColor = .white
        collectionView?.register(FavouritePodcastCell.self, forCellWithReuseIdentifier: cellID)
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView?.addGestureRecognizer(gesture)
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: collectionView)
        guard let selectedIndexPath = collectionView?.indexPathForItem(at: location) else { return }
        
        let alertController = UIAlertController(title: "Remove Podcast?", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            let selectedPodcast = self.podcasts[selectedIndexPath.row]
            self.podcasts.remove(at: selectedIndexPath.row)
            self.collectionView?.deleteItems(at: [selectedIndexPath])
            UserDefaults.standard.deletePodcast(podcast: selectedPodcast)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
    
    // MARK:- Collection View Delegate
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! FavouritePodcastCell
        cell.podcast = podcasts[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let episodesController = EpisodesController()
        episodesController.podcast = self.podcasts[indexPath.row]
        navigationController?.pushViewController(episodesController, animated: true)
    }
}

extension FavouritesController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3 * 16) / 2
        return CGSize(width: width, height: width + 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
