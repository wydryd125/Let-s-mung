//
//  WalkInfoCell.swift
//  PetWalk
//
//  Created by cskim on 2020/01/21.
//  Copyright © 2020 cskim. All rights reserved.
//

import UIKit

final class WalkHistoryCell: UITableViewCell {
  
  static let identifier = String(describing: WalkHistoryCell.self)
  
  let dateLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16)
    return label
  }()
  
  let walkImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 16
    imageView.layer.borderWidth = 2
    imageView.layer.borderColor = ColorReference.main.cgColor
    imageView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    return imageView
  }()
  
  let imageCountLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .bold)
    label.isHidden = true
    label.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    label.layer.cornerRadius = 4
    label.clipsToBounds = true
    return label
  }()

  // MARK: Life Cycle
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.setupConstraints()
  }
  
  override func updateConstraints() {
    super.updateConstraints()
  }
  
  // MARK: Initialize

  private struct UI {
    static let paddingX: CGFloat = 24
    static let paddingY: CGFloat = 8
    static let spacing: CGFloat = 8
  }
  private func setupConstraints() {
    [self.dateLabel, self.walkImageView, self.imageCountLabel].forEach { self.contentView.addSubview($0) }
    
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.dateLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: UI.paddingY),
      self.dateLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: UI.paddingX),
      self.dateLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -UI.paddingX),
    ])
    
    self.walkImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.walkImageView.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: UI.spacing),
      self.walkImageView.leadingAnchor.constraint(equalTo: self.dateLabel.leadingAnchor, constant: UI.paddingX),
      self.walkImageView.trailingAnchor.constraint(equalTo: self.dateLabel.trailingAnchor, constant: -UI.paddingX),
      self.walkImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -UI.paddingY),
      self.walkImageView.heightAnchor.constraint(equalTo: self.walkImageView.widthAnchor, multiplier: 0.7),
    ])
    
    self.imageCountLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.imageCountLabel.topAnchor.constraint(equalTo: self.walkImageView.topAnchor, constant: UI.spacing),
      self.imageCountLabel.trailingAnchor.constraint(equalTo: self.walkImageView.trailingAnchor, constant: -UI.spacing),
    ])
  }

  // MARK: Interface
  
  func updateContents(with walk: Walk) {
    self.dateLabel.text = "\(walk.date) 의 산책 기록"
    
    if let images = PetManager.shared.walkImageCache[walk.key] {
      self.walkImageView.image = images.first
      self.imageCountLabel.isHidden = images.count <= 1
      self.imageCountLabel.text = "+\(images.count - 1)"
    } else {
      StorageProvider.downloadImages(urls: walk.walkCaptureURLs) { (images) in
        PetManager.shared.walkImageCache[walk.key] = images
        self.walkImageView.image = images.first
        self.imageCountLabel.isHidden = images.count <= 1
        self.imageCountLabel.text = "+\(images.count - 1)"
      }
    }
  }
  
  private func timeInterval(startTime: String, endTime: String) -> String {
    let timeFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.locale = Locale(identifier: "ko_kr")
      formatter.timeZone = TimeZone(abbreviation: "KST")
      formatter.dateFormat = "HH:mm:ss"
      return formatter
    }()
    
    guard let start = timeFormatter.date(from: startTime),
      let end = timeFormatter.date(from: endTime) else { return "" }
    let interval = end.timeIntervalSince(start)
    let hour = Int(interval) / 60
    let second = Int(interval) % 60
    let hourStr = String(format: "%02d", hour)
    let secondStr = String(format: "%02d", second)
    return hourStr + ":" + secondStr
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
