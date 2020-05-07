//
//  CustomPetInfoViewCell.swift
//  petInfo2
//
//  Created by Sunghyup Kim on 2020/01/17.
//  Copyright © 2020 SunghyupKim. All rights reserved.
//

import UIKit

final class PetInfoCell: UITableViewCell {
  
  static let identifier = String(describing: PetInfoCell.self)
  
  private let profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = UI.imageSize / 2
    imageView.layer.borderWidth = 2
    imageView.layer.borderColor = ColorReference.main.cgColor
    imageView.clipsToBounds = true
    return imageView
  }()
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 22)
    label.textColor = .systemGray
    return label
  }()
  
  let breedLabel:UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.textColor =  .white
    label.backgroundColor = #colorLiteral(red: 0.4474043121, green: 0.7858899112, blue: 0.7191998518, alpha: 1)
    label.layer.cornerRadius = 4
    label.clipsToBounds = true
    return label
  }()

  // MARK: Initialize
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    print("========== Init ==========")
    self.setupUI()
  }
  
  private func setupUI() {
    self.setupAttributes()
    self.setupConstraints()
  }
  
  private func setupAttributes() {
//    self.accessoryType = .disclosureIndicator
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    print("========== Layout Subviews ==========")
  }
  
  override func updateConstraints() {
    super.updateConstraints()
    print("========== Update Constraints ==========")
  }

  private struct UI {
    static let paddingX: CGFloat = 24
    static let paddingY: CGFloat = 8
    static let spacing: CGFloat = 8
    static let imageSize: CGFloat = 80
  }
  private func setupConstraints(){
    [self.profileImageView, self.nameLabel, self.breedLabel]
      .forEach { self.addSubview($0) }
    print("========== Setup Constraints ==========")
    self.profileImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: UI.paddingY),
      self.profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: UI.paddingX),
      self.profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -UI.paddingY),
      self.profileImageView.widthAnchor.constraint(equalToConstant: UI.imageSize),
      self.profileImageView.heightAnchor.constraint(equalTo: self.profileImageView.widthAnchor, multiplier: 1.0),
    ])
    
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
//      self.nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
      self.nameLabel.bottomAnchor.constraint(equalTo: self.profileImageView.centerYAnchor),
      self.nameLabel.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: UI.spacing),
    ])

    self.breedLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.breedLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: UI.spacing),
      self.breedLabel.leadingAnchor.constraint(equalTo: self.nameLabel.leadingAnchor),
//      self.breedLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
    ])
  }
  
  // MARK: Interface
  
  func updateContents(with pet: Pet) {
    if let profileImage = PetManager.shared.petProfileCache[pet.name] {
      self.profileImageView.image = profileImage
    } else {
      StorageProvider.downloadImage(url: pet.profileURL) { (image) in
        self.profileImageView.image = image
        PetManager.shared.petProfileCache[pet.name] = image
      }
    }
    self.nameLabel.text = pet.name
    self.breedLabel.text = pet.breed
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
