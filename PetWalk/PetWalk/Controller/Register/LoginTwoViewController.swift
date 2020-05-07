//
//  ViewController.swift
//  TrackWithPet
//
//  Created by Sunghyup Kim on 2020/01/15.
//  Copyright © 2020 SunghyupKim. All rights reserved.
//

import UIKit


class LoginTwoViewController: UIViewController {
  
  let genderLabel: UILabel = {
    let label = UILabel()
    label.text = "아이의 성별을 알려주세요"
    label.font = .systemFont(ofSize: 24, weight: .bold)
    label.tintColor = .black
    return label
  }()
  let genderImageBox: UIView = {
    let box = UIView()
    box.layer.borderColor = ColorReference.View.borderColor
    box.layer.borderWidth = 1
    box.layer.cornerRadius = 20
    return box
  }()
  let maleImage: MyImageView = {
    let imageView = MyImageView(image: UIImage(named: "male"))
    imageView.layer.cornerRadius = 44
    imageView.contentMode = .scaleAspectFit
    imageView.tag = 0
    return imageView
  }()
  let femaleImage: MyImageView = {
    let imageView = MyImageView(image: UIImage(named: "female"))
    imageView.layer.cornerRadius = 44
    imageView.contentMode = .scaleAspectFit
    imageView.tag = 1
    return imageView
  }()
  
  let breedLabel: UILabel = {
    let label = UILabel()
    label.text = "아이의 견종을 알려주세요"
    label.font = .systemFont(ofSize: 24, weight: .bold)
    return label
  }()
  let breedSelectButton: UIButton = {
    let button = UIButton()
    button.layer.cornerRadius = 16
    button.setTitle("선   택", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
    button.setTitleColor(.white, for: .normal)
    button.addTarget(self, action: #selector(breedSelectTouched), for: .touchUpInside)
    button.backgroundColor = ColorReference.Button.deactivate
    return button
  }()
  
  let nextButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = ColorReference.Button.deactivate
    button.setTitle("다   음", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
    button.addTarget(self, action: #selector(nextTouched), for: .touchUpInside)
    return button
  }()
  let underline: UIView = {
    let line = UIView()
    line.backgroundColor = ColorReference.main
    return line
  }()
  let breedPickerView = UIPickerView()
  
  // MARK: Temp
  
  private var pickerValue = ""
  private var isGenderSelected = false {
    didSet {
      let shouldNext = self.isGenderSelected && self.petBreed != nil
      self.nextButton.backgroundColor = shouldNext ? ColorReference.activate : ColorReference.deactivate
    }
  }
  
  // MARK: Dispatche Data
  
  var petName: String?
  var petGender : String?
  var petBreed : String? {
    didSet {
      let shouldNext = self.isGenderSelected && self.petBreed != nil
      self.breedSelectButton.backgroundColor = ColorReference.activate
      self.nextButton.backgroundColor = shouldNext ? ColorReference.activate : ColorReference.deactivate
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    breedPickerView.delegate = self
    breedPickerView.dataSource = self
    setUpUI()
  }
  
  func setUpUI(){
    self.navigationItem.title = "반려견 등록하기"
    self.view.backgroundColor = .systemBackground
    
    let views = [genderLabel, genderImageBox, underline, nextButton, breedLabel, breedSelectButton]
    views.forEach { self.view.addSubview($0) }
    [femaleImage, maleImage].forEach {
      $0.delegate = self
      self.genderImageBox.addSubview($0)
    }
    
    self.setNavigationBar()
    self.setupConstraints()
  }
  
  private struct UI {
    static var paddingX: CGFloat {
      get { return UIScreen.main.bounds.width / 10 }
    }
    static var paddingY: CGFloat {
      get { return UIScreen.main.bounds.height / 10 }
    }
    static let spacing: CGFloat = 16
    static let buttonHeightRatio: CGFloat = 0.15
    static let imageBoxHeight: CGFloat = 200
    static let buttonHeight: CGFloat = 48
  }
  func setupConstraints() {
    let guide = self.view.safeAreaLayoutGuide
    self.genderLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.genderLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: UI.paddingY),
      genderLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: UI.paddingX),
      genderLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -UI.paddingX),
    ])
    
