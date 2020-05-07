//
//  WalkModel.swift
//  PetWalk
//
//  Created by cskim on 2020/01/15.
//  Copyright © 2020 cskim. All rights reserved.
//

import Foundation

struct Walk {
  let key: String
  let date: String
  let duration: String
  let weather: String
  let dust: String
  let walkCaptureURLs: [String]
  
  func keyValueRepresentation() -> [String: Any] {
    return [
      WalkReference.key: self.key,
      WalkReference.date: self.date,
      WalkReference.duration: self.duration,
      WalkReference.weather: self.weather,
      WalkReference.dust: self.dust,
      WalkReference.walkCaptureURLs: self.walkCaptureURLs
    ]
  }
  
  static func create(with data: [String: Any]) -> Walk? {
    guard
      let key = data[WalkReference.key] as? String,
      let date = data[WalkReference.date] as? String,
      let duration = data[WalkReference.duration] as? String,
      let weather = data[WalkReference.weather] as? String,
      let dust = data[WalkReference.dust] as? String,
      let images = data[WalkReference.walkCaptureURLs] as? [String]
      else { return nil }
    return Walk(key: key,
                date: date,
                duration: duration,
                weather: weather,
                dust: dust,
                walkCaptureURLs: images)
  }
}

struct WalkReference {
  static let key = "key"
  static let date = "date"
  static let duration = "duration"
  static let weather = "weather"
  static let dust = "dust"
  static let walkCaptureURLs = "images"
}
