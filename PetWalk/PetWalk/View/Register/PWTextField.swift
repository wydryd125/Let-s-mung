//
//  PWTextField.swift
//  PetWalk
//
//  Created by cskim on 2020/02/03.
//  Copyright © 2020 cskim. All rights reserved.
//

import UIKit

class PWTextField: UITextField {

  private let underline: UIView = {
    let view = UIView()
    view.backgroundColor = ColorReference.main
    return view
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
    self.borderStyle = .none
    self.autocapitalizationType = .none
    self.autocorrectionType = .no
  }
  
  private func setupConstraints() {
    self.addSubview(self.underline)
    self.underline.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.underline.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 8),
      self.underline.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.underline.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      self.underline.heightAnchor.constraint(equalToConstant: 1),
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
