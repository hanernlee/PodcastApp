//
//  EpisodeCell.swift
//  PodcastApp
//
//  Created by Christopher Lee on 8/5/18.
//  Copyright © 2018 Christopher Lee. All rights reserved.
//

import UIKit

class EpisodeCell: UITableViewCell {
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var pubDateLabel: UILabel!
    @IBOutlet weak var episodeImageView: UIImageView!
    
    var episode: Episode! {
        didSet {
            pubDateLabel.text = episode.toDate(from: episode.pubDate)
            titleLabel.text = episode.title
            descriptionLabel.text = episode.description
            let url = URL(string: episode.imageUrl?.toSecureHTTPS() ?? "")
            episodeImageView.sd_setImage(with: url, completed: nil)
        }
    }
}