    self.genderImageBox.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.genderImageBox.topAnchor.constraint(equalTo: self.genderLabel.bottomAnchor, constant: UI.spacing / 2),
      self.genderImageBox.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: UI.paddingX + 8),
      self.genderImageBox.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -UI.paddingX - 8),
      self.genderImageBox.heightAnchor.constraint(equalToConstant: UI.imageBoxHeight),
    ])
    
    femaleImage.translatesAutoresizingMaskIntoConstraints = false
    femaleImage.centerYAnchor.constraint(equalTo: genderImageBox.centerYAnchor).isActive = true
    femaleImage.leadingAnchor.constraint(equalTo: genderImageBox.leadingAnchor, constant: 40).isActive = true
    femaleImage.widthAnchor.constraint(equalToConstant: 88).isActive = true
    femaleImage.heightAnchor.constraint(equalToConstant: 88).isActive = true
    
    maleImage.translatesAutoresizingMaskIntoConstraints = false
    maleImage.centerYAnchor.constraint(equalTo: genderImageBox.centerYAnchor).isActive = true
    maleImage.trailingAnchor.constraint(equalTo: genderImageBox.trailingAnchor, constant: -40).isActive = true
    maleImage.widthAnchor.constraint(equalToConstant: 88).isActive = true
    maleImage.heightAnchor.constraint(equalToConstant: 88).isActive = true
    
    breedLabel.translatesAutoresizingMaskIntoConstraints = false
    breedLabel.topAnchor.constraint(equalTo: genderImageBox.bottomAnchor, constant: UI.paddingY).isActive = true
    breedLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: UI.paddingX).isActive = true
    breedLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -UI.paddingX).isActive = true
    
    breedSelectButton.translatesAutoresizingMaskIntoConstraints = false
    breedSelectButton.topAnchor.constraint(equalTo: breedLabel.bottomAnchor, constant: UI.spacing / 2).isActive = true
    breedSelectButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: UI.paddingX + 8).isActive = true
    breedSelectButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -UI.paddingX - 8).isActive = true
    breedSelectButton.heightAnchor.constraint(equalToConstant: UI.buttonHeight).isActive = true
    
    nextButton.translatesAutoresizingMaskIntoConstraints = false
    nextButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
    nextButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
    nextButton.heightAnchor.constraint(equalTo: guide.heightAnchor, multiplier: UI.buttonHeightRatio).isActive = true
    nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
  }
  
  func setNavigationBar(){
    let dismissItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backTouched))
    dismissItem.tintColor = .black
    self.navigationItem.leftBarButtonItem = dismissItem
  }
  
  @objc func backTouched() {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc func nextTouched(){
    guard let breed = self.petBreed, let name = self.petName, let gender = self.petGender else { return }
    let thirdVC = LoginThreeViewController()
    thirdVC.modalPresentationStyle = .fullScreen
    thirdVC.breedSelected = breed
    thirdVC.name = name
    thirdVC.genderChoose = gender
    self.navigationController?.pushViewController(thirdVC, animated: true)
  }
  
  @objc func breedSelectTouched(){
    let alert = UIAlertController(title: "견종 선택", message: nil, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "확인", style: .default) { _ in
      self.petBreed = self.pickerValue.isEmpty ? Pet.breeds[0] : self.pickerValue
      self.breedSelectButton.setTitle("\(self.petBreed!)", for: .normal)
    }
    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
    [okAction, cancelAction].forEach { alert.addAction($0) }
    
    let contentVC = UIViewController()
    contentVC.view = breedPickerView
    contentVC.preferredContentSize.height = 120 //height
    alert.setValue(contentVC, forKey: "contentViewController")
    
    self.present(alert, animated: true)
  }
}

// MARK:- UIPickerViewDataSource

extension LoginTwoViewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return Pet.breeds.count
  }
}

// MARK:- UIPickerViewDelegate

extension LoginTwoViewController: UIPickerViewDelegate {  
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    self.pickerValue = Pet.breeds[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return Pet.breeds[row]
  }
}

extension LoginTwoViewController: MyImageViewDelegate {
  func imageViewDidTap(_ gender: Gender, value: String) {
    maleImage.backgroundColor = (gender == .male) ? ColorReference.main : .clear
    femaleImage.backgroundColor = (gender == .male) ? .clear : ColorReference.main
    self.petGender = (gender == .male) ? "M" : "W"
    self.isGenderSelected = true
  }
}
