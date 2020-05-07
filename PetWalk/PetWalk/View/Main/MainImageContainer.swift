//
//  MainImageContainer.swift
//  PetWalk
//
//  Created by cskim on 2020/01/20.
//  Copyright © 2020 cskim. All rights reserved.
//

import UIKit

final class MainImageContainer: UIView {
  private let mainImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "main")
    imageView.layer.cornerRadius = 16
    imageView.layer.masksToBounds = true
    return imageView
  }()
  private let petImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  private let boneImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.image = UIImage(named: "뼈다귀")
    imageView.alpha = 0
    return imageView
  }()
  private let statusImageView : UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.image = UIImage(named: "하트")
    imageView.alpha = 0
    return imageView
  }()
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupUI()
  }
  
  private func setupUI() {
    self.setupAttributes()
    self.setupConstraints()
  }
  
  private func setupAttributes() {
    self.statusImageView.alpha = 0
  }
  
  private struct AnimationDistance {
    static let boneImageY: CGFloat = 500
    static let petImageX: CGFloat = 32
  }
  
  private var petOriginCenter = CGPoint.zero
  override func layoutSubviews() {
    super.layoutSubviews()
    self.petOriginCenter = self.petImageView.center
  }
  
  private struct UI {
    static let spacing: CGFloat = 8
  }
  private func setupConstraints() {
    [self.mainImageView, self.petImageView, self.boneImageView, self.statusImageView]
      .forEach { self.addSubview($0) }
    
    self.mainImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.mainImageView.topAnchor.constraint(equalTo: self.topAnchor),
      self.mainImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.mainImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      self.mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
    ])
    
    self.petImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.petImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -UI.spacing * 2),
      self.petImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -UI.spacing * 3),
      self.petImageView.widthAnchor.constraint(equalTo: self.mainImageView.widthAnchor, multiplier: 0.4),
      self.petImageView.heightAnchor.constraint(equalTo: self.petImageView.widthAnchor),
    ])
    
    self.boneImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.boneImageView.trailingAnchor.constraint(equalTo: self.petImageView.leadingAnchor),
      self.boneImageView.bottomAnchor.constraint(equalTo: self.petImageView.bottomAnchor),
      self.boneImageView.widthAnchor.constraint(equalTo: self.petImageView.widthAnchor, multiplier: 0.5),
      self.boneImageView.heightAnchor.constraint(equalTo: self.boneImageView.widthAnchor),
    ])
    
    self.statusImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.statusImageView.leadingAnchor.constraint(equalTo: self.petImageView.leadingAnchor),
      self.statusImageView.bottomAnchor.constraint(equalTo: self.petImageView.topAnchor),
      self.statusImageView.widthAnchor.constraint(equalTo: self.petImageView.widthAnchor, multiplier: 0.5),
      self.statusImageView.heightAnchor.constraint(equalTo: self.statusImageView.widthAnchor),
    ])
  }
  
  // MARK: Interface
  
  enum AnimationMode {
    case petDefault, animateBone
  }
  func animate(mode: AnimationMode) {
    switch mode {
    case .petDefault:
      self.animatePetDefault()
    case .animateBone:
      self.animateBone()
    }
  }
  
  func setPetImage(_ image: UIImage?) {
    self.petImageView.image = image
  }
  
  // MARK: Animation
  
  private struct AnimateVariation {
    static let dx: CGFloat = 24
    static let dy: CGFloat = 32
  }
  private var shouldAheadForLeft = true {
    willSet {
      if newValue {
        self.petImageView.transform = .identity
      } else {
        self.petImageView.transform = self.petImageView.transform.scaledBy(x: -1, y: 1)
      }
    }
  }
  private var shouldAheadForDown = true
  
  // Looping
  private let maxCount = 4
  private var loopCount = 0
  private let animateCount = 7
  private var tempCount = 0
  
  private func animatePetDefault() {
    UIView.animate(withDuration: 0.2, animations: {
      self.petImageView.center.x = (self.shouldAheadForLeft) ?
        self.petImageView.center.x - AnimateVariation.dx :
        self.petImageView.center.x + AnimateVariation.dx
      
      self.petImageView.center.y = (self.shouldAheadForDown) ?
        self.petImageView.center.y + AnimateVariation.dy :
        self.petImageView.center.y - AnimateVariation.dy
    }) { (isSuccessed) in
      if isSuccessed {
        guard self.loopCount < self.maxCount else {
          self.loopCount = 0
          self.petImageView.center = self.petOriginCenter
          return
        }
        
        if self.tempCount < self.animateCount {
          self.tempCount += 1
          self.shouldAheadForDown.toggle()
          self.animatePetDefault()
        } else {
          self.shouldAheadForLeft.toggle()
          self.shouldAheadForDown.toggle()
          self.tempCount = 0
          self.loopCount += 1
          self.animatePetDefault()
        }
      } else {
        self.petImageView.stopAnimating()
        self.petImageView.center = self.petOriginCenter
        self.shouldAheadForDown = true
        self.shouldAheadForLeft = true
        self.loopCount = 0
        self.tempCount = 0
      }
    }
  }
  
  private func animateBone() {
    self.boneImageView.center.y -= AnimationDistance.boneImageY
    self.boneImageView.alpha = 1
    self.statusImageView.alpha = 1
    UIView.animateKeyframes(
      withDuration: 2,
      delay: 0,
      animations: {
        UIView.addKeyframe(
        withRelativeStartTime: 0.0, relativeDuration: 0.2) {
          self.statusImageView.alpha = 0
          self.boneImageView.center.y += AnimationDistance.boneImageY
          self.petImageView.center.x -= AnimationDistance.petImageX
        }
        UIView.addKeyframe(
        withRelativeStartTime: 0.2, relativeDuration: 0.2) {
          self.statusImageView.alpha = 1
        }
        UIView.addKeyframe(
        withRelativeStartTime: 0.4, relativeDuration: 0.2) {
          self.statusImageView.alpha = 0
        }
        UIView.addKeyframe(
        withRelativeStartTime: 0.6, relativeDuration: 0.2) {
          self.statusImageView.alpha = 1
//          self.boneImageView.center.x += 30
        }
        UIView.addKeyframe(
        withRelativeStartTime: 0.8, relativeDuration: 0.2) {
          self.statusImageView.alpha = 0
          self.boneImageView.alpha = 0
        }
    })
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


