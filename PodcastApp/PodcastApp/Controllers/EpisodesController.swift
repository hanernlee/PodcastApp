//
//  EpisodesController.swift
//  PodcastApp
//
//  Created by Christopher Lee on 7/5/18.
//  Copyright © 2018 Christopher Lee. All rights reserved.
//

import UIKit
import FeedKit
import Alamofire

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
        let savedPodcasts = UserDefaults.standard.savedPodcasts()
        let hasFavourited = savedPodcasts.index(where: { $0.trackName == self.podcast.trackName && $0.artistName == self.podcast?.artistName }) != nil
        
        if hasFavourited {
            navigationItem.rightBarButtonItems  = [
                UIBarButtonItem(image: #imageLiteral(resourceName: "heart").withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
            ]
        } else {
            navigationItem.rightBarButtonItems  = [
                UIBarButtonItem(title: "Favourite", style: .plain, target: self, action: #selector(handleSaveFavourite)),
            ]
        }
    }
    
    fileprivate func setupTableView() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }
    
    // MARK:- objc func
    @objc fileprivate func handleSaveFavourite() {
        guard let podcast = self.podcast else { return }

        var listOfPodcasts = UserDefaults.standard.savedPodcasts()
        listOfPodcasts.append(podcast)
        
        // Transform Podcast into Data
        let data = NSKeyedArchiver.archivedData(withRootObject: listOfPodcasts)
        UserDefaults.standard.set(data, forKey: favouritedPodcastKey)
        
        showBadgeHighlight()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "heart"), style: .plain, target: nil, action: nil)
    }
    
    fileprivate func showBadgeHighlight() {
        UIApplication.mainTabBarController()?.viewControllers?[0].tabBarItem.badgeValue = "New"
    }
    
    @objc fileprivate func handleFetchSavedPodcasts() {
        guard let data = UserDefaults.standard.data(forKey: favouritedPodcastKey) else { return }
        _ = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Podcast]
    }
    
    // MARK:- UITableView
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let downloadAction = UITableViewRowAction(style: .normal, title: "Download") { (_, _) in
            let episode = self.episodes[indexPath.row]
            UserDefaults.standard.downloadEpisode(episode: episode)
            
            // Download podcast episode using alamofire
            APIService.shared.downloadEpisode(episode: episode)
        }
        
        return [downloadAction]
    }
    
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
