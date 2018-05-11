//
//  PlayerDetailsView.swift
//  PodcastApp
//
//  Created by Christopher Lee on 11/5/18.
//  Copyright © 2018 Christopher Lee. All rights reserved.
//

import UIKit

class PlayerDetailsView: UIView {
    var episode: Episode! {
        didSet {
            titleLabel.text = episode.title
            guard let url = URL(string: episode.imageUrl ?? "") else { return }
            episodeImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    @IBAction func handleDismiss(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}
