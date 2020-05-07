//
//  Structure.swift
//  PetWalk
//
//  Created by cskim on 2020/01/15.
//  Copyright © 2020 cskim. All rights reserved.
//

import Foundation

struct Pet {
  static let breeds = ["푸들", "시츄", "닥스훈트", "리트리버", "치와와", "비숑", "말티즈", "웰시코기", "비글", "기타"]
  
  let key: String
  let name: String
  let breed: String
  let gender: String
  let birth: String
  let weight: String
  let profileURL: String
  
  func keyValueRepresentation() -> [String: Any]{
    return [
      PetReference.key: self.key,
      PetReference.name: self.name,
      PetReference.breed: self.breed,
      PetReference.gender: self.gender,
      PetReference.birth: self.birth,
      PetReference.weight: self.weight,
      PetReference.profileURL: self.profileURL
    ]
  }
  
  static func create(with data: [String: Any]) -> Pet? {
    guard
      let key = data[PetReference.key] as? String,
      let name = data[PetReference.name] as? String,
      let breed = data[PetReference.breed] as? String,
      let gender = data[PetReference.gender] as? String,
      let profileURL = data[PetReference.profileURL] as? String,
      let birth = data[PetReference.birth] as? String,
      let weight = data[PetReference.weight] as? String
    else { return nil }
    return Pet(key: key,
               name: name,
               breed: breed,
               gender: gender,
               birth: birth,
               weight: weight,
               profileURL: profileURL)
  }
}

struct PetReference {
  static let key = "key"
  static let name = "name"
  static let breed = "breed"
  static let gender = "gender"
  static let birth = "birth"
  static let weight = "weight"
  static let profileURL = "profileURL"
}
