//
//  PodcastsSearchController.swift
//  PodcastApp
//
//  Created by Christopher Lee on 6/5/18.
//  Copyright © 2018 Christopher Lee. All rights reserved.
//

import UIKit
import Alamofire

class PodcastsSearchController: UITableViewController {
    
    var podcasts = [
        Podcast(trackName: "Let's build that app", artistName: "Brian Voong"),
        Podcast(trackName: "Some Podcast", artistName: "Some Author")
    ]
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
    }
    
    // MARK:- Setup UI

    fileprivate func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    fileprivate func setupTableView() {
        // Register Cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    // MARK:- UITableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let podcast = podcasts[indexPath.row]
        cell.textLabel?.text = "\(podcast.trackName ?? "")\n\(podcast.artistName ?? "")"
        cell.textLabel?.numberOfLines = -1
        cell.imageView?.image = #imageLiteral(resourceName: "appicon")
        
        return cell
    }
}

// MARK:- SearchBarDelegate

extension PodcastsSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        APIService.shared.fetchPodcasts(searchText: searchText) { (podcasts) in
            self.podcasts = podcasts
            self.tableView.reloadData()
        }
    }
}
