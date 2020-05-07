//
//  LoadingViewController.swift
//  PetWalk
//
//  Created by cskim on 2020/01/17.
//  Copyright © 2020 cskim. All rights reserved.
//

import UIKit

protocol LoadingViewControllerInterface {
  func complete(completion: @escaping ()->())
  func fail(message: String)
}

class LoadingViewController: UIViewController, LoadingViewControllerInterface {
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    self.modalPresentationStyle = .overFullScreen
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private let indicatorView: UIActivityIndicatorView = {
    let indicatorView = UIActivityIndicatorView()
    indicatorView.hidesWhenStopped = true
    indicatorView.color = .lightGray
    indicatorView.style = .large
    return indicatorView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(self.indicatorView)
    
    self.indicatorView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.indicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      self.indicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
      self.indicatorView.widthAnchor.constraint(equalTo: self.indicatorView.heightAnchor, multiplier: 1.0),
      self.indicatorView.widthAnchor.constraint(equalToConstant: 120),
    ])
    self.view.backgroundColor = UIColor.clear.withAlphaComponent(0.5)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.indicatorView.startAnimating()
  }
  
  func complete(completion: @escaping ()->()) {
    self.indicatorView.stopAnimating()
    dismiss(animated: false) {
      completion()
    }
  }
  
  func fail(message: String) {
    self.indicatorView.stopAnimating()
    let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
    let action = UIAlertAction(title: "확인", style: .default) { _ in
      self.dismiss(animated: false, completion: nil)
    }
    alert.addAction(action)
    present(alert, animated: true)
  }  
}
