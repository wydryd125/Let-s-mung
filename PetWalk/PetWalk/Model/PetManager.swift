//
//  PetManager.swift
//  PetWalk
//
//  Created by cskim on 2020/01/24.
//  Copyright © 2020 cskim. All rights reserved.
//

import UIKit

class PetManager {
  static let shared = PetManager()
  private init() { }

  // MARK: Data Caching
  var currentPets = [Pet]()                   // caching when register new pet
  var walksForPet = [String: [Walk]]()        // caching when walk list appear at first or new walk info updated

  // MARK: Image Caching
  var petProfileCache = [String: UIImage]()   // caching when pet list appear at first
  var walkImageCache = [String: [UIImage]]()  // caching when walk list appear at first or new alk info updated
  
  // MARK: Flag
  var isGoalAchieved = false
  var isWalkUpdated = false
}
