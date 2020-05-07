//
//  WeatherView.swift
//  Temp
//
//  Created by 정유경 on 2020/01/15.
//  Copyright © 2020 정유경. All rights reserved.
//

import UIKit

class WeatherInfoContainer: UIView {
  
  let dustLabel: UILabel = {
    let label = UILabel()
    label.text = "미세먼지"
    label.font = .systemFont(ofSize: 20, weight: .semibold)
    label.textColor = .darkGray
    return label
  }()
  let weatherLabel: UILabel = {
    let label = UILabel()
    label.text = "날씨"
    label.font = .systemFont(ofSize: 20, weight: .semibold)
    label.textColor = .darkGray
    return label
  }()
  let dustImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "좋음")
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  let weatherImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "맑음")
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupConstraints()
  }
  
  func setupUI() {
    
  }
  
  private func createStackView(arrangedSubviews: [UIView]) -> UIStackView {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = UI.spacing
    arrangedSubviews.forEach { stackView.addArrangedSubview($0) }
    return stackView
  }
  
  struct UI {
    static let spacing: CGFloat = 8
    static let imageSize: CGFloat = 24
  }
  func setupConstraints(){
    let weatherStackView = createStackView(arrangedSubviews: [self.weatherLabel, self.weatherImage])
    let dustStackView = createStackView(arrangedSubviews: [self.dustLabel, self.dustImage])
    [weatherStackView, dustStackView].forEach { self.addSubview($0) }
  
    weatherStackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      weatherStackView.topAnchor.constraint(equalTo: self.topAnchor),
      weatherStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      weatherStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
    ])
    
    dustStackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dustStackView.topAnchor.constraint(equalTo: weatherStackView.topAnchor),
      dustStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      dustStackView.bottomAnchor.constraint(equalTo: weatherStackView.bottomAnchor),
      dustStackView.leadingAnchor.constraint(greaterThanOrEqualTo: weatherStackView.trailingAnchor),
    ])
    
    [self.weatherImage, self.dustImage].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.widthAnchor.constraint(equalToConstant: UI.imageSize).isActive = true
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
