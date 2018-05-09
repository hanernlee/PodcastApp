//
//  String.swift
//  PodcastApp
//
//  Created by Christopher Lee on 9/5/18.
//  Copyright © 2018 Christopher Lee. All rights reserved.
//

import Foundation

extension String {
    func toSecureHTTPS() -> String {
        return self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
    }
}
