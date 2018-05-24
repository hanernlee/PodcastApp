//
//  DownloadsController.swift
//  PodcastApp
//
//  Created by Christopher Lee on 24/5/18.
//  Copyright © 2018 Christopher Lee. All rights reserved.
//

import UIKit

class DownloadsController: UITableViewController {
    
    fileprivate let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    
    // MARK:- Fileprivate
    fileprivate func setupTableView() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
    }
}
