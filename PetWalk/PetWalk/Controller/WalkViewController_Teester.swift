//
//  ViewController.swift
//  PetWalk
//
//  Created by cskim on 2020/01/14.
//  Copyright © 2020 cskim. All rights reserved.
//

import UIKit
import MapKit

final class WalkViewController: UIViewController {
  
  private let mapView = PWMapView()
  
  // MARK: Initialize
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  private func setupUI() {
    self.view.backgroundColor = .systemBackground
    self.setupAttributes()
    self.setupConstraints()
  }
  
  private func setupAttributes() {
    self.mapView.delegate = self
    PWLocation.shared.checkAuthorizationStatus()
  }
  
  private func setupConstraints() {
    self.view.addSubview(self.mapView)
    let guide = self.view.safeAreaLayoutGuide
    self.mapView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.mapView.topAnchor.constraint(equalTo: guide.topAnchor),
      self.mapView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
      self.mapView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
      self.mapView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
    ])
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.mapView.setUserLocation(coordinate: PWLocation.shared.home, delta: 0.002)
    self.mapView.setAnnotation(status: .User, coordinate: PWLocation.shared.home)
    self.mapView.setAnnotation(status: .Home, coordinate: PWLocation.shared.home)
    self.mapView.setAnnotation(status: .Goal, coordinate: PWLocation.shared.home)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    // TESTER : 화면 터치했을 때 home과 동일한 위치에 있는 goal의 색을 바꾸기
    self.tapAchieveButton()
  }
  
  @objc private func tapAchieveButton() {
    let currentUserLocation = PWLocation.shared.home
//    guard let currentUserLocation = PWLocation.shared.currentLocation else { return }
    let currentGoal = self.mapView.getAnnotation(status: .Goal)
    guard currentUserLocation.isBelongToArea(center: currentGoal.coordinate, radius: 10) else { return }
    guard let goalView = self.mapView.view(for: currentGoal) as? GoalAnnotationView else { return }
    goalView.achieve()
  }
}

// MARK:- MKMapViewDelegate

extension WalkViewController: MKMapViewDelegate {
  
  // 권한 변경되는 것 체크
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .authorizedWhenInUse, .authorizedAlways:
      print("Authorized")
    default:
      print("Unauthorized")
    }
  }
  
  // startUpdatingLocation 실행 후 호출?
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    // location이 있어야 호출되므로 반드시 하나는 가지고 있음
    guard let current = locations.last else { return }
    if abs(current.timestamp.timeIntervalSinceNow) < 10 {
      self.mapView.updateUserLocation(coordinate: current.coordinate)
      self.mapView.setAnnotation(status: .User, coordinate: current.coordinate)
    }
  }
  
  // Set Annotation View
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let annotation = annotation as? PWAnnotation else { return nil }
    let identifier: String
    switch annotation.currentStatus {
    case .Home:
      identifier = HomeAnnotationView.identifier
    case .Goal:
      identifier = GoalAnnotationView.identifier
    case .User:
      identifier = UserAnnotationView.identifier
    }
    let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier, for: annotation)
    return annotationView
  }
}
