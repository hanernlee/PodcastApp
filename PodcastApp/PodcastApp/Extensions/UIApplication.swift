//
//  UIApplication.swift
//  PodcastApp
//
//  Created by Christopher Lee on 20/5/18.
//  Copyright © 2018 Christopher Lee. All rights reserved.
//

import UIKit

extension UIApplication {
    static func mainTabBarController() -> MainTabBarController? {
        return shared.keyWindow?.rootViewController as? MainTabBarController
    }
}
