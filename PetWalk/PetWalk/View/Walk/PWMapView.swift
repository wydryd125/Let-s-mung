//
//  PWMapView.swift
//  PetWalk
//
//  Created by cskim on 2020/01/16.
//  Copyright © 2020 cskim. All rights reserved.
//

import UIKit
import MapKit

class PWMapView: MKMapView {
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupUI()
  }
  
  private func setupUI() {
    self.register(HomeAnnotationView.self, forAnnotationViewWithReuseIdentifier: HomeAnnotationView.identifier)
    self.register(GoalAnnotationView.self, forAnnotationViewWithReuseIdentifier: GoalAnnotationView.identifier)
    self.register(UserAnnotationView.self, forAnnotationViewWithReuseIdentifier: UserAnnotationView.identifier)
  }
  
  // MARK: Interface
  
  func setUserLocation(coordinate: CLLocationCoordinate2D, delta: CLLocationDegrees = 0.002) {
    let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
    let region = MKCoordinateRegion(center: coordinate, span: span)
    self.setRegion(region, animated: true)
  }
  
  func getAnnotation(status: AnnotationStatus) -> PWAnnotation {
    var current: PWAnnotation?
    self.annotations.forEach { (annotation) in
      guard let annotation = annotation as? PWAnnotation else { return }
      if annotation.currentStatus == status {
        current = annotation
      }
    }
    return current ?? PWAnnotation()
  }
  
  func setAnnotation(status: AnnotationStatus, coordinate: CLLocationCoordinate2D) {
    let newAnnotation = PWAnnotation(status: status, coordinate: coordinate)
    self.addAnnotation(newAnnotation)
  }
  
  func removeAnnotation(status: AnnotationStatus) {
    self.annotations.forEach { (annotation) in
      guard let annotation = annotation as? PWAnnotation else { return }
      if status == annotation.currentStatus { self.removeAnnotation(annotation) }
    }
  }
  
  func updateAnnotation(status: AnnotationStatus, coordinate: CLLocationCoordinate2D) {
    self.removeAnnotation(status: status)
    self.setAnnotation(status: status, coordinate: coordinate)
    
//    let userAnnotations = self.annotations
//      .compactMap { $0 as? PWAnnotation}
//      .filter { $0.currentStatus == status }
//    print(userAnnotations)
//
//    if userAnnotations.isEmpty {
//      self.setAnnotation(status: status, coordinate: coordinate)
//    } else {
//
//      UIView.animate(withDuration: 0.3) {
//        userAnnotations.first?.coordinate = coordinate
//        self.layoutIfNeeded()
//      }
////      self.reloadInputViews()
//    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
