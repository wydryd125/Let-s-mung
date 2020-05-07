//
//  ViewControllerGenerator.swift
//  PetWalk
//
//  Created by cskim on 2020/01/17.
//  Copyright © 2020 cskim. All rights reserved.
//

import UIKit

final class ViewControllerGenerator {
  enum ViewControllerType {
    case main, signUp, delayWindow
  }
  
  class func make(type: ViewControllerType) -> UIViewController {
    let created: UIViewController
    switch type {
    case .main:
      let mainVC = MainViewController()
      let mainNaviVC = UINavigationController(rootViewController: mainVC)
      mainNaviVC.clearBar()
      mainNaviVC.tabBarItem = UITabBarItem(title: "Main", image: UIImage(named: "탭바메인"), selectedImage: nil)
      mainNaviVC.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
      
      let listVC = PetListController()
      let listNaviVC = UINavigationController(rootViewController: listVC)
      listNaviVC.clearBar()
      listNaviVC.tabBarItem = UITabBarItem(title: "List", image: UIImage(named: "탭바리스트"), selectedImage: nil)
      listNaviVC.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
      
      let tabBarVC = UITabBarController()
      tabBarVC.clearBar()
      tabBarVC.viewControllers = [mainNaviVC, listNaviVC]
      
      created = tabBarVC
    case .signUp:
//      created = TestViewController()
      let signUpVC = LoginViewController()
      let signUpNaviVC = UINavigationController(rootViewController: signUpVC)
      signUpNaviVC.clearBar()
      created = signUpNaviVC
    case .delayWindow:
      let storyboard = UIStoryboard(name: "Main", bundle: .main)
      let vc = storyboard.instantiateViewController(identifier: "LaunchScreenVC")
      created = vc
    }
    created.modalPresentationStyle = .fullScreen
    return created
  }
}
