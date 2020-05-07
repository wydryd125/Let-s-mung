//
//  ViewController.swift
//  Temp
//
//  Created by 정유경 on 2020/01/15.
//  Copyright © 2020 정유경. All rights reserved.
//
import MapKit
import MobileCoreServices
import UIKit

class WalkViewController: UIViewController {
  
  // MARK: UI
  
  let mapView = PWMapView()
  let timerLabel: UILabel = {
    let label = UILabel()
    label.text = "00 : 00"
    label.textColor = #colorLiteral(red: 0.3996668782, green: 0.3996668782, blue: 0.3996668782, alpha: 1)
    label.font = .systemFont(ofSize: 40)
    label.textAlignment = .center
    label.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    return label
  }()
  let walkLabel: UILabel = {
    let label = UILabel()
    label.text = "산책시간"
    label.textColor = #colorLiteral(red: 0.3996668782, green: 0.3996668782, blue: 0.3996668782, alpha: 1)
    label.font = .systemFont(ofSize: 14)
    label.textAlignment = .center
    label.backgroundColor = .white
    return label
  }()
  var wayButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "방향"), for: .normal)
    button.backgroundColor = #colorLiteral(red: 0.4474043121, green: 0.7858899112, blue: 0.7191998518, alpha: 1)
    button.contentMode = .scaleToFill
    button.addTarget(self, action: #selector(wayButtonTouched), for: .touchUpInside)
    return button
  }()
  
  let vBottom = WalkControl()
  var firstTouchStatus = true
  var changeButtonStatus = true
  let imagePicker = UIImagePickerController()
  var timerText: String {
    String(format: "%02d", self.minutes) + " : " + String(format: "%02d", self.seconds)
  }
  
  // MARK: Timer
  
  var timer = Timer()
  var counter = 0
  var seconds = 0
  var minutes = 0
  
  func startTimer() {
    timer.invalidate()
    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    vBottom.setStatus(status: .stop2)
    vBottom.playButton.alpha = 0
  }
  
  @objc private func timerAction() {
    counter += 1
    seconds = counter % 60
    minutes = counter / 60
    timerLabel.text = self.timerText
  }
  
  // MARK: Walks Info
  
  private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_kr")
    formatter.timeZone = TimeZone(abbreviation: "KST")
//    formatter.dateFormat = "yyyy-MM-dd"
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter
  }()
  
  var pet: Pet?
  private var date: String?
  private var images = [UIImage]()
  
  private func startWalk() {
    self.date = dateFormatter.string(from: Date())
//    PWLocation.shared.startUpdatingLocation()
  }
  
  private func endWalk() {
//    PWLocation.shared.stopUpdatingLocation()
  }
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    PWLocation.shared.checkAuthorizationStatus()
  }
  
  // MARK: Initialize
  
  private func setupUI(){
    self.setupAttributes()
    self.setupMapView()
    self.setupConstraints()
  }
  
  private func setupAttributes() {
    view.backgroundColor = .white
    
    wayButton.layer.cornerRadius = 28
    
    vBottom.delegate = self
    vBottom.playButton.alpha = 0
    vBottom.imagePickerDelegate = self
      
    imagePicker.delegate = self
  }
  
  private func setupMapView() {
//    let goal = CLLocationCoordinate2DMake(37.54771830,127.05742970)
//    let goal = PWLocation.shared.randomGoal
    let goal = PWLocation.shared.randomGoal
    let user = CLLocationCoordinate2DMake(goal.latitude - 0.0001, goal.longitude - 0.0001)
    
    self.mapView.delegate = self
    self.mapView.layer.cornerRadius = 24
    self.mapView.setAnnotation(status: .Home, coordinate: PWLocation.shared.home)
    self.mapView.setAnnotation(status: .User, coordinate: user)
    self.mapView.setAnnotation(status: .Goal, coordinate: goal)
    self.mapView.setUserLocation(coordinate: user)
    PWLocation.shared.delegate(self)
  }
  
  struct UI {
    static let padding: CGFloat = 16
    static let spacing: CGFloat = 8
  }
  
  private func setupConstraints() {
    [self.mapView, self.wayButton, self.vBottom, self.timerLabel, self.walkLabel]
      .forEach { self.view.addSubview($0) }
    
    let guide = self.view.safeAreaLayoutGuide
    self.mapView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.mapView.topAnchor.constraint(equalTo: guide.topAnchor, constant: UI.padding),
      self.mapView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: UI.padding),
      self.mapView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -UI.padding)
    ])
    
    self.wayButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.wayButton.bottomAnchor.constraint(equalTo: self.mapView.bottomAnchor, constant: -UI.spacing * 2),
      self.wayButton.trailingAnchor.constraint(equalTo: self.mapView.trailingAnchor, constant: -UI.spacing * 2),
      self.wayButton.widthAnchor.constraint(equalTo: self.mapView.widthAnchor, multiplier: 0.1),
      self.wayButton.heightAnchor.constraint(equalTo: self.wayButton.widthAnchor, multiplier: 1.0),
    ])
    
    self.walkLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.walkLabel.topAnchor.constraint(equalTo: self.mapView.bottomAnchor, constant: UI.spacing),
      self.walkLabel.leadingAnchor.constraint(equalTo: self.mapView.leadingAnchor),
      self.walkLabel.trailingAnchor.constraint(equalTo: self.mapView.trailingAnchor),
    ])
    
    self.timerLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.timerLabel.topAnchor.constraint(equalTo: self.walkLabel.bottomAnchor, constant: UI.spacing),
      self.timerLabel.leadingAnchor.constraint(equalTo: self.walkLabel.leadingAnchor),
      self.timerLabel.trailingAnchor.constraint(equalTo: self.walkLabel.trailingAnchor),
    ])
    
    self.vBottom.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.vBottom.topAnchor.constraint(equalTo: self.timerLabel.bottomAnchor, constant: UI.padding),
      self.vBottom.leadingAnchor.constraint(equalTo: self.timerLabel.leadingAnchor),
      self.vBottom.trailingAnchor.constraint(equalTo: self.timerLabel.trailingAnchor),
      self.vBottom.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -UI.padding),
    ])
  }
  
  // MARK: Actions
  
  @objc func wayButtonTouched(_ sender: UIButton) {
    let currentUserLocation = self.mapView.getAnnotation(status: .User)
    let currentGoal = self.mapView.getAnnotation(status: .Goal)
    guard currentUserLocation.coordinate.isBelongToArea(center: currentGoal.coordinate, radius: 50) else {
      let alert = UIAlertController(title: "목표 지점에 도착하지 않았어요!", message: nil, preferredStyle: .alert)
      let canelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
      alert.addAction(canelAction)
      present(alert, animated: true)
      return
    }
    guard let goalView = self.mapView.view(for: currentGoal) as? GoalAnnotationView else { return }
    goalView.achieve()
  }
  
  func checkIfAchieve(userLocation: CLLocationCoordinate2D) {
    let currentGoal = self.mapView.getAnnotation(status: .Goal)
    guard userLocation.isBelongToArea(center: currentGoal.coordinate, radius: 50) else { return }
    guard let goalView = self.mapView.view(for: currentGoal) as? GoalAnnotationView else { return }
    goalView.achieve()
  }
  
}



