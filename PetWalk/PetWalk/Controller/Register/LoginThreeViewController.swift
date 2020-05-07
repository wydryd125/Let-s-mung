//
//  ResisterThreeViewController.swift
//  TrackWithPet
//
//  Created by Sunghyup Kim on 2020/01/15.
//  Copyright © 2020 SunghyupKim. All rights reserved.
//

import UIKit

class LoginThreeViewController: UIViewController {
  
  let photoLabel: UILabel = {
    let label = UILabel()
    label.text = "아이의 사진을 등록하세요"
    label.font = .systemFont(ofSize: 24, weight: .bold)
    return label
  }()
  let petImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .white
    imageView.layer.cornerRadius = 16
    imageView.layer.borderWidth = 1
    imageView.layer.borderColor = #colorLiteral(red: 0.7305480647, green: 0.7305480647, blue: 0.7305480647, alpha: 1)
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    return imageView
  }()
  let registerProfileButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = #colorLiteral(red: 0.4474043121, green: 0.7858899112, blue: 0.7191998518, alpha: 1)
    button.layer.cornerRadius = 8
    button.setTitle("사 진 등 록", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
    button.addTarget(self, action: #selector(registerButtonTouched), for: .touchUpInside)
    return button
  }()
  let birthLabel: UILabel = {
    let label = UILabel()
    label.text = "아이의 생일을 알려주세요"
    label.font = .systemFont(ofSize: 24, weight: .bold)
    return label
  }()
  let birthSelectButton: UIButton = {
    let button = UIButton()
    button.setTitle("생  일", for: .normal)
    button.setTitleColor(.placeholderText, for: .normal)
    button.addTarget(self, action: #selector(birthTouched(_:)), for: .touchUpInside)
    button.titleLabel?.font = .systemFont(ofSize: 20)
    button.contentHorizontalAlignment = .left
    return button
  }()
  let birthUnderline: UIView = {
    let underline = UIView()
    underline.backgroundColor = #colorLiteral(red: 0.4474043121, green: 0.7858899112, blue: 0.7191998518, alpha: 1)
    return underline
  }()
  let weightLabel: UILabel = {
    let label = UILabel()
    label.text = "아이의 몸무게를 알려주세요"
    label.font = .systemFont(ofSize: 24, weight: .bold)
    return label
  }()
  let weightSelectButton: UIButton = {
    let button = UIButton()
    button.setTitle("무  게", for: .normal)
    button.setTitleColor(.placeholderText, for: .normal)
    button.addTarget(self, action: #selector(weightTouched(_:)), for: .touchUpInside)
    button.contentHorizontalAlignment = .left
    button.titleLabel?.font = .systemFont(ofSize: 20)
    return button
  }()
  let weightUnderline: UIView = {
    let underline = UIView()
    underline.backgroundColor = #colorLiteral(red: 0.4474043121, green: 0.7858899112, blue: 0.7191998518, alpha: 1)
    return underline
  }()
  
  let completeButton: UIButton = {
    let button = UIButton()
    button.setTitle("완  료", for: .normal)
    button.backgroundColor = #colorLiteral(red: 0.7305480647, green: 0.7305480647, blue: 0.7305480647, alpha: 1)
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
    button.addTarget(self, action: #selector(completeTouched), for: .touchUpInside)
    return button
  }()
  var imagePicker = UIImagePickerController()
  var datePicker = UIDatePicker()
  
  let scrollView = UIScrollView()
  
  // MARK: Dispatched Data
  
  var name: String?
  var breedSelected: String?
  var genderChoose: String?
  
  // MARK: Pet Data
  
  var petBirth: String? {
    didSet {
      self.completeButton.backgroundColor = canCompleted ? ColorReference.Button.activate : ColorReference.Button.deactivate
    }
  }
  var petWeight: String? {
    didSet {
      self.completeButton.backgroundColor = canCompleted ? ColorReference.Button.activate : ColorReference.Button.deactivate
    }
  }
  var profileImage: UIImage? {
    didSet {
      self.completeButton.backgroundColor = canCompleted ? ColorReference.Button.activate : ColorReference.Button.deactivate
    }
  }
  private var canCompleted: Bool {
    get { return  (self.profileImage != nil && petWeight != nil && self.petBirth != nil) }
  }
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  // MARK: Initialize
  
  func setupUI() {
    self.setupAttributes()
    self.setupNavigationBar()
    self.setupConstraints()
  }
  
  private func setupAttributes() {
    self.view.backgroundColor = .systemBackground
    
    imagePicker.delegate = self
    
    datePicker.datePickerMode = .date
    datePicker.locale = .init(identifier: "ko_kr")
    datePicker.addTarget(self, action: #selector(dateSelected(_:)), for: .valueChanged)
  }
  
  private func setupNavigationBar(){
    self.navigationItem.title = "반려견 등록하기"
    
    let dismissItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backTouched))
    dismissItem.tintColor = .black
    self.navigationItem.leftBarButtonItem = dismissItem
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
    static let margin: CGFloat = 8
  }
  func setupConstraints() {
    [self.scrollView, self.completeButton].forEach { self.view.addSubview($0) }
    let guide = self.view.safeAreaLayoutGuide
    self.scrollView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.scrollView.topAnchor.constraint(equalTo: guide.topAnchor),
      self.scrollView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
      self.scrollView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
    ])
    
    completeButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      completeButton.topAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
      completeButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
      completeButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
      completeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      completeButton.heightAnchor.constraint(equalTo: guide.heightAnchor, multiplier: UI.buttonHeightRatio),
    ])
    
    [self.photoLabel, self.petImageView, self.registerProfileButton,
     self.birthLabel, self.birthSelectButton, self.birthUnderline,
     self.weightLabel, self.weightSelectButton, self.weightUnderline,]
      .forEach { self.scrollView.addSubview($0) }
    
    photoLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      photoLabel.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: UI.paddingY),
      photoLabel.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: UI.paddingX),
      photoLabel.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -UI.paddingX),
      photoLabel.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, constant: -UI.paddingX * 2)
    ])
    
    petImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      petImageView.topAnchor.constraint(equalTo: photoLabel.bottomAnchor, constant: UI.spacing),
      petImageView.leadingAnchor.constraint(equalTo: photoLabel.leadingAnchor, constant: UI.margin),
      petImageView.trailingAnchor.constraint(equalTo: photoLabel.trailingAnchor, constant: -UI.margin),
      petImageView.heightAnchor.constraint(equalToConstant: 200),
    ])

    registerProfileButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      registerProfileButton.bottomAnchor.constraint(equalTo: petImageView.bottomAnchor, constant: -UI.spacing),
      registerProfileButton.leadingAnchor.constraint(equalTo: petImageView.leadingAnchor, constant: UI.spacing * 3),
      registerProfileButton.trailingAnchor.constraint(equalTo: petImageView.trailingAnchor, constant: -UI.spacing * 3),
    ])

    birthLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      birthLabel.topAnchor.constraint(equalTo: petImageView.bottomAnchor, constant: UI.paddingY / 2),
      birthLabel.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: UI.paddingX),
      birthLabel.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -UI.paddingX),
    ])

    birthSelectButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      birthSelectButton.topAnchor.constraint(equalTo: birthLabel.bottomAnchor, constant: UI.spacing),
      birthSelectButton.leadingAnchor.constraint(equalTo: birthLabel.leadingAnchor, constant: UI.margin),
      birthSelectButton.trailingAnchor.constraint(equalTo: birthLabel.trailingAnchor, constant: -UI.margin),
    ])

    birthUnderline.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      birthUnderline.topAnchor.constraint(equalTo: birthSelectButton.bottomAnchor),
      birthUnderline.leadingAnchor.constraint(equalTo: birthSelectButton.leadingAnchor),
      birthUnderline.trailingAnchor.constraint(equalTo: birthSelectButton.trailingAnchor),
      birthUnderline.heightAnchor.constraint(equalToConstant: 2),
    ])

    weightLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      weightLabel.topAnchor.constraint(equalTo: birthUnderline.bottomAnchor, constant: UI.paddingY / 2),
      weightLabel.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: UI.paddingX),
      weightLabel.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -UI.paddingX),
    ])

    weightSelectButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      weightSelectButton.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: UI.spacing),
      weightSelectButton.leadingAnchor.constraint(equalTo: weightLabel.leadingAnchor, constant: UI.margin),
      weightSelectButton.trailingAnchor.constraint(equalTo: weightLabel.trailingAnchor, constant: -UI.margin),
    ])

    weightUnderline.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      weightUnderline.topAnchor.constraint(equalTo: weightSelectButton.bottomAnchor),
      weightUnderline.leadingAnchor.constraint(equalTo: weightSelectButton.leadingAnchor),
      weightUnderline.trailingAnchor.constraint(equalTo: weightSelectButton.trailingAnchor),
      weightUnderline.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -UI.paddingY),
      weightUnderline.heightAnchor.constraint(equalToConstant: 2),
    ])
    
  }
  
  // MARK: Actions
  
  @objc private func weightTouched(_ sender: UIButton) {
    let alert = UIAlertController(title: "무  게", message: nil, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "확인", style: .default) { (_) in
      if let weightInputText = alert.textFields?[0].text, !weightInputText.isEmpty {
        self.petWeight = weightInputText
        self.weightSelectButton.setTitle(self.petWeight! + " kg", for: .normal)
        self.weightSelectButton.setTitleColor(.black, for: .normal)
      }
    }
    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: .none)
    alert.addTextField {
      $0.placeholder = "무게를 입력하세요."
      $0.keyboardType = .numberPad
      $0.isSecureTextEntry = false
    }
    alert.addAction(okAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
  }
  
  @objc private func birthTouched(_ sender: UIButton) {
    let alert = UIAlertController(title: "생  일", message: nil, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "확인", style: .default) { (_) in
      if self.dateValue.isEmpty {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "yyyy-MM-dd"
        self.petBirth = formatter.string(from: Date())
      } else {
        self.petBirth = self.dateValue
      }
      self.birthSelectButton.setTitle(self.petBirth!, for: .normal)
      self.birthSelectButton.setTitleColor(.black, for: .normal)
      self.dateValue = ""
    }
    let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
      self.dateValue = ""
    }
    alert.addAction(okAction)
    alert.addAction(cancelAction)
    
    let contentVC = UIViewController()
    contentVC.view = self.datePicker
    contentVC.preferredContentSize.height = 120 //height
    alert.setValue(contentVC, forKey: "contentViewController")
    
    present(alert, animated: true, completion: nil)
  }
  
  @objc func backTouched() {
    self.navigationController?.popViewController(animated: true)
  }
  
  private var dateValue = ""
  @objc func dateSelected(_ sender: UIDatePicker) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    self.dateValue = dateFormatter.string(from: datePicker.date)
    view.endEditing(true)
  }
  
  @objc func completeTouched(){
    guard
      let name = self.name,
      let gender = self.genderChoose,
      let breed = self.breedSelected,
      let image = self.profileImage,
      let birth = self.petBirth,
      let weight = self.petWeight
      else { return }
    
    let loadingVC = LoadingViewController()
    present(loadingVC, animated: false)
    
    StorageProvider.uploadProfileImage(image, for: "pet_\(name)") { (url) in
      let newPet = Pet(key: "", name: name, breed: breed, gender: gender, birth: birth, weight: weight, profileURL: url)
      DataProvider.register(pet: newPet) { (isSucceed) in
        if isSucceed {
          DataProvider.requestPets {
            PetManager.shared.currentPets = $0
            let main = ViewControllerGenerator.make(type: .main)
            loadingVC.complete { self.present(main, animated: true) }
          }
        } else {
          loadingVC.fail(message: "동일한 이름이 존재합니다.")
        }
      }
    }
  }
  
  @objc func registerButtonTouched() {
    present(imagePicker, animated: true)
  }
}

// MARK:- UIImagePickerController

extension LoginThreeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    imagePicker.dismiss(animated: true, completion: nil)
    guard let image = info[.originalImage] as? UIImage else { return }
    self.petImageView.image = image
    registerProfileButton.alpha = 0
    profileImage = image
  }
  
}
