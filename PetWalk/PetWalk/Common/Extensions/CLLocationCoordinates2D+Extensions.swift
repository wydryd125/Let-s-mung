//
//  Extensions.swift
//  PetWalk
//
//  Created by cskim on 2020/01/16.
//  Copyright © 2020 cskim. All rights reserved.
//

import MapKit

extension CLLocationCoordinate2D {
  func isEqual(to coordinate: CLLocationCoordinate2D) -> Bool {
    let isEqualLat = (self.latitude == coordinate.latitude)
    let isEqualLong = (self.longitude == coordinate.longitude)
    return isEqualLat && isEqualLong
  }
  
  func distance(from coordinate: CLLocationCoordinate2D) -> Double {
    let currentLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
    let goalLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    return currentLocation.distance(from: goalLocation)
  }
  
  func isBelongToArea(center coordinate: CLLocationCoordinate2D, radius: Double) -> Bool {
    let distance = self.distance(from: coordinate)
    if radius > 0 {
      return distance < abs(radius)
    } else {
      return self.isEqual(to: coordinate)
    }
  }
}
