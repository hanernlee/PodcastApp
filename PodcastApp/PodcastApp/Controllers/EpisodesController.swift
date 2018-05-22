//
//  EpisodesController.swift
//  PodcastApp
//
//  Created by Christopher Lee on 7/5/18.
//  Copyright © 2018 Christopher Lee. All rights reserved.
//

import UIKit
import FeedKit

class EpisodesController: UITableViewController {
    
    var podcast: Podcast! {
        didSet {
            navigationItem.title = podcast.trackName
            
            fetchEpisodes()
        }
    }
    
    var episodes = [Episode]()

    fileprivate let cellId = "cellId"
    
    let favouritedPodcastKey = "favouritePodcastKey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationBarButtons()
    }
    
    fileprivate func fetchEpisodes() {
        guard let feedURL = podcast.feedUrl else { return }
        
        APIService.shared.fetchEpisodes(feedURL: feedURL) { (episodes) in
            self.episodes = episodes
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK:- Setup Work
    fileprivate func setupNavigationBarButtons() {
        navigationItem.rightBarButtonItems  = [
            UIBarButtonItem(title: "Favourite", style: .plain, target: self, action: #selector(handleSaveFavourite)),
            UIBarButtonItem(title: "Fetch", style: .plain, target: self, action: #selector(handleFetchSavedPodcasts))
        ]
    }
    
    fileprivate func setupTableView() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }
    
    // MARK:- objc func
    @objc fileprivate func handleSaveFavourite() {
        guard let podcast = self.podcast else { return }
        let data = NSKeyedArchiver.archivedData(withRootObject: podcast)
        UserDefaults.standard.set(podcast, forKey: favouritedPodcastKey)
    }
    
    @objc fileprivate func handleFetchSavedPodcasts() {
        let value = UserDefaults.standard.value(forKey: favouritedPodcastKey) as? String
        guard let data = UserDefaults.standard.data(forKey: favouritedPodcastKey) else { return }
        let podcast = NSKeyedUnarchiver.unarchiveObject(with: data) as? Podcast
        
    }
    
    // MARK:- UITableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: episode, playListEpisodes: self.episodes)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        let episode = episodes[indexPath.row]
        cell.episode = episode
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicatorView.color = .darkGray
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.isEmpty ? 200 : 0
    }
}
