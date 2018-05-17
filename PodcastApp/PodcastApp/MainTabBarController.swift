//
//  MainTabBarController.swift
//  PodcastApp
//
//  Created by Christopher Lee on 5/5/18.
//  Copyright © 2018 Christopher Lee. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .purple
        
        setupViewControllers()
        
        setupPlayerDetailsView()
    }
    
    // MARK:- Setup Player DetailsView
    fileprivate func setupPlayerDetailsView() {
        let playerDetailsView = PlayerDetailsView.initFromNib()
        playerDetailsView.backgroundColor = .red
        playerDetailsView.frame = view.frame
        
//        view.addSubview(playerDetailsView)
        view.insertSubview(playerDetailsView, belowSubview: tabBar)
        
        // Use autolayout
        playerDetailsView.translatesAutoresizingMaskIntoConstraints = false
        playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        playerDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        playerDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    // MARK:- Setup Functions
    func setupViewControllers() {
        viewControllers = [
            generateNavigationController(for: ViewController(), title: "Favorites", image: #imageLiteral(resourceName: "favorites")),
            generateNavigationController(for: PodcastsSearchController(), title: "Search", image: #imageLiteral(resourceName: "search")),
            generateNavigationController(for: ViewController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"))
        ]
    }
    
    // MARK:- Helper Functions
    fileprivate func generateNavigationController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }
}
