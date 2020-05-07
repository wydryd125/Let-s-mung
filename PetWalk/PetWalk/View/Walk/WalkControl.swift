//
//  BottomView.swift
//  Temp
//
//  Created by 정유경 on 2020/01/15.
//  Copyright © 2020 정유경. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol BottomViewDelegate: class {
  func playButtonAction(_ sender: UIButton)
}
protocol BottomViewImagePickerDelegate: class {
  func cameraButtonAction()
}

class WalkControl: UIView {
  
  // MARK: UI
  
  let stopButton: UIButton = {
    let button = UIButton()
    button.tag = 0
    button.layer.borderColor = #colorLiteral(red: 0.4474043121, green: 0.7858899112, blue: 0.7191998518, alpha: 1)
    button.layer.borderWidth = 8
    button.setImage(UIImage(named: "play"), for: .normal)
    button.addTarget(self, action: #selector(stopButtonTouched), for: .touchUpInside)
    return button
  }()
  let playButton: UIButton = {
    let button = UIButton()
    button.tag = 1
    button.backgroundColor = #colorLiteral(red: 0.4474043121, green: 0.7858899112, blue: 0.7191998518, alpha: 1)
    button.setImage(UIImage(named: "play2"), for: .normal)
    button.addTarget(self, action: #selector(playButtonTouched), for: .touchUpInside)
    return button
  }()
  let cameraButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = #colorLiteral(red: 0.4474043121, green: 0.7858899112, blue: 0.7191998518, alpha: 1)
    button.setImage(UIImage(named: "camera2"), for: .normal)
    button.addTarget(self, action: #selector(cameraButtonTouched), for: .touchUpInside)
    return button
  }()
  
  weak var delegate: BottomViewDelegate?
  weak var imagePickerDelegate: BottomViewImagePickerDelegate?
  
  // play, pause, stop
  enum ButtonStatus: String {
    case play, pause2, stop2
  }
  
  var currentStatus = ButtonStatus.play {
    didSet {
      self.stopButton.setImage(UIImage(named: currentStatus.rawValue), for: .normal)
      self.stopButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
  }
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupConstraints()
  }
  
  private func setupUI() {
    self.stopButton.layer.cornerRadius = UI.buttonSize / 2
    self.playButton.layer.cornerRadius = UI.buttonSize / 4
    self.cameraButton.layer.cornerRadius = UI.buttonSize / 4
  }
  
  private struct UI {
    static let buttonSize: CGFloat = 120
    static let spacing: CGFloat = 32
  }
  
  func setupConstraints() {
    [self.stopButton, self.playButton, self.cameraButton]
      .forEach { self.addSubview($0) }
    
    self.stopButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.stopButton.topAnchor.constraint(equalTo: self.topAnchor),
      self.stopButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      self.stopButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      self.stopButton.widthAnchor.constraint(equalToConstant: UI.buttonSize),
      self.stopButton.heightAnchor.constraint(equalToConstant: UI.buttonSize),
    ])
    
    self.playButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.playButton.trailingAnchor.constraint(equalTo: self.stopButton.leadingAnchor, constant: -UI.spacing),
      self.playButton.centerYAnchor.constraint(equalTo: self.stopButton.centerYAnchor),
      self.playButton.widthAnchor.constraint(equalToConstant: UI.buttonSize / 2),
      self.playButton.heightAnchor.constraint(equalToConstant: UI.buttonSize / 2),
    ])
    
    self.cameraButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.cameraButton.leadingAnchor.constraint(equalTo: self.stopButton.trailingAnchor, constant: UI.spacing),
      self.cameraButton.centerYAnchor.constraint(equalTo: self.stopButton.centerYAnchor),
      self.cameraButton.widthAnchor.constraint(equalToConstant: UI.buttonSize / 2),
      self.cameraButton.heightAnchor.constraint(equalToConstant: UI.buttonSize / 2),
    ])
  }
  
  // MARK: Actions
  
  @objc func stopButtonTouched(_ sender: UIButton) {
    delegate?.playButtonAction(sender)
  }
  
  @objc func playButtonTouched(_ sender: UIButton) {
    stopButton.setImage(UIImage(named: "pause2"), for: .normal)
    delegate?.playButtonAction(sender)
    playButton.alpha = 0
  }
  
  @objc func cameraButtonTouched(_ sender: UIButton) {
    imagePickerDelegate?.cameraButtonAction()
  }
  
  func setStatus(status: ButtonStatus) {
    switch status {
    case .play:
      currentStatus = .pause2
    case .pause2:
      currentStatus = .stop2
    case.stop2:
      currentStatus = .pause2
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