// MARK:- CLLocationManagerDelegate

extension WalkViewController: CLLocationManagerDelegate {
  
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
    print("didUpdateLocations :", current.coordinate)
    if abs(current.timestamp.timeIntervalSinceNow) < 10 {
      self.checkIfAchieve(userLocation: current.coordinate)
      self.mapView.setUserLocation(coordinate: current.coordinate)
      self.mapView.updateAnnotation(status: .User, coordinate: current.coordinate)
    }
  }
}

// MARK:- MKMapViewDelegate

extension WalkViewController: MKMapViewDelegate {

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

// MARK:- BottomViewDelegate, BottomViewImagePickerDelegate

extension WalkViewController: BottomViewDelegate, BottomViewImagePickerDelegate {
  
  func cameraButtonAction() {
    guard UIImagePickerController.isSourceTypeAvailable(.camera)  else { return }
    imagePicker.sourceType = .camera
    let mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)
    imagePicker.mediaTypes = mediaTypes ?? []
    
    // Use Photo
    //    self.images.append(UIImage(named: "")!)
    
    present(imagePicker, animated: true)
  }
  
  func playButtonAction(_ sender: UIButton) {
    switch sender.tag {
    case 0: // PlayButton
      if firstTouchStatus { // firstPlayButton
        startTimer()
        self.startWalk()
        firstTouchStatus = false
      } else {
        if changeButtonStatus { //pause
          timer.invalidate()
          vBottom.setStatus(status: .pause2)
          vBottom.playButton.alpha = 1
          print(changeButtonStatus)
          changeButtonStatus.toggle()
        } else { //stop
          let StopAlert = UIAlertController(title: "산책을 끝내실건가용?", message: "\(pet!.name)의 산책시간 - " + String(format: "%02d", minutes) + " : " + String(format: "%02d", seconds) , preferredStyle: .alert)
          
          let okAlertAction = UIAlertAction(title: "종료", style: .default) { _ in
            self.endWalk()
            
            let loadingVC = LoadingViewController()
            self.present(loadingVC, animated: false)
            
            StorageProvider.uploadWalkImages(self.images, for: self.date!, to: self.pet!) { (urls) in
              let newWalk = Walk(key: "", date: self.date!, duration: String(self.counter), weather: "", dust: "", walkCaptureURLs: urls)
              DataProvider.register(walk: newWalk, to: self.pet!) { (isSucceed) in
                if isSucceed {
                  loadingVC.complete {
                    let recordVC = RecordViewController()
                    recordVC.walkInfo = newWalk
                    recordVC.pet = self.pet!
                    let navi = UINavigationController(rootViewController: recordVC)
                    self.present(navi, animated: true)
                    PetManager.shared.isWalkUpdated = true
                  }
                } else {
                  loadingVC.fail(message: "산책 데이터 저장에 실패했습니다.")
                }
              }
            }
            
            print("Saving...")
          }
          StopAlert.addAction(okAlertAction)
          
          let cancelAlertAction = UIAlertAction(title: "아니요", style: .cancel) { _ in
            self.startTimer()
            self.changeButtonStatus.toggle()
          }
          StopAlert.addAction(cancelAlertAction)
          
          present(StopAlert, animated: true)
        }
      }
      
    default: // SubButton
      startTimer()
      changeButtonStatus.toggle()
    }
  }
}

extension WalkViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let imageType = info[.mediaType] as! NSString
    if UTTypeEqual(imageType, kUTTypeImage) {
      let originImage = info[.originalImage] as! UIImage
      images.append(originImage)
      print("1111", images)
    }
    dismiss(animated: true, completion: nil)
  }
}


