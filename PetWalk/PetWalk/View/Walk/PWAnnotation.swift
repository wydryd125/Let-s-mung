//
//  HomeAnnotationView.swift
//  PetWalk
//
//  Created by cskim on 2020/01/16.
//  Copyright © 2020 cskim. All rights reserved.
//

import UIKit
import MapKit

enum AnnotationStatus: String {
  case Home, Goal, User
}

class PWAnnotation: NSObject, MKAnnotation {
  let title: String?
  var coordinate: CLLocationCoordinate2D
  var currentStatus: AnnotationStatus
  
  init(status: AnnotationStatus = .Home, coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)) {
    self.currentStatus = status
    self.title = status.rawValue
    self.coordinate = coordinate
    super.init()
  }
}
