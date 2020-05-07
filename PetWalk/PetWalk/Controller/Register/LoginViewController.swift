//
//  LoginViewController.swift
//  Test
//
//  Created by 정유경 on 2020/01/13.
//  Copyright © 2020 정유경. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  
  // MARK: UI
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.text = "아이의 이름을 입력해주세요"
    label.numberOfLines = 0
    label.font = .systemFont(ofSize: 24, weight: .bold)
    return label
  }()
  
  private let underline: UIView = {
    let view = UIView()
    view.backgroundColor = ColorReference.main
    return view
  }()
  
  private let nextButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = ColorReference.Button.deactivate
    button.setTitle("다   음", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
    button.addTarget(self, action: #selector(nextTouched), for: .touchUpInside)
    return button
  }()
  
  private let inputField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "아이 이름"
    textField.font = .systemFont(ofSize: 20)
    textField.backgroundColor = .white
    textField.enablesReturnKeyAutomatically = true
    textField.becomeFirstResponder()
    return textField
  }()
  
  private var inputName : String?
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  func setupUI() {
    self.view.backgroundColor = .systemBackground
    self.navigationController?.navigationBar.isTranslucent = false
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationItem.title = "반려견 등록하기"
    
    let exitButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(exitTouched(_:)))
    exitButton.tintColor = .black
    
    let previous = self.navigationController?.presentingViewController
    self.navigationItem.rightBarButtonItem = (previous == nil) ? nil : exitButton
    
    [self.nameLabel, self.underline, self.nextButton, self.inputField]
    .forEach { self.view.addSubview($0) }
    self.inputField.delegate = self
    
    setupConstraints()
  }
  
  @objc private func exitTouched(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  // MARK: Initialize
  
  private struct UI {
    static var paddingX: CGFloat {
      get { return UIScreen.main.bounds.width / 10 }
    }
    static var paddingY: CGFloat {
      get { return UIScreen.main.bounds.height / 10 }
    }
    static let spacing: CGFloat = 8
    static let buttonHeightRatio: CGFloat = 0.15
  }
  
  func setupConstraints() {

    let guide = self.view.safeAreaLayoutGuide
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.nameLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: UI.paddingY),
      self.nameLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: UI.paddingX),
      self.nameLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -UI.paddingX),
    ])
    
    self.inputField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      inputField.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: UI.spacing * 3),
      inputField.leadingAnchor.constraint(equalTo: self.nameLabel.leadingAnchor),
      inputField.trailingAnchor.constraint(equalTo: self.nameLabel.trailingAnchor),
    ])
    
    self.underline.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.underline.topAnchor.constraint(equalTo: self.inputField.bottomAnchor, constant: UI.spacing),
      self.underline.leadingAnchor.constraint(equalTo: self.inputField.leadingAnchor),
      self.underline.trailingAnchor.constraint(equalTo: self.inputField.trailingAnchor),
      self.underline.heightAnchor.constraint(equalToConstant: 2),
    ])
    
    self.nextButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.nextButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
      self.nextButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
      self.nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      self.nextButton.heightAnchor.constraint(equalTo: guide.heightAnchor, multiplier: UI.buttonHeightRatio),
    ])
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    self.view.endEditing(true)
  }
  
  @objc func nextTouched(){
    guard let name = self.inputName else { return }
    let secondLoginVC = LoginTwoViewController()
    secondLoginVC.modalPresentationStyle = .fullScreen
    secondLoginVC.petName = name
    self.navigationController?.pushViewController(secondLoginVC, animated: true)
  }
}

// MARK:- UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard let input = textField.text, !input.isEmpty else { return false }
    self.inputName = input
    self.nextTouched()
    return true
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text, let range = Range(range, in: text) else { return true }
    let replacedText = text.replacingCharacters(in: range, with: string)
    if replacedText.isEmpty { self.nextButton.backgroundColor = ColorReference.Button.deactivate }
    else { self.nextButton.backgroundColor = ColorReference.Button.activate }
    self.inputName = replacedText
    return true
  }
}
