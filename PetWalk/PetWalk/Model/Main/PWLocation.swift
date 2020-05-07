//
//  Location.swift
//  PetWalk
//
//  Created by cskim on 2020/01/16.
//  Copyright © 2020 cskim. All rights reserved.
//

import Foundation
import MapKit

class PWLocation {
  
  static let shared = PWLocation()
  private let locationManager = CLLocationManager()
  
  let home = CLLocationCoordinate2DMake(37.54523350,127.05710240)
  let goals = [
      CLLocationCoordinate2DMake(37.54379850,127.05564360),
      CLLocationCoordinate2DMake(37.54771830,127.05742970),
      CLLocationCoordinate2DMake(37.54017970,127.05677830)
  ]
  var randomGoal: CLLocationCoordinate2D {
    self.goals.randomElement() ?? CLLocationCoordinate2DMake(0, 0)
  }
  var current: CLLocationCoordinate2D {
    get { return locationManager.location?.coordinate ?? CLLocationCoordinate2DMake(0, 0) }
  }
  
  // MARK: Interface
  
  func delegate(_ target: CLLocationManagerDelegate) {
    self.locationManager.delegate = target
  }

  func checkAuthorizationStatus() {
    switch CLLocationManager.authorizationStatus() {
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    case .authorizedWhenInUse:
      NSLog("Authorization When In Use")
    case .restricted, .denied:
      NSLog("Authorization Denied")
    default:
      fatalError()
    }
  }
  
  func startUpdatingLocation() {
    guard CLLocationManager.authorizationStatus() == .authorizedWhenInUse,
      CLLocationManager.locationServicesEnabled() else { return }
    
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters   // 대략적인 위치 정확도
    //    locationManager.distanceFilter = 10.0   // 10 미터 이동할 때 마다 갱신. 기본값도 있음. 10m면 정확도 낮춘것
    self.locationManager.startUpdatingLocation()
  }
  
  func stopUpdatingLocation() {
    self.locationManager.stopUpdatingLocation()
  }
  
}
