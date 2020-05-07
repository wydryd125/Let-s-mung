//
//  GenderImageVIew.swift
//  PetWalk
//
//  Created by cskim on 2020/02/03.
//  Copyright © 2020 cskim. All rights reserved.
//

import UIKit

enum GenderType {
  case male, female
}

protocol GenderImageViewDelegate: class {
  func genderImageView(_ imageView: GenderImageView, didSelelcted for: GenderType)
}

class GenderImageView: UIImageView {
  
  private let type: GenderType
  private weak var delegate: GenderImageViewDelegate?
  
  // MARK: Initialize
  
  init(type: GenderType) {
    self.type = type
    switch type {
    case .male:
      super.init(image: UIImage(named: ImageReference.Gender.male.rawValue))
    default:
      super.init(image: UIImage(named: ImageReference.Gender.female.rawValue))
    }
    self.isUserInteractionEnabled = true
    self.contentMode = .scaleAspectFit
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    delegate?.genderImageView(self, didSelelcted: self.type)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
