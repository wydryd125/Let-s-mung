//
//  ImageTouch.swift
//  TrackWithPet
//
//  Created by Sunghyup Kim on 2020/01/15.
//  Copyright © 2020 SunghyupKim. All rights reserved.
//

import UIKit

protocol MyImageViewDelegate: class {
  func imageViewDidTap(_ gender: Gender, value: String)
}

enum Gender: Int {
  case male, female
}

class MyImageView: UIImageView {
  override init(image: UIImage?) {
    super.init(image: image)
    self.isUserInteractionEnabled = true
  }
  
  weak var delegate: MyImageViewDelegate?
  
  var genders = ["M", "W"]
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    guard self.tag < 2 else { return }
    delegate?.imageViewDidTap(Gender(rawValue: self.tag)!, value: genders[self.tag])
    
    
    
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
