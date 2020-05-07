//
//  AppDelegate.swift
//  PetWalk
//
//  Created by cskim on 2020/01/14.
//  Copyright © 2020 cskim. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    
    window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.makeKeyAndVisible()
    
    var rootViewController: UIViewController?
    DataProvider.requestPets { (pets) in
      if pets.isEmpty { rootViewController = ViewControllerGenerator.make(type: .signUp) }
      else {
        PetManager.shared.currentPets = pets
        rootViewController = ViewControllerGenerator.make(type: .main)
      }
      self.window?.rootViewController = rootViewController
      self.transitionEffect(to: rootViewController!)
    }
    window?.rootViewController = ViewControllerGenerator.make(type: .delayWindow)
    
    return true
  }
  
  private func transitionEffect(to newVC: UIViewController) {
    UIView.transition(from: self.window!,
                      to: newVC.view,
                      duration: 0.45,
                      options: .transitionCrossDissolve) { (isFinished) in
                        if isFinished { self.window?.rootViewController = newVC }
    }
  }
}

