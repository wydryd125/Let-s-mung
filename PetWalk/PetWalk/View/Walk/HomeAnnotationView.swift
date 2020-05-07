//
//  HomeAnnotationView.swift
//  PetWalk
//
//  Created by cskim on 2020/01/16.
//  Copyright © 2020 cskim. All rights reserved.
//

import UIKit
import MapKit

class HomeAnnotationView: MKAnnotationView {
  
  static let identifier = String(describing: HomeAnnotationView.self)
  private let imageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(systemName: "house.fill"))
    imageView.tintColor = .red
    return imageView
  }()
  
  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    self.addSubview(imageView)
    imageView.frame.size = CGSize(width: 24, height: 24)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
