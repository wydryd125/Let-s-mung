//
//  UINavigatiionController+Extensions.swift
//  PetWalk
//
//  Created by cskim on 2020/01/17.
//  Copyright © 2020 cskim. All rights reserved.
//

import UIKit

extension UINavigationController {
  func clearBar() {
    self.navigationBar.tintColor = .black
    self.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationBar.shadowImage = UIImage()
  }
}

extension UITabBarController {
  func clearBar() {
    self.tabBar.tintColor = .black
    self.tabBar.backgroundImage = nil
    self.tabBar.isTranslucent = false
  }
}
