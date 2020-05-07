//
//  ColorReference.swift
//  PetWalk
//
//  Created by cskim on 2020/01/17.
//  Copyright © 2020 cskim. All rights reserved.
//

import UIKit

func color(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
  return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
}

struct ColorReference {

  static let main: UIColor = color(red: 114, green: 200, blue: 183, alpha: 1.0)
  static let border: UIColor = .lightGray
  static let activate: UIColor = color(red: 114, green: 200, blue: 183, alpha: 1.0)
  static let deactivate: UIColor = .lightGray
  
  struct Button {
    static let deactivate: UIColor = #colorLiteral(red: 0.7305480647, green: 0.7305480647, blue: 0.7305480647, alpha: 1)
    static let activate: UIColor = #colorLiteral(red: 0.4474043121, green: 0.7858899112, blue: 0.7191998518, alpha: 1)
  }
  
  struct View {
    static let borderColor: CGColor = #colorLiteral(red: 0.7305480647, green: 0.7305480647, blue: 0.7305480647, alpha: 1)
  }
}
