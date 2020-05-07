//
//  FirstViewController.swift
//  Temp
//
//  Created by 정유경 on 2020/01/15.
//  Copyright © 2020 정유경. All rights reserved.
//

import UIKit
import MobileCoreServices

class MainViewController: UIViewController {
  
  private let mainImageContainer = MainImageContainer()
  private let weatherInfoContainer = WeatherInfoContainer()
  private let startButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "play"), for: .normal)
    button.addTarget(self, action: #selector(startButtonTouched(_:)), for: .touchUpInside)
    button.layer.borderWidth = 8
    button.layer.borderColor = ColorReference.main.cgColor
    button.layer.cornerRadius = UI.buttonSize / 2
    return button
  }()
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupUI()
    self.mainImageContainer.setPetImage(UIImage(named: selectedPet.breed))
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if PetManager.shared.isGoalAchieved {
      self.mainImageContainer.animate(mode: .animateBone)
      PetManager.shared.isGoalAchieved.toggle()
    } else {
      self.mainImageContainer.animate(mode: .petDefault)
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
//    self.mainImageContainer.animate(mode: .stop)
  }
  
  private func setupUI() {
    self.setupAttributes()
    self.setupNavigationBar()
    self.setupConstraints()
  }
  
  private func setupAttributes() {
    self.view.backgroundColor = .systemBackground
  }
  
  private func setupNavigationBar() {
    let addPetButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addPetTouched(_:)))
    self.navigationItem.rightBarButtonItem = addPetButton
    
    let selectPetButton = UIButton(type: .system)
    selectPetButton.setTitle("강아지 선택하기 ▼", for: .normal)
    selectPetButton.setPreferredSymbolConfiguration(.init(scale: .large), forImageIn: .normal)
    selectPetButton.addTarget(self, action: #selector(selectPetTouched(_:)), for: .touchUpInside)
    self.navigationItem.titleView = selectPetButton
    
  }
  
  private struct UI {
    static let buttonSize: CGFloat = 120
    static let paddingX: CGFloat = 8
  }
  
  private func setupConstraints() {
    [self.mainImageContainer, self.weatherInfoContainer, self.startButton]
      .forEach { self.view.addSubview($0) }
  
    let guide = self.view.safeAreaLayoutGuide
    self.mainImageContainer.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.mainImageContainer.topAnchor.constraint(equalTo: guide.topAnchor),
      self.mainImageContainer.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: UI.paddingX * 2),
      self.mainImageContainer.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -UI.paddingX * 2),
    ])
    
    self.weatherInfoContainer.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.weatherInfoContainer.topAnchor.constraint(equalTo: self.mainImageContainer.bottomAnchor, constant: UI.paddingX * 3),
      self.weatherInfoContainer.leadingAnchor.constraint(equalTo: self.mainImageContainer.leadingAnchor, constant: UI.paddingX * 6),
      self.weatherInfoContainer.trailingAnchor.constraint(equalTo: self.mainImageContainer.trailingAnchor, constant: -UI.paddingX * 6),
    ])
    
    self.startButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.startButton.topAnchor.constraint(equalTo: self.weatherInfoContainer.bottomAnchor, constant: UI.paddingX * 3),
      self.startButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -UI.paddingX * 3),
      self.startButton.centerXAnchor.constraint(equalTo: self.weatherInfoContainer.centerXAnchor),
      self.startButton.widthAnchor.constraint(equalToConstant: UI.buttonSize),
      self.startButton.heightAnchor.constraint(equalTo: self.startButton.widthAnchor, multiplier: 1.0),
    ])
  }
  
  // MARK: Actions
  
  @objc private func addPetTouched(_ sender: UIBarButtonItem) {
    let signUpVC = ViewControllerGenerator.make(type: .signUp)
    present(signUpVC, animated: true)
  }
  
  private var selectedPet: Pet = PetManager.shared.currentPets.first!
  @objc private func selectPetTouched(_ sender: UIButton) {
    let petSheet = UIAlertController(title: "아이를 선택해주세요", message: nil, preferredStyle: .actionSheet)
    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    petSheet.addAction(cancelAction)
    PetManager.shared.currentPets.forEach { (pet) in
      let action = UIAlertAction(title: pet.name, style: .default) { (action) in
        self.selectedPet = pet
        self.mainImageContainer.setPetImage(UIImage(named: self.selectedPet.breed))
      }
      petSheet.addAction(action)
    }
    present(petSheet, animated: true, completion: nil)
  }
  
  @objc private func startButtonTouched(_ sender: UIButton) {
    let alert = UIAlertController(title: "\(self.selectedPet.name)와 산책을 시작할까요?", message: nil, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "확인", style: .default) { _ in
      let secondVC = WalkViewController()
      secondVC.pet = self.selectedPet
      secondVC.modalPresentationStyle = .fullScreen
      self.present(secondVC, animated: true)
    }
    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
    alert.addAction(okAction)
    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)
    
  }
}
