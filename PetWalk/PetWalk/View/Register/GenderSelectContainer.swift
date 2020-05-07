//
//  GenderSelectContainer.swift
//  PetWalk
//
//  Created by cskim on 2020/02/03.
//  Copyright © 2020 cskim. All rights reserved.
//

import UIKit

class GenderSelectContainer: UIView {
  
  // MARK: UI
  
  struct UI {
    static let padddingY: CGFloat = 24
    static let padddingX: CGFloat = 32
    static let spacing: CGFloat = 48
    static let imageSize: CGFloat = 80
  }
  
  private let maleImageView = GenderImageView(type: .male)
  private let femaleImageView = GenderImageView(type: .female)
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.layer.borderWidth = 1
    self.layer.borderColor = ColorReference.border.cgColor
    self.layer.cornerRadius = 16
    self.setupConstraints()
  }
  
  private func setupConstraints() {
    let subviews = [self.maleImageView, self.femaleImageView]
    subviews.forEach {
      self.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    NSLayoutConstraint.activate([
      self.maleImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: UI.padddingY),
      self.maleImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: UI.padddingX),
      self.maleImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -UI.padddingY),
      self.maleImageView.widthAnchor.constraint(equalToConstant: UI.imageSize),
      self.maleImageView.heightAnchor.constraint(equalToConstant: UI.imageSize),
    ])
    
    NSLayoutConstraint.activate([
      self.femaleImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: UI.padddingY),
      self.femaleImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -UI.padddingY),
      self.femaleImageView.leadingAnchor.constraint(equalTo: self.maleImageView.trailingAnchor, constant: UI.spacing),
      self.femaleImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -UI.padddingX),
      self.femaleImageView.widthAnchor.constraint(equalToConstant: UI.imageSize),
      self.femaleImageView.heightAnchor.constraint(equalToConstant: UI.imageSize),
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
